// CampusSwap — Firestore security-rules integration tests.
//
// Runs against the local Firestore emulator (started by `firebase emulators:exec`).
// Exercises every collection's contract with verified / unverified / owner /
// non-owner / anonymous personas, covering positive AND negative cases so the
// suite documents exactly what each screen is allowed to do.
//
//   npm --prefix test_rules test
//   # or: firebase emulators:exec --only firestore "node test_rules/firestore.test.mjs"

import {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} from '@firebase/rules-unit-testing';
import {
  doc,
  setDoc,
  getDoc,
  updateDoc,
  deleteDoc,
  serverTimestamp,
  Timestamp,
} from 'firebase/firestore';
import { readFileSync } from 'node:fs';

const PROJECT = 'campusswap-2c21f';
const T0 = Timestamp.fromDate(new Date('2020-01-01T00:00:00Z')); // fixed "old" time

// ---- tiny test harness -----------------------------------------------------
const rows = [];
let pass = 0;
let fail = 0;
async function test(section, name, fn) {
  try {
    await fn();
    rows.push(['PASS', section, name, '']);
    pass++;
  } catch (e) {
    rows.push(['FAIL', section, name, e.message || String(e)]);
    fail++;
  }
}

const env = await initializeTestEnvironment({
  projectId: PROJECT,
  firestore: {
    rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
    host: '127.0.0.1',
    port: 8080,
  },
});

// ---- personas --------------------------------------------------------------
const verified = (uid, email) =>
  env.authenticatedContext(uid, { email, email_verified: true }).firestore();
const unverified = (uid, email) =>
  env.authenticatedContext(uid, { email, email_verified: false }).firestore();

const alice = verified('alice', 'alice@uni.edu'); // seller / owner
const bob = verified('bob', 'bob@uni.edu'); // buyer / offerer
const carol = verified('carol', 'carol@uni.edu'); // unrelated third party
const newbie = unverified('newbie', 'newbie@uni.edu'); // authed, not verified
const guest = env.unauthenticatedContext().firestore(); // signed out

// ---- payload helpers -------------------------------------------------------
const profile = (uid, email, extra = {}) => ({
  id: uid,
  email,
  displayName: 'Test User',
  university: 'Uni',
  fcmTokens: [],
  rating: 0,
  ratingCount: 0,
  role: 'user',
  createdAt: serverTimestamp(),
  ...extra,
});

const listing = (sellerId, extra = {}) => ({
  id: 'L',
  sellerId,
  sellerName: 'Alice',
  title: 'A valid listing title',
  description: 'A sufficiently long description of the item.',
  price: 100,
  category: 'textbooks',
  condition: 'good',
  type: 'sale',
  campus: 'Main',
  favoriteCount: 0,
  imageUrls: ['https://x/1.jpg'],
  status: 'active',
  searchKeywords: [],
  viewCount: 0,
  createdAt: serverTimestamp(),
  updatedAt: serverTimestamp(),
  ...extra,
});

const seededListing = (sellerId, extra = {}) => ({
  ...listing(sellerId),
  createdAt: T0,
  updatedAt: T0,
  ...extra,
});

const conversation = (extra = {}) => ({
  id: 'c',
  listingId: 'L',
  listingTitle: 'T',
  buyerId: 'bob',
  buyerName: 'Bob',
  sellerId: 'alice',
  sellerName: 'Alice',
  participantIds: ['bob', 'alice'],
  lastMessage: '',
  lastMessageAt: serverTimestamp(),
  unreadBy: [],
  unreadCounts: {},
  createdAt: serverTimestamp(),
  ...extra,
});

const swap = (extra = {}) => ({
  id: 's',
  listingId: 'L',
  listingTitle: 'T',
  offererId: 'bob',
  ownerId: 'alice',
  participantIds: ['bob', 'alice'],
  offeredListingId: null,
  offeredListingTitle: null,
  message: 'Wanna swap?',
  status: 'pending',
  createdAt: serverTimestamp(),
  updatedAt: serverTimestamp(),
  ...extra,
});

const notif = (extra = {}) => ({
  id: 'n',
  title: 'New message',
  body: 'You have a message',
  type: 'message',
  relatedId: null,
  read: false,
  createdAt: serverTimestamp(),
  ...extra,
});

