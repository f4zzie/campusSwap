export function requiredEnv(name) {
  const value = process.env[name]?.trim();
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

export const PROJECT =
  process.env.CAMPUSSWAP_FIREBASE_PROJECT_ID?.trim() || 'campusswap-2c21f';
export const API_KEY = requiredEnv('CAMPUSSWAP_FIREBASE_API_KEY');
export const DEMO_PASSWORD = requiredEnv('CAMPUSSWAP_DEMO_PASSWORD');
