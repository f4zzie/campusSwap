// Diagnostic: which favourite-counter write form does the LIVE backend accept?
// Uses throwaway documents under a temp listing and cleans up after itself.
//
//   node scripts/probe_favorite_write.mjs

import { API_KEY, DEMO_PASSWORD, PROJECT } from './runtime_config.mjs';

const IDENTITY = 'https://identitytoolkit.googleapis.com/v1';
const DOCS = `https://firestore.googleapis.com/v1/projects/${PROJECT}/databases/(default)/documents`;
const SERVER = Symbol('server');

const docName = (p) => `projects/${PROJECT}/databases/(default)/documents/${p}`;

const toValue = (v) => {
  if (v === null || v === undefined) return { nullValue: null };
  if (typeof v === 'string') return { stringValue: v };
  if (typeof v === 'boolean') return { booleanValue: v };
  if (typeof v === 'number')
    return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
  if (Array.isArray(v)) return { arrayValue: { values: v.map(toValue) } };
  if (typeof v === 'object') {
    const fields = {};
    for (const [k, val] of Object.entries(v)) fields[k] = toValue(val);
    return { mapValue: { fields } };
  }
  throw new Error(`bad value ${v}`);
};

function buildWrite(path, data, { create = false } = {}) {
  const fields = {};
  const transforms = [];
  for (const [k, v] of Object.entries(data)) {
    if (v === SERVER) transforms.push({ fieldPath: k, setToServerValue: 'REQUEST_TIME' });
    else fields[k] = toValue(v);
  }
  const w = { update: { name: docName(path), fields } };
  if (transforms.length) w.updateTransforms = transforms;
  if (create) w.currentDocument = { exists: false };
  else w.updateMask = { fieldPaths: [...Object.keys(data)] };
  return w;
}

const incrementWrite = (path, fieldPath, by) => ({
  update: { name: docName(path), fields: {} },
  updateMask: { fieldPaths: [fieldPath] },
  updateTransforms: [{ fieldPath, increment: { integerValue: String(by) } }],
});

// The other REST spelling: a document-level transform write.
const transformWrite = (path, fieldPath, by) => ({
  transform: {
    document: docName(path),
    fieldTransforms: [{ fieldPath, increment: { integerValue: String(by) } }],
  },
});

async function commit(token, writes) {
  const res = await fetch(`${DOCS}:commit`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify({ writes }),
  });
  if (!res.ok) {
    const body = await res.text();
    let m = body;
    try {
      m = JSON.parse(body).error?.message ?? body;
    } catch {}
    throw new Error(m.trim().split('\n')[0]);
  }
}

async function attempt(label, fn) {
  try {
    await fn();
    console.log(`  ✓ ${label}`);
    return true;
  } catch (e) {
    console.log(`  ✗ ${label}\n      ${e.message}`);
    return false;
  }
}

const res = await fetch(`${IDENTITY}/accounts:signInWithPassword?key=${API_KEY}`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    email: process.env.CAMPUSSWAP_DEMO_SIGNIN_EMAIL?.trim() || 'david.kimani@campusswap.test',
    password: DEMO_PASSWORD,
    returnSecureToken: true,
  }),
});
const token = (await res.json()).idToken;
if (!token) throw new Error('could not sign in as seedDavid');

const tmp = 'demo-tmp-probe';
const listing = {
  id: tmp,
  sellerId: 'seedDavid',
  sellerName: 'David Kimani',
  sellerPhoto: null,
  title: 'Temporary probe listing',
  description: 'Throwaway listing used to probe write forms; deleted afterwards.',
  price: 1,
  category: 'other',
  condition: 'good',
  type: 'sale',
  campus: 'Thika Road',
  author: null,
  courseCode: null,
  isbn: null,
  favoriteCount: 0,
  imageUrls: [],
  status: 'active',
  createdAt: SERVER,
  updatedAt: SERVER,
  searchKeywords: [],
  viewCount: 0,
};

console.log('\nLive probe as seedDavid\n');

// A listing to poke at.
await commit(token, [buildWrite(`listings/${tmp}`, listing, { create: true })]);
await commit(token, [
  buildWrite(`listings/${tmp}`, { viewCount: 50, updatedAt: SERVER }),
]);
console.log('  (created throwaway listing demo-tmp-probe)');

console.log('\n1. Favourite subcollection doc on its own:');
await attempt('set users/seedDavid/favorites/demo-tmp-probe', () =>
  commit(token, [
    buildWrite(`users/seedDavid/favorites/${tmp}`, { savedAt: SERVER }, { create: true }),
  ]));

console.log('\n2. Counter moved by an increment transform (update+mask):');
await attempt('favoriteCount +1 via updateTransforms', () =>
  commit(token, [incrementWrite(`listings/${tmp}`, 'favoriteCount', 1)]));

console.log('\n3. Counter moved by a document transform write:');
await attempt('favoriteCount +1 via transform', () =>
  commit(token, [transformWrite(`listings/${tmp}`, 'favoriteCount', 1)]));

console.log('\n4. Counter written as a literal value:');
await attempt('favoriteCount = 2 (literal)', () =>
  commit(token, [
    buildWrite(`listings/${tmp}`, { favoriteCount: 2, updatedAt: SERVER }),
  ]));

console.log('\n5. Favourite doc + counter bumped in ONE atomic commit:');
await attempt('favorite doc + increment together', () =>
  commit(token, [
    buildWrite(`users/seedDavid/favorites/${tmp}-atomic`, { savedAt: SERVER }, { create: true }),
    incrementWrite(`listings/${tmp}`, 'favoriteCount', 1),
  ]));

console.log('\n6. Same, but the counter as a literal in the same commit:');
await attempt('favorite doc + literal counter together', () =>
  commit(token, [
    buildWrite(`users/seedDavid/favorites/${tmp}-atomic2`, { savedAt: SERVER }, { create: true }),
    buildWrite(`listings/${tmp}`, { favoriteCount: 5, updatedAt: SERVER }),
  ]));

// --- clean up --------------------------------------------------------------
console.log('\nCleaning up the throwaway documents...');
for (const fav of [`${tmp}`, `${tmp}-atomic`, `${tmp}-atomic2`]) {
  try {
    await commit(token, [{ delete: docName(`users/seedDavid/favorites/${fav}`) }]);
  } catch {}
}
try {
  await commit(token, [{ delete: docName(`listings/${tmp}`) }]);
} catch (e) {
  console.log(`  ! could not delete ${tmp}: ${e.message}`);
}
console.log('  done\n');
