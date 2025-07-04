import { unstable_dev } from 'wrangler';
import type { Unstable_DevWorker } from 'wrangler';
import { afterAll, beforeAll } from 'vitest';
import type { Database } from '../database/client';

// Database testing utilities
export class DatabaseTestHelper {
  private worker: Unstable_DevWorker | null = null;
  //private db: Database | null = null;

  async setup() {
    // Start local Wrangler dev server for testing
    this.worker = await unstable_dev('src/index.js', {
      experimental: { disableExperimentalWarning: true },
      local: true,
      persist: false, // Don't persist test data
      env: 'development',
    });

    // Get database client
    const response = await this.worker.fetch('http://localhost/api/test/db-client', {
      method: 'GET',
    });
    
    if (!response.ok) {
      throw new Error('Failed to get database client from test worker');
    }

    // Note: In a real implementation, you would need to create a test endpoint
    // that returns a database client or use a different approach
    // This is a simplified example
  }

  async teardown() {
    if (this.worker) {
      await this.worker.stop();
      this.worker = null;
    }
    this.db = null;
  }

  async seedTestData() {
    // Implement test data seeding
    // This would typically insert test data into the database
    // using the sample data from context/data/taskify-sample-data.sql
  }

  async clearTestData() {
    // Implement test data cleanup
    // This would typically clear all test data from the database
  }

  getDatabase(): Database {
    if (!this.db) {
      throw new Error('Database not initialized. Call setup() first.');
    }
    return this.db;
  }

  async withTransaction<T>(callback: (db: Database) => Promise<T>): Promise<T> {
    const database = this.getDatabase();
    // Note: D1 doesn't support transactions yet, so this is a placeholder
    // In the future, you would start a transaction here
    return await callback(database);
  }
}

// Helper function to create database test helper
export function createDatabaseTestHelper(): DatabaseTestHelper {
  return new DatabaseTestHelper();
}

// Test utilities for common database operations
export const testUtils = {
  async createTestParent(/*db: Database*/) {
    // Helper to create a test parent
    const testParent = {
      parentId: 'test-parent-' + Date.now(),
      email: 'test@example.com',
      passwordHash: 'hashed-password',
      firstName: 'Test',
      lastName: 'Parent',
      privacyConsent: true,
      dataRetentionConsent: true,
    };

    // In a real implementation, you would use the database client
    // to insert the test parent
    return testParent;
  },

  async createTestChild(db: Database, parentId: string) {
    // Helper to create a test child
    const testChild = {
      childId: 'test-child-' + Date.now(),
      parentId,
      firstName: 'Test',
      birthDate: '2010-01-01',
    };

    // In a real implementation, you would use the database client
    // to insert the test child
    return testChild;
  },

  async createTestTask(db: Database, parentId: string, childId?: string) {
    // Helper to create a test task
    const testTask = {
      taskId: 'test-task-' + Date.now(),
      parentId,
      childId,
      title: 'Test Task',
      description: 'This is a test task',
      status: 'pending',
      rewardPoints: 10,
    };

    // In a real implementation, you would use the database client
    // to insert the test task
    return testTask;
  },
};

// Example test setup for database tests
export function setupDatabaseTests() {
  const dbHelper = createDatabaseTestHelper();

  beforeAll(async () => {
    await dbHelper.setup();
    await dbHelper.seedTestData();
  });

  afterAll(async () => {
    await dbHelper.clearTestData();
    await dbHelper.teardown();
  });

  return dbHelper;
}
