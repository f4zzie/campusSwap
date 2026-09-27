// Diagnostic: does the rules engine accept a favourite counter moved by
// FieldValue.increment (what the app sends) versus a literal value?
//
//   firebase emulators:exec --only firestore "node test_rules/favorite_probe.mjs"

import {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} from '@firebase/rules-unit-testing';
import {
  doc,
  setDoc,
  updateDoc,
  increment,
  serverTimestamp,
  Timestamp,
} from 'firebase/firestore';
import { readFileSync } from 'node:fs';

const env = await initializeTestEnvironment({
  projectId: 'campusswap-2c21f',
  firestore: {
    rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
    host: '127.0.0.1',
    port: 8080,
  },
});

const alice = env.authenticatedContext('alice', { email_verified: true }).firestore();
const bob = env.authenticatedContext('bob', { email_verified: true }).firestore();

const T0 = Timestamp.fromDate(new Date('2020-01-01T00:00:00Z'));
const listing = {
  id: 'L',
  sellerId: 'alice',
  sellerName: 'Alice',
  title: 'A valid listing title',
  description: 'A sufficiently long description of the item.',
  price: 100,
  category: 'textbooks',
  condition: 'good',
  type: 'sale',
  campus: 'Main',
  favoriteCount: 0,
  imageUrls: [],
  status: 'active',
  searchKeywords: [],
  viewCount: 0,
  createdAt: T0,
  updatedAt: T0,
};

async function attempt(label, fn) {
  try {
    await fn();
    console.log(`  ✓ ${label}`);
  } catch (e) {
    console.log(`  ✗ ${label}\n      ${e.message}`);
  }
}

await env.withSecurityRulesDisabled(async (ctx) => {
  await setDoc(doc(ctx.firestore(), 'listings/L'), listing);
  await setDoc(doc(ctx.firestore(), 'listings/L2'), listing);
});

console.log('\nFavourite counter — how does the rules engine see it?\n');

console.log('FieldValue.increment(1)  [what the app sends]:');
await attempt('bob increments favouriteCount', () =>
  updateDoc(doc(bob, 'listings/L'), { favoriteCount: increment(1) }));

console.log('\nLiteral current+1  [what my seeder sends]:');
await attempt('bob sets favouriteCount to 1', () =>
  updateDoc(doc(bob, 'listings/L2'), { favoriteCount: 1 }));

console.log('\nView counter (the same pattern the app uses):');
await attempt('bob increments viewCount', () =>
  updateDoc(doc(bob, 'listings/L2'), { viewCount: increment(1) }));

console.log('\nFavourite doc itself:');
await attempt('bob creates users/bob/favorites/L', () =>
  setDoc(doc(bob, 'users/bob/favorites/L'), { savedAt: serverTimestamp() }));

console.log('');

await env.cleanup();
process.exit(0);
