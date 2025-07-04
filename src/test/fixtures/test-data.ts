// Test data fixtures for consistent test scenarios
export const testFixtures = {
  parents: {
    validParent: {
      parentId: 'test-parent-001',
      email: 'parent@example.com',
      passwordHash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj.aAGkFWHm.',
      firstName: 'Jane',
      lastName: 'Doe',
      privacyConsent: true,
      dataRetentionConsent: true,
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
    },
    secondParent: {
      parentId: 'test-parent-002',
      email: 'parent2@example.com',
      passwordHash: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj.aAGkFWHm.',
      firstName: 'John',
      lastName: 'Smith',
      privacyConsent: true,
      dataRetentionConsent: true,
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
    },
  },

  children: {
    validChild: {
      childId: 'test-child-001',
      parentId: 'test-parent-001',
      firstName: 'Alice',
      birthDate: '2010-06-15',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
    },
    secondChild: {
      childId: 'test-child-002',
      parentId: 'test-parent-001',
      firstName: 'Bob',
      birthDate: '2012-03-22',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
    },
  },

  tasks: {
    pendingTask: {
      taskId: 'test-task-001',
      parentId: 'test-parent-001',
      childId: 'test-child-001',
      title: 'Clean your room',
      description: 'Tidy up the bedroom and put toys away',
      status: 'pending',
      rewardPoints: 10,
      dueDate: '2024-12-31T23:59:59.000Z',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
    },
    completedTask: {
      taskId: 'test-task-002',
      parentId: 'test-parent-001',
      childId: 'test-child-001',
      title: 'Do homework',
      description: 'Complete math homework',
      status: 'completed',
      rewardPoints: 15,
      dueDate: '2024-01-15T23:59:59.000Z',
      completedAt: '2024-01-15T18:30:00.000Z',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-15T18:30:00.000Z',
    },
    unassignedTask: {
      taskId: 'test-task-003',
      parentId: 'test-parent-001',
      childId: null,
      title: 'Grocery shopping',
      description: 'Buy groceries for the week',
      status: 'pending',
      rewardPoints: 5,
      dueDate: '2024-12-31T23:59:59.000Z',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
    },
  },

  emailVerificationTokens: {
    validToken: {
      tokenId: 'test-token-001',
      parentId: 'test-parent-001',
      email: 'parent@example.com',
      token: 'abc123def456',
      expiresAt: '2024-12-31T23:59:59.000Z',
      createdAt: '2024-01-01T00:00:00.000Z',
    },
    expiredToken: {
      tokenId: 'test-token-002',
      parentId: 'test-parent-002',
      email: 'parent2@example.com',
      token: 'expired123',
      expiresAt: '2024-01-01T00:00:00.000Z',
      createdAt: '2024-01-01T00:00:00.000Z',
    },
  },

  // Test data builders for dynamic test data
  builders: {
    parent: (overrides: Partial<typeof testFixtures.parents.validParent> = {}) => ({
      ...testFixtures.parents.validParent,
      parentId: `test-parent-${Date.now()}`,
      email: `parent-${Date.now()}@example.com`,
      ...overrides,
    }),

    child: (parentId: string, overrides: Partial<typeof testFixtures.children.validChild> = {}) => ({
      ...testFixtures.children.validChild,
      childId: `test-child-${Date.now()}`,
      parentId,
      ...overrides,
    }),

    task: (parentId: string, childId?: string, overrides: Partial<typeof testFixtures.tasks.pendingTask> = {}) => ({
      ...testFixtures.tasks.pendingTask,
      taskId: `test-task-${Date.now()}`,
      parentId,
      childId: childId || null,
      ...overrides,
    }),

    emailVerificationToken: (parentId: string, email: string, overrides: Partial<typeof testFixtures.emailVerificationTokens.validToken> = {}) => ({
      ...testFixtures.emailVerificationTokens.validToken,
      tokenId: `test-token-${Date.now()}`,
      parentId,
      email,
      token: `token-${Date.now()}`,
      ...overrides,
    }),
  },
};

// Helper function to get test data by environment
export function getTestDataForEnvironment(environment: 'development' | 'staging' | 'production') {
  switch (environment) {
    case 'development':
      return testFixtures;
    case 'staging':
      return {
        ...testFixtures,
        // Override with staging-specific data if needed
        parents: {
          ...testFixtures.parents,
          validParent: {
            ...testFixtures.parents.validParent,
            email: 'staging-parent@example.com',
          },
        },
      };
    case 'production':
      return {
        ...testFixtures,
        // Override with production-safe test data
        parents: {
          ...testFixtures.parents,
          validParent: {
            ...testFixtures.parents.validParent,
            email: 'prod-test-parent@example.com',
          },
        },
      };
    default:
      return testFixtures;
  }
}
