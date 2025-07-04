import { drizzle } from 'drizzle-orm/d1';
import type { DrizzleD1Database } from 'drizzle-orm/d1';
import * as schema from './schema';

// Database client type
export type Database = DrizzleD1Database<typeof schema>;

// Create database client for different environments
export function createDatabaseClient(d1: D1Database): Database {
  return drizzle(d1, { schema });
}

// Helper function to get database client from platform
export function getDatabaseClient(platform: App.Platform): Database {
  if (!platform?.env?.DB) {
    throw new Error('Database binding not found. Make sure DB is configured in wrangler.toml');
  }
  return createDatabaseClient(platform.env.DB);
}

// Export schema for external use
export * from './schema';
export { schema };
