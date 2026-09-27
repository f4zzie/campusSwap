// Audits the seeded favourite documents: what exists versus what the dataset
// expects, per user. Reads each user's own favourites collection (the rules
// only allow a user to read their own).
//
//   node scripts/audit_favorites.mjs

import { DEMO_PASSWORD, DEMO_USERS, EXTRA_FAVORITES, LISTINGS } from './demo_data.mjs';

const PROJECT = 'campusswap-2c21f';
const API_KEY = 'AIzaSyCSmkksxzKFqSmJGmsqxgiXeAsindvy2O0';
const IDENTITY = 'https://identitytoolkit.googleapis.com/v1';
const DOCS = `https://firestore.googleapis.com/v1/projects/${PROJECT}/databases/(default)/documents`;

async function signIn(email, password) {
  const r = await fetch(`${IDENTITY}/accounts:signInWithPassword?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const d = await r.json();
  if (!d.idToken) throw new Error(`sign-in failed for ${email}: ${d.error?.message}`);
  return d.idToken;
}

async function listFavorites(token, uid) {
  const res = await fetch(`${DOCS}/users/${uid}/favorites?pageSize=300`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) throw new Error(`HTTP ${res.status} ${await res.text()}`);
  const body = await res.json();
  return (body.documents ?? []).map((d) => d.name.split('/').pop());
}

async function readCounter(token, path, field) {
  const res = await fetch(`${DOCS}/${path}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const body = await res.json();
  const v = body.fields?.[field];
  return v ? Number(v.integerValue ?? v.doubleValue ?? 0) : 0;
}

// What the dataset intends, per user.
const expected = {};
const pairs = [
  ...LISTINGS.flatMap((s) => (s.favorites ?? []).map((uid) => [uid, s.key])),
  ...EXTRA_FAVORITES,
];
for (const [uid, key] of pairs) {
  expected[uid] ??= new Set();
  expected[uid].add(`demo-${key}`);
}

const tokens = {};
for (const u of DEMO_USERS) tokens[u.uid] = await signIn(u.email, DEMO_PASSWORD);

console.log('\nFavourites per user: stored vs expected\n');
let totalStored = 0;
for (const u of DEMO_USERS) {
  const stored = new Set(await listFavorites(tokens[u.uid], u.uid));
  const want = expected[u.uid] ?? new Set();
  totalStored += stored.size;
  const missing = [...want].filter((id) => !stored.has(id));
  const extra = [...stored].filter((id) => !want.has(id));
  const flag = missing.length || extra.length ? '  <-- mismatch' : '';
  console.log(
    `  ${u.displayName.padEnd(16)} stored ${String(stored.size).padStart(2)}  expected ${String(want.size).padStart(2)}${flag}`,
  );
  if (missing.length) console.log(`      missing: ${missing.join(', ')}`);
  if (extra.length) console.log(`      extra  : ${extra.join(', ')}`);
}
console.log(`\n  total favourite documents stored: ${totalStored}`);

console.log('\nListing counters vs favourite documents\n');
let drift = 0;
for (const spec of LISTINGS) {
  const id = `demo-${spec.key}`;
  const actual = (pairs.filter(([, k]) => k === spec.key)).length;
  const unique = new Set(pairs.filter(([, k]) => k === spec.key).map(([u]) => u)).size;
  const counter = await readCounter(tokens[spec.seller], `listings/${id}`, 'favoriteCount');
  if (counter !== unique) {
    drift++;
    console.log(
      `  ${id.padEnd(28)} counter ${String(counter).padStart(2)}  favourites ${unique}  (pairs ${actual})`,
    );
  }
}
if (!drift) console.log('  all counters match the number of favourite documents');
console.log('');
