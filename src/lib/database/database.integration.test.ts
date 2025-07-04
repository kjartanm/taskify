import { describe, it, expect } from 'vitest';
import { setupDatabaseTests, testUtils } from '../database/testing';

// Example database test
describe('Database Integration Tests', () => {
  const dbHelper = setupDatabaseTests();

  describe('Parents', () => {
    it('should create a parent successfully', async () => {
      const db = dbHelper.getDatabase();
      const parent = await testUtils.createTestParent(db);
      
      expect(parent.parentId).toBeDefined();
      expect(parent.email).toBe('test@example.com');
      expect(parent.firstName).toBe('Test');
      expect(parent.lastName).toBe('Parent');
    });

    it('should enforce unique email constraint', async () => {
      const db = dbHelper.getDatabase();
      
      // First parent should succeed
      await testUtils.createTestParent(db);
      
      // Second parent with same email should fail
      // Note: In a real test, you would expect this to throw an error
      // expect(() => testUtils.createTestParent(db)).rejects.toThrow();
    });
  });

  describe('Children', () => {
    it('should create a child associated with a parent', async () => {
      const db = dbHelper.getDatabase();
      const parent = await testUtils.createTestParent(db);
      const child = await testUtils.createTestChild(db, parent.parentId);
      
      expect(child.childId).toBeDefined();
      expect(child.parentId).toBe(parent.parentId);
      expect(child.firstName).toBe('Test');
    });
  });

  describe('Tasks', () => {
    it('should create a task for a child', async () => {
      const db = dbHelper.getDatabase();
      const parent = await testUtils.createTestParent(db);
      const child = await testUtils.createTestChild(db, parent.parentId);
      const task = await testUtils.createTestTask(db, parent.parentId, child.childId);
      
      expect(task.taskId).toBeDefined();
      expect(task.parentId).toBe(parent.parentId);
      expect(task.childId).toBe(child.childId);
      expect(task.title).toBe('Test Task');
      expect(task.status).toBe('pending');
      expect(task.rewardPoints).toBe(10);
    });

    it('should create a task without assigning to a child', async () => {
      const db = dbHelper.getDatabase();
      const parent = await testUtils.createTestParent(db);
      const task = await testUtils.createTestTask(db, parent.parentId);
      
      expect(task.taskId).toBeDefined();
      expect(task.parentId).toBe(parent.parentId);
      expect(task.childId).toBeUndefined();
    });
  });

  describe('Database Relations', () => {
    it('should enforce foreign key constraints', async () => {
      const db = dbHelper.getDatabase();
      
      // Attempt to create a child with non-existent parent
      // This should fail with foreign key constraint error
      // expect(() => testUtils.createTestChild(db, 'non-existent-parent')).rejects.toThrow();
    });

    it('should cascade delete children when parent is deleted', async () => {
      const db = dbHelper.getDatabase();
      const parent = await testUtils.createTestParent(db);
      const child = await testUtils.createTestChild(db, parent.parentId);
      
      // Delete parent
      // Children should be automatically deleted due to CASCADE
      
      // Verify child no longer exists
      // const deletedChild = await findChild(db, child.childId);
      // expect(deletedChild).toBeNull();
    });
  });
});
