# Database Setup and Usage

This directory contains all database-related code for the Taskify MVP, implementing the decisions from the [Local Database ADR](../adr/local-database.md).

## Structure

- `client.ts` - Database client creation and connection utilities
- `schema.ts` - Drizzle ORM schema definitions
- `testing.ts` - Database testing utilities using unstable_dev() API
- `migration-runner.ts` - Migration utilities for SQL files
- `index.ts` - Main exports

## Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Set up Local Database

```bash
# Run initial migrations
npm run db:migrate

# Seed with sample data
npm run db:seed

# Or do both in one command
npm run db:setup
```

### 3. Start Development Server with Persistent Database

```bash
# Start with persistent local database
npm run dev:with-db

# Or use the regular wrangler dev command
npm run wrangler:dev
```

## Usage

### Database Client

```typescript
import { getDatabaseClient } from '$lib/database';

// In a SvelteKit endpoint
export async function GET({ platform }) {
  const db = getDatabaseClient(platform);
  
  // Use Drizzle ORM
  const parents = await db.select().from(schema.parents);
  
  return json(parents);
}
```

### Schema Types

```typescript
import type { Parent, NewParent, Task, NewTask } from '$lib/database';

// Use typed database operations
const newParent: NewParent = {
  parentId: 'parent-123',
  email: 'parent@example.com',
  passwordHash: 'hashed-password',
  firstName: 'John',
  lastName: 'Doe',
  privacyConsent: true,
  dataRetentionConsent: true,
};
```

### Testing

```typescript
import { setupDatabaseTests, testUtils } from '$lib/database/testing';

describe('Database Tests', () => {
  const dbHelper = setupDatabaseTests();

  it('should create a parent', async () => {
    const db = dbHelper.getDatabase();
    const parent = await testUtils.createTestParent(db);
    expect(parent.parentId).toBeDefined();
  });
});
```

## Scripts

- `npm run db:migrate` - Run migrations locally
- `npm run db:migrate:staging` - Run migrations on staging
- `npm run db:migrate:production` - Run migrations on production
- `npm run db:seed` - Seed local database with sample data
- `npm run db:seed:staging` - Seed staging database
- `npm run db:reset` - Reset local database
- `npm run db:setup` - Run migrations and seed data
- `npm run db:generate` - Generate new Drizzle migrations
- `npm run db:push` - Push schema changes to database
- `npm run db:studio` - Open Drizzle Studio for database management

## Migration Files

Migrations are stored in the `./migrations` directory:

- `0001_initial_schema.sql` - Initial database schema
- `0002_email_verification_tokens.sql` - Email verification tokens

## Environment Configuration

The database configuration is defined in `wrangler.toml`:

- **Development**: Uses local D1 database with persistence
- **Staging**: Uses staging D1 database
- **Production**: Uses production D1 database

## Database Persistence

Local development uses persistent storage in `./local-db/` directory to maintain data across development sessions. This directory is included in `.gitignore`.

## Testing Integration

Database tests use Wrangler's `unstable_dev()` API to create isolated test environments. Each test suite gets its own database instance that doesn't interfere with development data.

## Schema Management

The project uses both SQL migrations and Drizzle ORM:

1. **SQL Migrations**: For initial setup and complex schema changes
2. **Drizzle Schema**: For type-safe database operations and queries
3. **Migration Runner**: Utility to execute SQL migrations via Wrangler

## Troubleshooting

### Database Connection Issues

1. Ensure `wrangler.toml` is properly configured
2. Check that D1 database IDs are valid
3. Verify environment variables are set correctly

### Migration Issues

1. Check migration file syntax
2. Ensure migrations are run in the correct order
3. Verify database permissions for the environment

### Testing Issues

1. Ensure Wrangler is properly installed
2. Check that test database is properly isolated
3. Verify test data cleanup is working correctly

## Related Documentation

- [Local Database ADR](../adr/local-database.md)
- [Development Environment ADR](../adr/development-environment.md)
- [Testing Strategy ADR](../adr/testing-strategy.md)
- [Cloudflare D1 Documentation](https://developers.cloudflare.com/d1/)
- [Drizzle ORM Documentation](https://orm.drizzle.team/)
