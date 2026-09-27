// Diagnostic: can a student move the counters on SOMEONE ELSE'S listing?
//
// The app does exactly this in two places:
//   FirestoreRepository.setFavorite    -> favoriteCount: FieldValue.increment(±1)
//   FirestoreRepository.incrementViewCount -> viewCount: FieldValue.increment(1)
// both against listings owned by other users. This probe checks whether the
// LIVE rules engine accepts that, versus a read-then-write literal value.
//
//   node scripts/probe_other_listing_counters.mjs

const PROJECT = 'campusswap-2c21f';
const API_KEY = 'AIzaSyCSmkksxzKFqSmJGmsqxgiXeAsindvy2O0';
const IDENTITY = 'https://identitytoolkit.googleapis.com/v1';
const DOCS = `https://firestore.googleapis.com/v1/projects/${PROJECT}/databases/(default)/documents`;

const docName = (p) => `projects/${PROJECT}/databases/(default)/documents/${p}`;

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

/** Current counter value, read as the signed-in user. */
async function readCounter(token, path, field) {
  const res = await fetch(`${DOCS}/${path}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const doc = await res.json();
  const v = doc.fields?.[field];
  return v ? Number(v.integerValue ?? v.doubleValue) : 0;
}

async function attempt(label, fn) {
  try {
    await fn();
    console.log(`  ✓ ALLOWED  ${label}`);
    return true;
  } catch (e) {
    console.log(`  ✗ DENIED   ${label}\n        ${e.message}`);
    return false;
  }
}

const david = await signIn('david.kimani@campusswap.test', 'DemoStudent2026');
// demo-calculus belongs to seedAmina, not to David.
const target = 'listings/demo-calculus';

console.log('\nActing as seedDavid on a listing owned by seedAmina\n');
console.log(`  (current viewCount=${await readCounter(david, target, 'viewCount')},` +
  ` favoriteCount=${await readCounter(david, target, 'favoriteCount')})\n`);

console.log('Exactly what the app sends:');
await attempt('viewCount via FieldValue.increment(1)', () =>
  commit(david, [
    {
      update: { name: docName(target), fields: {} },
      updateMask: { fieldPaths: ['viewCount'] },
      updateTransforms: [{ fieldPath: 'viewCount', increment: { integerValue: '1' } }],
    },
  ]));

await attempt('favoriteCount via FieldValue.increment(1)', () =>
  commit(david, [
    {
      update: { name: docName(target), fields: {} },
      updateMask: { fieldPaths: ['favoriteCount'] },
      updateTransforms: [
        { fieldPath: 'favoriteCount', increment: { integerValue: '1' } },
      ],
    },
  ]));

console.log('\nRead-then-write a literal value instead:');
const views = await readCounter(david, target, 'viewCount');
await attempt(`viewCount literal ${views} -> ${views + 1}`, () =>
  commit(david, [
    {
      update: {
        name: docName(target),
        fields: { viewCount: { integerValue: String(views + 1) } },
      },
      updateMask: { fieldPaths: ['viewCount'] },
    },
  ]));

const favs = await readCounter(david, target, 'favoriteCount');
await attempt(`favoriteCount literal ${favs} -> ${favs + 1}`, () =>
  commit(david, [
    {
      update: {
        name: docName(target),
        fields: { favoriteCount: { integerValue: String(favs + 1) } },
      },
      updateMask: { fieldPaths: ['favoriteCount'] },
    },
  ]));

console.log('');
