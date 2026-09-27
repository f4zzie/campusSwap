// Generates the `firebase auth:import` payload for the CampusSwap demo users.
//
//   node scripts/generate_auth_import.mjs            # all demo users
//   node scripts/generate_auth_import.mjs seedAmina  # just one (to validate)
//
// Then run the command the script prints. Users are imported with
// `emailVerified: true` so they can write through the security rules straight
// away, and with a STANDARD_SCRYPT hash so the demo password actually works.
//
// Zero dependencies: node:crypto does the scrypt work.

import { randomBytes, scryptSync } from 'node:crypto';
import { writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

import { DEMO_PASSWORD, DEMO_USERS } from './demo_data.mjs';

// Firebase's STANDARD_SCRYPT parameters: mem-cost is the CPU/memory cost N
// itself (a power of two, per the Identity Toolkit StandardScrypt field), block
// size 8, parallelisation 1, 32-byte derived key. These must match the CLI
// flags printed below or sign-in will fail with INVALID_LOGIN_CREDENTIALS.
const MEM_COST = 16384; // N — must be a power of two
const BLOCK_SIZE = 8;
const PARALLELIZATION = 1;
const DK_LEN = 32;

const here = dirname(fileURLToPath(import.meta.url));
const only = process.argv[2];
const users = only ? DEMO_USERS.filter((u) => u.uid === only) : DEMO_USERS;

if (users.length === 0) {
  console.error(`No demo user matches "${only}".`);
  process.exit(1);
}

const payload = {
  users: users.map((user) => {
    const salt = randomBytes(16);
    const hash = scryptSync(DEMO_PASSWORD, salt, DK_LEN, {
      N: MEM_COST,
      r: BLOCK_SIZE,
      p: PARALLELIZATION,
    });
    return {
      localId: user.uid,
      email: user.email,
      emailVerified: true,
      passwordHash: hash.toString('base64'),
      salt: salt.toString('base64'),
      displayName: user.displayName,
      ...(user.photoUrl ? { photoUrl: user.photoUrl } : {}),
    };
  }),
};

const outFile = join(here, only ? 'auth_import_one.json' : 'auth_import.json');
writeFileSync(outFile, `${JSON.stringify(payload, null, 2)}\n`);

console.log(`Wrote ${payload.users.length} user(s) to ${outFile}\n`);
console.log('Now run:\n');
console.log(
  `  firebase auth:import ${only ? 'scripts/auth_import_one.json' : 'scripts/auth_import.json'} \\\n` +
    `    --hash-algo=STANDARD_SCRYPT --mem-cost=${MEM_COST} --block-size=${BLOCK_SIZE} \\\n` +
    `    --parallelization=${PARALLELIZATION} --dk-len=${DK_LEN} --project campusswap-2c21f\n`,
);
console.log(`Demo password for every account: ${DEMO_PASSWORD}\n`);
