// Seeds the CampusSwap demo dataset into the live Firebase project.
//
//   node scripts/seed_demo_data.mjs
//
// Run scripts/generate_auth_import.mjs + the `firebase auth:import` command it
// prints FIRST: this script signs in as each demo user and writes every
// document through the real security rules, exactly as the app would. Nothing
// here is privileged — if a write violates firestore.rules, it fails loudly.
//
// The script is re-runnable. Creates use an "must not already exist"
// precondition, so documents seeded by an earlier run are skipped rather than
// duplicated, and dependent writes (counters, statuses, notifications) are
// gated on the create actually happening this run.
//
// Zero dependencies: uses the Firebase REST APIs directly.
//
// NOTE: the rules require createdAt/updatedAt/sentAt to equal request.time, so
// every seeded document is timestamped when it is written. Timestamps cannot be
// backdated from a client by design.

import {
  DEMO_PASSWORD,
  DEMO_USERS,
  EXTRA_FAVORITES,
  EXTRA_NOTIFICATIONS,
  LISTING_STATUS,
  LISTINGS,
  REPORTS,
  SWAPS,
  THREADS,
} from './demo_data.mjs';

const PROJECT = 'campusswap-2c21f';
// The web API key is a public identifier, not a secret (it ships in the app).
const API_KEY = 'AIzaSyCSmkksxzKFqSmJGmsqxgiXeAsindvy2O0';
const IDENTITY = 'https://identitytoolkit.googleapis.com/v1';
const DOCS = `https://firestore.googleapis.com/v1/projects/${PROJECT}/databases/(default)/documents`;
/** Marker for a value the server must stamp with request.time. */
const SERVER = Symbol('serverTimestamp');

const img = (seed, n) =>
  Array.from({ length: n }, (_, i) => `https://picsum.photos/seed/${seed}-${i + 1}/800/600`);

/** Mirrors CreateListingScreen._keywords() so search behaves identically. */
const keywords = (spec, campus) =>
  `${spec.title} ${spec.desc} ${spec.author ?? ''} ${spec.courseCode ?? ''} ${spec.isbn ?? ''} ${campus}`
    .toLowerCase()
    .split(/[^a-z0-9]+/)
    .filter((word) => word.length > 1)
    .filter((word, i, all) => all.indexOf(word) === i);

// --- Firestore value encoding ----------------------------------------------
function toValue(v) {
  if (v === null || v === undefined) return { nullValue: null };
  if (typeof v === 'string') return { stringValue: v };
  if (typeof v === 'boolean') return { booleanValue: v };
  if (typeof v === 'number') {
    return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
  }
  if (v instanceof Date) return { timestampValue: v.toISOString() };
  if (Array.isArray(v)) return { arrayValue: { values: v.map(toValue) } };
  if (typeof v === 'object') {
    const fields = {};
    for (const [k, val] of Object.entries(v)) fields[k] = toValue(val);
    return { mapValue: { fields } };
  }
  throw new Error(`Cannot encode value of type ${typeof v}`);
}

const docName = (path) =>
  `projects/${PROJECT}/databases/(default)/documents/${path}`;

/**
 * Splits `SERVER` markers out into transforms and encodes the rest, giving the
 * same write the Firestore SDK produces for { ...fields, x: serverTimestamp() }.
 */
function buildWrite(path, data, { create = false, merge = false } = {}) {
  const fields = {};
  const transforms = [];
  for (const [k, v] of Object.entries(data)) {
    if (v === SERVER) {
      transforms.push({ fieldPath: k, setToServerValue: 'REQUEST_TIME' });
    } else {
      fields[k] = toValue(v);
    }
  }
  const write = { update: { name: docName(path), fields } };
  if (transforms.length) write.updateTransforms = transforms;
  if (create) {
    write.currentDocument = { exists: false };
  } else if (merge) {
    write.updateMask = { fieldPaths: [...Object.keys(data)] };
  } else {
    write.updateMask = { fieldPaths: [...Object.keys(data)] };
  }
  return write;
}