// ---- seed data that update/read tests depend on (rules disabled) -----------
await env.withSecurityRulesDisabled(async (ctx) => {
  const db = ctx.firestore();
  await setDoc(doc(db, 'listings/l_read'), seededListing('alice'));
  await setDoc(doc(db, 'listings/l_edit'), seededListing('alice'));
  await setDoc(doc(db, 'listings/l_view'), seededListing('alice', { viewCount: 0 }));
  await setDoc(doc(db, 'listings/l_fav'), seededListing('alice', { favoriteCount: 0 }));
  await setDoc(doc(db, 'listings/l_del'), seededListing('alice'));
  await setDoc(doc(db, 'conversations/c1'), conversation({ createdAt: T0 }));
  await setDoc(doc(db, 'swaps/s_accept'), swap({ createdAt: T0, updatedAt: T0 }));
  await setDoc(doc(db, 'swaps/s_cancel'), swap({ createdAt: T0, updatedAt: T0 }));
  await setDoc(doc(db, 'swaps/s_offacc'), swap({ createdAt: T0, updatedAt: T0 }));
  await setDoc(doc(db, 'swaps/s_done'), swap({ status: 'accepted', createdAt: T0, updatedAt: T0 }));
  await setDoc(doc(db, 'notifications/alice/items/nseed'), notif({ createdAt: T0 }));
  await setDoc(doc(db, 'reports/rseed'), {
    id: 'rseed', reporterId: 'bob', listingId: 'L', reason: 'spam',
    details: null, status: 'open', createdAt: T0,
  });
});

// ============================================================================
// USERS
// ============================================================================
await test('users', 'verified user creates own profile', () =>
  assertSucceeds(setDoc(doc(alice, 'users/alice'), profile('alice', 'alice@uni.edu'))));
await test('users', 'UNVERIFIED user creates own profile (the sign-up fix)', () =>
  assertSucceeds(setDoc(doc(newbie, 'users/newbie'), profile('newbie', 'newbie@uni.edu'))));
await test('users', 'cannot self-assign role=admin at create', () =>
  assertFails(setDoc(doc(bob, 'users/bob'), profile('bob', 'bob@uni.edu', { role: 'admin' }))));
await test('users', 'cannot create a profile at another uid', () =>
  assertFails(setDoc(doc(bob, 'users/alice'), profile('alice', 'alice@uni.edu'))));
await test('users', 'anonymous cannot create a profile', () =>
  assertFails(setDoc(doc(guest, 'users/ghost'), profile('ghost', 'g@uni.edu'))));
await test('users', 'signed-in user reads another profile', () =>
  assertSucceeds(getDoc(doc(bob, 'users/alice'))));
await test('users', 'anonymous cannot read profiles', () =>
  assertFails(getDoc(doc(guest, 'users/alice'))));
await test('users', 'owner updates own displayName', () =>
  assertSucceeds(updateDoc(doc(alice, 'users/alice'), { displayName: 'Alice B.' })));
await test('users', 'cannot escalate own role via update', () =>
  assertFails(updateDoc(doc(alice, 'users/alice'), { role: 'admin' })));
await test('users', 'cannot self-edit own rating', () =>
  assertFails(updateDoc(doc(alice, 'users/alice'), { rating: 5 })));
await test('users', 'cannot edit someone else\'s profile', () =>
  assertFails(updateDoc(doc(bob, 'users/alice'), { displayName: 'hacked' })));
await test('users', 'nobody can delete a profile', () =>
  assertFails(deleteDoc(doc(alice, 'users/alice'))));

// favorites subcollection
await test('users', 'owner writes to own favorites', () =>
  assertSucceeds(setDoc(doc(alice, 'users/alice/favorites/l_read'), { addedAt: serverTimestamp() })));
await test('users', 'cannot write to another user\'s favorites', () =>
  assertFails(setDoc(doc(bob, 'users/alice/favorites/l_read'), { addedAt: serverTimestamp() })));

// ============================================================================
// LISTINGS
// ============================================================================
await test('listings', 'verified owner creates a valid listing', () =>
  assertSucceeds(setDoc(doc(alice, 'listings/new1'), listing('alice'))));
await test('listings', 'unverified user cannot create a listing', () =>
  assertFails(setDoc(doc(newbie, 'listings/new2'), listing('newbie'))));
await test('listings', 'cannot create a listing for another seller', () =>
  assertFails(setDoc(doc(bob, 'listings/new3'), listing('alice'))));
await test('listings', 'title too short is rejected', () =>
  assertFails(setDoc(doc(alice, 'listings/new4'), listing('alice', { title: 'ab' }))));
await test('listings', 'description too short is rejected', () =>
  assertFails(setDoc(doc(alice, 'listings/new5'), listing('alice', { description: 'short' }))));
await test('listings', 'negative price is rejected', () =>
  assertFails(setDoc(doc(alice, 'listings/new6'), listing('alice', { price: -1 }))));
await test('listings', 'more than 6 images is rejected', () =>
  assertFails(setDoc(doc(alice, 'listings/new7'),
    listing('alice', { imageUrls: ['1', '2', '3', '4', '5', '6', '7'].map((n) => `https://x/${n}.jpg`) }))));
