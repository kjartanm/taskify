import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  schema: './src/lib/database/schema.ts',
  out: './migrations',
  dialect: 'sqlite',
  driver: 'd1-http',
  dbCredentials: {
    // For local development
    wranglerConfigPath: './wrangler.toml',
    environmentName: 'development',
  },
  verbose: true,
  strict: true,
  // Generate migrations based on schema changes
  breakpoints: true,
  // Custom migration folder
  migrations: {
    prefix: 'index',
    table: '__drizzle_migrations__',
    schema: 'public',
  },
});