/** A transform-only write, mirroring FieldValue.increment on an update. */
function incrementWrite(path, fieldPath, by) {
  return {
    update: { name: docName(path), fields: {} },
    updateMask: { fieldPaths: [fieldPath] },
    updateTransforms: [
      { fieldPath, increment: { integerValue: String(by) } },
    ],
  };
}

/** A transform-only write, mirroring FieldValue.arrayUnion. */
function arrayUnionWrite(path, fieldPath, values) {
  return {
    update: { name: docName(path), fields: {} },
    updateMask: { fieldPaths: [fieldPath] },
    updateTransforms: [
      { fieldPath, appendMissingElements: { values: values.map(toValue) } },
    ],
  };
}

async function commit(token, writes) {
  const res = await fetch(`${DOCS}:commit`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({ writes }),
  });
  if (!res.ok) {
    const body = await res.text();
    let message = body;
    try {
      message = JSON.parse(body).error?.message ?? body;
    } catch {
      /* keep raw body */
    }
    const err = new Error(message);
    err.alreadyExists =
      /already exists|ALREADY_EXISTS|FAILED_PRECONDITION/i.test(message);
    throw err;
  }
}

/** Reads a numeric field from a document, as the given user. */
async function readCounter(token, path, field) {
  const res = await fetch(`${DOCS}/${path}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) throw new Error(`could not read ${path}: HTTP ${res.status}`);
  const body = await res.json();
  const value = body.fields?.[field];
  return value ? Number(value.integerValue ?? value.doubleValue ?? 0) : 0;
}

async function signIn(email, password) {
  const res = await fetch(`${IDENTITY}/accounts:signInWithPassword?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const data = await res.json();
  if (!res.ok) {
    throw new Error(
      `Could not sign in as ${email}: ${data.error?.message ?? res.status}`,
    );
  }
  return data.idToken;
}

// --- bookkeeping -----------------------------------------------------------
const stats = {};
const failures = [];
let currentSection = '';

const bump = (section, kind) => {
  stats[section] ??= { created: 0, skipped: 0 };
  stats[section][kind]++;
};

async function createDoc(token, path, data, section) {
  try {
    await commit(token, [buildWrite(path, data, { create: true })]);
    bump(section, 'created');
    return true;
  } catch (e) {
    if (e.alreadyExists) {
      bump(section, 'skipped');
      return false;
    }
    failures.push(`${section}: ${path}\n    ${e.message}`);
    return false;
  }
}

async function updateDoc(token, path, patch, section) {
  try {
    await commit(token, [buildWrite(path, patch, { merge: true })]);
    bump(section, 'created');
  } catch (e) {
    failures.push(`${section}: ${path} (update)\n    ${e.message}`);
  }
}

console.log('\nSigning in as the demo users...');
const tokens = {};
try {
  for (const user of DEMO_USERS) {
    tokens[user.uid] = await signIn(user.email, DEMO_PASSWORD);
  }
  console.log(`  ${DEMO_USERS.length} users signed in (all verified)\n`);
} catch (e) {
  console.error(`\n${e.message}`);
  console.error(
    '\nRun scripts/generate_auth_import.mjs and the firebase auth:import command first.',
  );
  process.exit(1);
}

const byUid = Object.fromEntries(DEMO_USERS.map((u) => [u.uid, u]));
const listingId = (key) => `demo-${key}`;

// --- 1. profiles -----------------------------------------------------------
currentSection = 'profiles';
for (const user of DEMO_USERS) {
  await createDoc(
    tokens[user.uid],
    `users/${user.uid}`,
    {
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      university: user.university,
      photoUrl: user.photoUrl,
      bio: user.bio,
      createdAt: SERVER,
      fcmTokens: [],
      rating: user.rating,
      ratingCount: user.ratingCount,
      role: 'user',
    },
    currentSection,
  );
}

// --- 2. listings -----------------------------------------------------------
currentSection = 'listings';
for (const spec of LISTINGS) {
  const seller = byUid[spec.seller];
  const id = listingId(spec.key);
  const created = await createDoc(
    tokens[seller.uid],
    `listings/${id}`,
    {
      id,
      sellerId: seller.uid,
      sellerName: seller.displayName,
      sellerPhoto: seller.photoUrl,
      title: spec.title,
      description: spec.desc,
      price: spec.price,
      category: spec.category,
      condition: spec.condition,
      type: spec.type,
      campus: seller.campus,
      author: spec.author ?? null,
      courseCode: spec.courseCode ?? null,
      isbn: spec.isbn ?? null,
      favoriteCount: 0,
      imageUrls: img(`campusswap-${spec.key}`, spec.img),
      status: 'active',
      createdAt: SERVER,
      updatedAt: SERVER,
      searchKeywords: keywords(spec, seller.campus),
      viewCount: 0,
    },
    currentSection,
  );
  if (!created) continue;

  // Views and a few non-active statuses are applied as an owner update, which
  // is how the app would reach these values.
  const patch = { viewCount: spec.views ?? 0, updatedAt: SERVER };
  const status = LISTING_STATUS[spec.key];
  if (status) patch.status = status;
  await updateDoc(tokens[seller.uid], `listings/${id}`, patch, 'listing detail');
}

// --- 3. favorites (favorite doc + listing counter, atomically) -------------
currentSection = 'favorites';
// Deduplicated: a student can only favourite a listing once, so a pair that
// appears both on the listing and in EXTRA_FAVORITES is still one favourite.
const favoritePairs = [
  ...LISTINGS.flatMap((s) => (s.favorites ?? []).map((uid) => [uid, s.key])),
  ...EXTRA_FAVORITES,
].filter(
  ([uid, key], i, all) =>
    all.findIndex(([u, k]) => u === uid && k === key) === i,
);
for (const [uid, key] of favoritePairs) {
  const id = listingId(key);
  try {
    // The rules require the new counter to be exactly the old one + 1, and a
    // numeric increment is not visible to them on production Firestore (see
    // scripts/probe_other_listing_counters.mjs), so read the value first and
    // send it back as a literal.
    const current = await readCounter(tokens[uid], `listings/${id}`, 'favoriteCount');
    // One commit = the app's transaction: either both land or neither does.
    await commit(tokens[uid], [
      buildWrite(`users/${uid}/favorites/${id}`, { savedAt: SERVER }, { create: true }),
      buildWrite(`listings/${id}`, { favoriteCount: current + 1 }),
    ]);
    bump(currentSection, 'created');
  } catch (e) {
    if (e.alreadyExists) bump(currentSection, 'skipped');
    else failures.push(`${currentSection}: ${uid} -> ${id}\n    ${e.message}`);
  }
}

// --- 3b. reconcile favourite counters -------------------------------------
// The counter must equal the number of favourite documents. The rules only
// allow it to move one step at a time, so any drift (a half-finished run, the
// counter probes) is healed with repeated single steps rather than one write.
currentSection = 'favorite counters';
const trueCounts = {};
for (const [, key] of favoritePairs) trueCounts[key] = (trueCounts[key] ?? 0) + 1;
for (const spec of LISTINGS) {
  const id = listingId(spec.key);
  const target = trueCounts[spec.key] ?? 0;
  let current = await readCounter(tokens[spec.seller], `listings/${id}`, 'favoriteCount');
  while (current !== target) {
    const step = current < target ? 1 : -1;
    try {
      await commit(tokens[spec.seller], [
        buildWrite(`listings/${id}`, { favoriteCount: current + step }),
      ]);
      current += step;
      bump(currentSection, 'created');
    } catch (e) {
      failures.push(`${currentSection}: ${id}\n    ${e.message}`);
      break;
    }
  }
}

// --- 4. conversations and messages ----------------------------------------
currentSection = 'conversations';
for (const thread of THREADS) {
  const spec = LISTINGS.find((l) => l.key === thread.listing);
  const buyer = byUid[thread.buyer];
  const seller = byUid[spec.seller];
  const convId = `demo-conv-${thread.key}`;
  const created = await createDoc(
    tokens[buyer.uid],
    `conversations/${convId}`,
    {
      id: convId,
      listingId: listingId(spec.key),
      listingTitle: spec.title,
      buyerId: buyer.uid,
      buyerName: buyer.displayName,
      sellerId: seller.uid,
      sellerName: seller.displayName,
      participantIds: [buyer.uid, seller.uid],
      lastMessage: '',
      lastMessageAt: new Date(),
      unreadBy: [],
      unreadCounts: {},
      createdAt: new Date(),
    },
    currentSection,
  );
  if (!created) continue;

  // Messages load in sentAt order, so they are written in order.
  for (const [i, msg] of thread.messages.entries()) {
    const fromBuyer = msg.from === 'buyer';
    const sender = fromBuyer ? buyer : seller;
    const recipient = fromBuyer ? seller : buyer;
    const msgId = `demo-msg-${thread.key}-${String(i + 1).padStart(2, '0')}`;
    const text = msg.image ? '' : msg.text;
    const preview = msg.image ? '\u{1F4F7} Photo' : text;

    try {
      await commit(tokens[sender.uid], [
        buildWrite(
          `conversations/${convId}/messages/${msgId}`,
          {
            id: msgId,
            senderId: sender.uid,
            text,
            imageUrl: msg.image ? img(`campusswap-chat-${msgId}`, 1)[0] : null,
            sentAt: SERVER,
            readBy: [sender.uid],
          },
          { create: true },
        ),
        buildWrite(
          `conversations/${convId}`,
          { lastMessage: preview, lastMessageAt: SERVER },
          { merge: true },
        ),
        arrayUnionWrite(`conversations/${convId}`, 'unreadBy', [recipient.uid]),
        incrementWrite(`conversations/${convId}`, `unreadCounts.${recipient.uid}`, 1),
      ]);
      bump('messages', 'created');
    } catch (e) {
      if (e.alreadyExists) bump('messages', 'skipped');
      else failures.push(`messages: ${msgId}\n    ${e.message}`);
    }
  }

  // The tail of each thread is what the recipient has not read yet.
  const tail = thread.messages.at(-1);
  const tailFromBuyer = tail.from === 'buyer';
  const unreadUser = tailFromBuyer ? seller : buyer;
  let unreadCount = 0;
  for (let i = thread.messages.length - 1; i >= 0; i--) {
    if ((thread.messages[i].from === 'buyer') !== tailFromBuyer) break;
    unreadCount++;
  }

  const lastMsg = thread.messages.at(-1);
  const lastFromBuyer = lastMsg.from === 'buyer';
  const lastSender = lastFromBuyer ? buyer : seller;
  await createDoc(
    tokens[lastSender.uid],
    `notifications/${unreadUser.uid}/items/demo-notif-${thread.key}`,
    {
      id: `demo-notif-${thread.key}`,
      title: lastSender.displayName,
      body: lastMsg.image ? '\u{1F4F7} Photo' : lastMsg.text,
      type: 'message',
      relatedId: convId,
      read: false,
      createdAt: SERVER,
    },
    'notifications',
  );

  // Reflect the derived unread state on the conversation itself.
  await updateDoc(
    tokens[unreadUser.uid],
    `conversations/${convId}`,
    { unreadBy: [unreadUser.uid], unreadCounts: { [unreadUser.uid]: unreadCount } },
    'conversation unread',
  );
}

// --- 5. swap proposals -----------------------------------------------------
currentSection = 'swaps';
for (const spec of SWAPS) {
  const listing = LISTINGS.find((l) => l.key === spec.listing);
  const offered = LISTINGS.find((l) => l.key === spec.offered);
  const offerer = byUid[spec.offerer];
  const owner = byUid[listing.seller];
  const swapId = `demo-${spec.key}`;
  const created = await createDoc(
    tokens[offerer.uid],
    `swaps/${swapId}`,
    {
      id: swapId,
      listingId: listingId(listing.key),
      listingTitle: listing.title,
      offererId: offerer.uid,
      ownerId: owner.uid,
      offeredListingId: offered ? listingId(offered.key) : null,
      offeredListingTitle: offered ? offered.title : null,
      message: spec.message,
      status: 'pending',
      createdAt: SERVER,
      updatedAt: SERVER,
      participantIds: [offerer.uid, owner.uid],
    },
    currentSection,
  );
  if (!created) continue;

  await createDoc(
    tokens[offerer.uid],
    `notifications/${owner.uid}/items/demo-notif-${spec.key}`,
    {
      id: `demo-notif-${spec.key}`,
      title: 'New swap proposal',
      body: `Someone wants to swap for "${listing.title}".`,
      type: 'swapRequest',
      relatedId: swapId,
      read: false,
      createdAt: SERVER,
    },
    'notifications',
  );

  if (spec.outcome === 'accepted' || spec.outcome === 'declined') {
    await updateDoc(
      tokens[owner.uid],
      `swaps/${swapId}`,
      { status: spec.outcome, updatedAt: SERVER },
      'swap responses',
    );
    if (spec.outcome === 'accepted') {
      // Mirrors respondToSwap: the listing flips to `swapped` on acceptance.
      await updateDoc(
        tokens[owner.uid],
        `listings/${listingId(listing.key)}`,
        { status: 'swapped', updatedAt: SERVER },
        'swap responses',
      );
    }
    await createDoc(
      tokens[owner.uid],
      `notifications/${offerer.uid}/items/demo-notif-${spec.key}-answer`,
      {
        id: `demo-notif-${spec.key}-answer`,
        title: spec.outcome === 'accepted' ? 'Swap accepted' : 'Swap declined',
        body: `"${listing.title}"`,
        type: spec.outcome === 'accepted' ? 'swapAccepted' : 'swapDeclined',
        relatedId: swapId,
        read: false,
        createdAt: SERVER,
      },
      'notifications',
    );
  } else if (spec.outcome === 'cancelled') {
    await updateDoc(
      tokens[offerer.uid],
      `swaps/${swapId}`,
      { status: 'cancelled', updatedAt: SERVER },
      'swap responses',
    );
  }
}

// --- 6. reports ------------------------------------------------------------
currentSection = 'reports';
for (const spec of REPORTS) {
  const listing = LISTINGS.find((l) => l.key === spec.listing);
  await createDoc(
    tokens[spec.reporter],
    `reports/demo-${spec.key}`,
    {
      id: `demo-${spec.key}`,
      reporterId: spec.reporter,
      listingId: listingId(listing ? listing.key : spec.listing),
      reason: spec.reason,
      details: spec.details ?? null,
      status: 'open',
      createdAt: SERVER,
    },
    currentSection,
  );
}

// --- 7. standalone notifications ------------------------------------------
currentSection = 'notifications';
for (const spec of EXTRA_NOTIFICATIONS) {
  const created = await createDoc(
    tokens.seedAmina,
    `notifications/${spec.user}/items/${spec.key}`,
    {
      id: spec.key,
      title: spec.title,
      body: spec.body,
      type: spec.type,
      relatedId: null,
      read: false,
      createdAt: SERVER,
    },
    currentSection,
  );
  if (created && spec.read) {
    await updateDoc(
      tokens[spec.user],
      `notifications/${spec.user}/items/${spec.key}`,
      { read: true },
      'notifications read',
    );
  }
}

// --- summary ---------------------------------------------------------------
console.log('Seeded:');
for (const [section, counts] of Object.entries(stats)) {
  const skipped = counts.skipped ? `, ${counts.skipped} already present` : '';
  console.log(`  ${section.padEnd(20)} ${counts.created} written${skipped}`);
}

if (failures.length) {
  console.log(`\n${failures.length} write(s) failed:\n`);
  for (const f of failures) console.log(`  ${f}\n`);
  process.exit(1);
}

console.log('\nDone. Sign in on the app with any demo account, e.g.');
console.log(`  ${DEMO_USERS[0].email}  /  ${DEMO_PASSWORD}\n`);