await test('listings', 'non-zero favoriteCount at create is rejected', () =>
  assertFails(setDoc(doc(alice, 'listings/new8'), listing('alice', { favoriteCount: 3 }))));
await test('listings', 'client-clock createdAt is rejected (must be serverTimestamp)', () =>
  assertFails(setDoc(doc(alice, 'listings/new9'), listing('alice', { createdAt: Timestamp.now(), updatedAt: Timestamp.now() }))));
await test('listings', 'signed-in user reads a listing', () =>
  assertSucceeds(getDoc(doc(bob, 'listings/l_read'))));
await test('listings', 'owner edits own listing title', () =>
  assertSucceeds(updateDoc(doc(alice, 'listings/l_edit'), { title: 'An updated valid title', updatedAt: serverTimestamp() })));
await test('listings', 'non-owner cannot edit a listing', () =>
  assertFails(updateDoc(doc(bob, 'listings/l_edit'), { title: 'An updated valid title', updatedAt: serverTimestamp() })));
// NOTE: the counter cases below write a LITERAL value (`viewCount: 1`), which
// is what FirestoreRepository now sends. Do NOT "simplify" these to
// FieldValue.increment: the emulator resolves numeric increments when
// evaluating rules, but production Firestore does not, so a rule guard like
// `new == old + 1` rejects them live. That divergence shipped a real bug
// (favouriting and view counts failed silently in production while these tests
// passed). Verify counter writes against the live project with
// scripts/probe_other_listing_counters.mjs before changing them.
await test('listings', 'any student may increment viewCount by 1', () =>
  assertSucceeds(updateDoc(doc(bob, 'listings/l_view'), { viewCount: 1 })));
await test('listings', 'cannot jump viewCount by more than 1', () =>
  assertFails(updateDoc(doc(carol, 'listings/l_view'), { viewCount: 99 })));
await test('listings', 'favoriting adjusts counter by exactly one', () =>
  assertSucceeds(updateDoc(doc(bob, 'listings/l_fav'), { favoriteCount: 1 })));
await test('listings', 'cannot jump favoriteCount by more than 1', () =>
  assertFails(updateDoc(doc(carol, 'listings/l_fav'), { favoriteCount: 5 })));
await test('listings', 'non-owner cannot delete a listing', () =>
  assertFails(deleteDoc(doc(bob, 'listings/l_del'))));
await test('listings', 'owner deletes own listing', () =>
  assertSucceeds(deleteDoc(doc(alice, 'listings/l_del'))));

// ============================================================================
// CONVERSATIONS + MESSAGES
// ============================================================================
await test('chat', 'buyer opens a conversation', () =>
  assertSucceeds(setDoc(doc(bob, 'conversations/c_new'), conversation())));
await test('chat', 'cannot open a conversation as someone else\'s buyer', () =>
  assertFails(setDoc(doc(bob, 'conversations/c_bad'), conversation({ buyerId: 'alice' }))));
await test('chat', 'conversation cannot start with a non-empty lastMessage', () =>
  assertFails(setDoc(doc(bob, 'conversations/c_bad2'), conversation({ lastMessage: 'hi' }))));
await test('chat', 'participant reads the conversation', () =>
  assertSucceeds(getDoc(doc(alice, 'conversations/c1'))));
await test('chat', 'outsider cannot read the conversation', () =>
  assertFails(getDoc(doc(carol, 'conversations/c1'))));
await test('chat', 'participant sends a text message', () =>
  assertSucceeds(setDoc(doc(bob, 'conversations/c1/messages/m1'),
    { id: 'm1', senderId: 'bob', text: 'Hello!', readBy: [], sentAt: serverTimestamp() })));
await test('chat', 'outsider cannot send a message', () =>
  assertFails(setDoc(doc(carol, 'conversations/c1/messages/m2'),
    { id: 'm2', senderId: 'carol', text: 'sneaky', readBy: [], sentAt: serverTimestamp() })));
await test('chat', 'empty message with no photo is rejected', () =>
  assertFails(setDoc(doc(bob, 'conversations/c1/messages/m3'),
    { id: 'm3', senderId: 'bob', text: '', readBy: [], sentAt: serverTimestamp() })));
await test('chat', 'photo-only message is allowed', () =>
  assertSucceeds(setDoc(doc(bob, 'conversations/c1/messages/m4'),
    { id: 'm4', senderId: 'bob', text: '', imageUrl: 'https://x/p.jpg', readBy: [], sentAt: serverTimestamp() })));
await test('chat', 'client-clock sentAt is rejected', () =>
  assertFails(setDoc(doc(bob, 'conversations/c1/messages/m5'),
    { id: 'm5', senderId: 'bob', text: 'hi', readBy: [], sentAt: Timestamp.now() })));
