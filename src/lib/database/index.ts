// Database module exports
export * from './client';
export * from './schema';
export * from './testing';
export * from './migration-runner';

// Re-export commonly used types
export type {
  Parent,
  NewParent,
  Child,
  NewChild,
  Task,
  NewTask,
  Category,
  NewCategory,
  Reward,
  NewReward,
  Notification,
  NewNotification,
} from './schema';

// Re-export database client
export { createDatabaseClient, getDatabaseClient } from './client';

// Re-export testing utilities
export { setupDatabaseTests, testUtils, DatabaseTestHelper } from './testing';

// Re-export migration utilities
export { migrationRunner, migrationUtils } from './migration-runner';
