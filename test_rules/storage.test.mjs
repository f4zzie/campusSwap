// CampusSwap — Storage security-rules integration tests.
//
// Runs against the local Storage emulator (started by `firebase emulators:exec`).
// Covers the three upload paths (listing photos, profile photos, chat photos),
// the verified/owner/content-type/size gates, and the default-deny catch-all.
//
//   firebase emulators:exec --only storage "node test_rules/storage.test.mjs"

import {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} from '@firebase/rules-unit-testing';
import { ref, uploadBytes, getBytes } from 'firebase/storage';
import { readFileSync } from 'node:fs';

const PROJECT = 'campusswap-2c21f';
const JPEG = { contentType: 'image/jpeg' };
const PDF = { contentType: 'application/pdf' };
const small = () => new Uint8Array(16); // tiny "image"
const tooBig = () => new Uint8Array(5 * 1024 * 1024 + 1); // 5MB + 1 byte

const rows = [];
let pass = 0;
let fail = 0;
async function test(name, fn) {
  try {
    await fn();
    rows.push(['PASS', name, '']);
    pass++;
  } catch (e) {
    rows.push(['FAIL', name, e.message || String(e)]);
    fail++;
  }
}

const env = await initializeTestEnvironment({
  projectId: PROJECT,
  storage: {
    rules: readFileSync(new URL('../storage.rules', import.meta.url), 'utf8'),
    host: '127.0.0.1',
    port: 9199,
  },
});

const verified = (uid) =>
  env.authenticatedContext(uid, { email_verified: true }).storage();
const unverified = (uid) =>
  env.authenticatedContext(uid, { email_verified: false }).storage();
const guest = env.unauthenticatedContext().storage();

const alice = verified('alice');
const bob = verified('bob');
const newbie = unverified('newbie');

// Seed one readable object at a public listing path (rules disabled).
await env.withSecurityRulesDisabled(async (ctx) => {
  await uploadBytes(ref(ctx.storage(), 'listings/alice/L1/seed.jpg'), small(), JPEG);
  await uploadBytes(ref(ctx.storage(), 'chat_images/c1/seed.jpg'), small(), JPEG);
});

// listing photos --------------------------------------------------------------
await test('owner uploads an image to own listing path', () =>
  assertSucceeds(uploadBytes(ref(alice, 'listings/alice/L1/photo.jpg'), small(), JPEG)));
await test('cannot upload to another user\'s listing path', () =>
  assertFails(uploadBytes(ref(bob, 'listings/alice/L1/photo.jpg'), small(), JPEG)));
await test('unverified user cannot upload a listing photo', () =>
  assertFails(uploadBytes(ref(newbie, 'listings/newbie/L1/photo.jpg'), small(), JPEG)));
await test('non-image content type is rejected', () =>
  assertFails(uploadBytes(ref(alice, 'listings/alice/L1/doc.pdf'), small(), PDF)));
await test('image larger than 5MB is rejected', () =>
  assertFails(uploadBytes(ref(alice, 'listings/alice/L1/huge.jpg'), tooBig(), JPEG)));
await test('anyone may read a listing photo (public)', () =>
  assertSucceeds(getBytes(ref(guest, 'listings/alice/L1/seed.jpg'))));

// profile photos --------------------------------------------------------------
await test('owner uploads own profile photo', () =>
  assertSucceeds(uploadBytes(ref(alice, 'profile_images/alice/avatar.jpg'), small(), JPEG)));
await test('cannot upload to another user\'s profile path', () =>
  assertFails(uploadBytes(ref(bob, 'profile_images/alice/avatar.jpg'), small(), JPEG)));

// chat photos -----------------------------------------------------------------
await test('any verified user uploads a chat photo', () =>
  assertSucceeds(uploadBytes(ref(bob, 'chat_images/c1/photo.jpg'), small(), JPEG)));
await test('unverified user cannot upload a chat photo', () =>
  assertFails(uploadBytes(ref(newbie, 'chat_images/c1/photo.jpg'), small(), JPEG)));
await test('unauthenticated user cannot read a chat photo', () =>
  assertFails(getBytes(ref(guest, 'chat_images/c1/seed.jpg'))));
await test('verified user reads a chat photo', () =>
  assertSucceeds(getBytes(ref(alice, 'chat_images/c1/seed.jpg'))));

// catch-all -------------------------------------------------------------------
await test('writing outside the known paths is denied', () =>
  assertFails(uploadBytes(ref(alice, 'random/whatever.jpg'), small(), JPEG)));

await env.cleanup();

console.log('\n=============== CampusSwap storage rules test results ===============\n');
for (const [status, name, err] of rows) {
  const mark = status === 'PASS' ? '  ✓' : '  ✗';
  console.log(`${mark} ${name.padEnd(52)}${err ? '  <-- ' + err : ''}`);
}
console.log(`\n====================================================================`);
console.log(`  ${pass} passed, ${fail} failed, ${pass + fail} total`);
console.log(`====================================================================\n`);

process.exit(fail === 0 ? 0 : 1);