await test('chat', 'messages are immutable (no edit)', () =>
  assertFails(updateDoc(doc(bob, 'conversations/c1/messages/m1'), { text: 'edited' })));

// ============================================================================
// SWAPS
// ============================================================================
await test('swaps', 'offerer proposes a swap', () =>
  assertSucceeds(setDoc(doc(bob, 'swaps/s_new'), swap())));
await test('swaps', 'cannot propose a swap where you are the owner', () =>
  assertFails(setDoc(doc(bob, 'swaps/s_bad'), swap({ ownerId: 'bob' }))));
await test('swaps', 'cannot create a swap that is not pending', () =>
  assertFails(setDoc(doc(bob, 'swaps/s_bad2'), swap({ status: 'accepted' }))));
await test('swaps', 'listing owner accepts a pending swap', () =>
  assertSucceeds(updateDoc(doc(alice, 'swaps/s_accept'), { status: 'accepted', updatedAt: serverTimestamp() })));
await test('swaps', 'offerer cancels their own pending swap', () =>
  assertSucceeds(updateDoc(doc(bob, 'swaps/s_cancel'), { status: 'cancelled', updatedAt: serverTimestamp() })));
await test('swaps', 'offerer cannot accept (only owner can)', () =>
  assertFails(updateDoc(doc(bob, 'swaps/s_offacc'), { status: 'accepted', updatedAt: serverTimestamp() })));
await test('swaps', 'an already-decided swap cannot be changed', () =>
  assertFails(updateDoc(doc(alice, 'swaps/s_done'), { status: 'declined', updatedAt: serverTimestamp() })));
await test('swaps', 'participant reads the swap', () =>
  assertSucceeds(getDoc(doc(bob, 'swaps/s_done'))));
await test('swaps', 'outsider cannot read the swap', () =>
  assertFails(getDoc(doc(carol, 'swaps/s_done'))));

// ============================================================================
// NOTIFICATIONS
// ============================================================================
await test('notifications', 'a student drops a notification in another\'s feed', () =>
  assertSucceeds(setDoc(doc(bob, 'notifications/alice/items/n_new'), notif())));
await test('notifications', 'a notification cannot start already-read', () =>
  assertFails(setDoc(doc(bob, 'notifications/alice/items/n_bad'), notif({ read: true }))));
await test('notifications', 'owner reads own notifications', () =>
  assertSucceeds(getDoc(doc(alice, 'notifications/alice/items/nseed'))));
await test('notifications', 'cannot read someone else\'s notifications', () =>
  assertFails(getDoc(doc(bob, 'notifications/alice/items/nseed'))));
await test('notifications', 'owner marks a notification read', () =>
  assertSucceeds(updateDoc(doc(alice, 'notifications/alice/items/nseed'), { read: true })));
await test('notifications', 'owner cannot rewrite notification body', () =>
  assertFails(updateDoc(doc(alice, 'notifications/alice/items/nseed'), { title: 'tampered' })));
await test('notifications', 'owner deletes own notification', () =>
  assertSucceeds(deleteDoc(doc(alice, 'notifications/alice/items/nseed'))));

// ============================================================================
// REPORTS
// ============================================================================
await test('reports', 'a student files a report', () =>
  assertSucceeds(setDoc(doc(bob, 'reports/r_new'),
    { id: 'r_new', reporterId: 'bob', listingId: 'L', reason: 'prohibited item', details: null, status: 'open', createdAt: serverTimestamp() })));
await test('reports', 'cannot file a report under another reporterId', () =>
  assertFails(setDoc(doc(bob, 'reports/r_bad'),
    { id: 'r_bad', reporterId: 'alice', listingId: 'L', reason: 'x', details: null, status: 'open', createdAt: serverTimestamp() })));
await test('reports', 'reports are not client-readable', () =>
  assertFails(getDoc(doc(bob, 'reports/rseed'))));

// ---- report ----------------------------------------------------------------
await env.cleanup();

const width = Math.max(...rows.map((r) => r[1].length + r[2].length)) + 3;
console.log('\n==================== CampusSwap rules test results ====================\n');
let lastSection = '';
for (const [status, section, name, err] of rows) {
  if (section !== lastSection) {
    console.log(`\n  ${section.toUpperCase()}`);
    lastSection = section;
  }
  const label = `${name}`.padEnd(width);
  const mark = status === 'PASS' ? '  ✓' : '  ✗';
  console.log(`${mark} ${label}${err ? '  <-- ' + err : ''}`);
}
console.log(`\n======================================================================`);
console.log(`  ${pass} passed, ${fail} failed, ${pass + fail} total`);
console.log(`======================================================================\n`);

process.exit(fail === 0 ? 0 : 1);
