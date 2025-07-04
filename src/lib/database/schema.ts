import { sqliteTable, text, integer, blob, index, primaryKey } from 'drizzle-orm/sqlite-core';
import { sql } from 'drizzle-orm';

// Parents table
export const parents = sqliteTable('parents', {
  parentId: text('parent_id').primaryKey(),
  email: text('email').notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  firstName: text('first_name').notNull(),
  lastName: text('last_name').notNull(),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text('updated_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Email verification fields
  emailVerified: integer('email_verified', { mode: 'boolean' }).notNull().default(false),
  emailVerifiedAt: text('email_verified_at'),
  emailVerificationToken: text('email_verification_token'),
  emailVerificationExpires: text('email_verification_expires'),
  
  // Password reset fields
  passwordResetToken: text('password_reset_token'),
  passwordResetExpires: text('password_reset_expires'),
  
  // Account status and preferences
  accountStatus: text('account_status').notNull().default('active'),
  timezone: text('timezone').default('UTC'),
  language: text('language').default('en'),
  
  // Subscription and billing
  subscriptionType: text('subscription_type').notNull().default('free'),
  subscriptionExpires: text('subscription_expires'),
  
  // Privacy and consent
  privacyConsent: integer('privacy_consent', { mode: 'boolean' }).notNull().default(false),
  marketingConsent: integer('marketing_consent', { mode: 'boolean' }).notNull().default(false),
  dataRetentionConsent: integer('data_retention_consent', { mode: 'boolean' }).notNull().default(true),
  
  // Audit fields
  lastLoginAt: text('last_login_at'),
  loginCount: integer('login_count').notNull().default(0),
  failedLoginAttempts: integer('failed_login_attempts').notNull().default(0),
  accountLockedUntil: text('account_locked_until'),
});

// Children table
export const children = sqliteTable('children', {
  childId: text('child_id').primaryKey(),
  parentId: text('parent_id').notNull().references(() => parents.parentId, { onDelete: 'cascade' }),
  firstName: text('first_name').notNull(),
  birthDate: text('birth_date'),
  avatarUrl: text('avatar_url'),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text('updated_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Child preferences and settings
  rewardPoints: integer('reward_points').notNull().default(0),
  level: integer('level').notNull().default(1),
  preferredDifficulty: text('preferred_difficulty').default('medium'),
  
  // Privacy settings for children
  profileVisibility: text('profile_visibility').default('family'),
  
  // Status
  isActive: integer('is_active', { mode: 'boolean' }).notNull().default(true),
});

// Categories table
export const categories = sqliteTable('categories', {
  categoryId: text('category_id').primaryKey(),
  parentId: text('parent_id').notNull().references(() => parents.parentId, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  description: text('description'),
  color: text('color').default('#3B82F6'),
  icon: text('icon').default('task'),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text('updated_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Category settings
  isDefault: integer('is_default', { mode: 'boolean' }).notNull().default(false),
  sortOrder: integer('sort_order').notNull().default(0),
});

// Tasks table
export const tasks = sqliteTable('tasks', {
  taskId: text('task_id').primaryKey(),
  parentId: text('parent_id').notNull().references(() => parents.parentId, { onDelete: 'cascade' }),
  childId: text('child_id').references(() => children.childId, { onDelete: 'set null' }),
  categoryId: text('category_id').references(() => categories.categoryId, { onDelete: 'set null' }),
  title: text('title').notNull(),
  description: text('description'),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text('updated_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Task scheduling
  dueDate: text('due_date'),
  dueTime: text('due_time'),
  recurrencePattern: text('recurrence_pattern'),
  
  // Task properties
  priority: text('priority').default('medium'),
  difficulty: text('difficulty').default('medium'),
  estimatedDuration: integer('estimated_duration'),
  
  // Rewards and points
  rewardPoints: integer('reward_points').notNull().default(10),
  rewardDescription: text('reward_description'),
  
  // Task status and completion
  status: text('status').notNull().default('pending'),
  completionDate: text('completion_date'),
  completionNotes: text('completion_notes'),
  
  // Task assignment
  assignedAt: text('assigned_at'),
  
  // Task validation
  requiresVerification: integer('requires_verification', { mode: 'boolean' }).notNull().default(false),
  verificationPhotoUrl: text('verification_photo_url'),
  verificationNotes: text('verification_notes'),
  verifiedBy: text('verified_by').references(() => parents.parentId, { onDelete: 'set null' }),
  verifiedAt: text('verified_at'),
  
  // Recurring task tracking
  parentTaskId: text('parent_task_id').references(() => tasks.taskId, { onDelete: 'cascade' }),
  sequenceNumber: integer('sequence_number').default(1),
});

// Task comments table
export const taskComments = sqliteTable('task_comments', {
  commentId: text('comment_id').primaryKey(),
  taskId: text('task_id').notNull().references(() => tasks.taskId, { onDelete: 'cascade' }),
  authorId: text('author_id').notNull(),
  authorType: text('author_type').notNull(),
  content: text('content').notNull(),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text('updated_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Comment properties
  isPrivate: integer('is_private', { mode: 'boolean' }).notNull().default(false),
  attachmentUrl: text('attachment_url'),
});

// Rewards table
export const rewards = sqliteTable('rewards', {
  rewardId: text('reward_id').primaryKey(),
  parentId: text('parent_id').notNull().references(() => parents.parentId, { onDelete: 'cascade' }),
  childId: text('child_id').references(() => children.childId, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  description: text('description'),
  costPoints: integer('cost_points').notNull(),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text('updated_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Reward properties
  category: text('category').default('general'),
  icon: text('icon').default('gift'),
  color: text('color').default('#10B981'),
  
  // Reward availability
  isActive: integer('is_active', { mode: 'boolean' }).notNull().default(true),
  maxRedemptions: integer('max_redemptions'),
  redemptionCount: integer('redemption_count').notNull().default(0),
  
  // Reward scheduling
  availableFrom: text('available_from'),
  availableUntil: text('available_until'),
});

// Reward redemptions table
export const rewardRedemptions = sqliteTable('reward_redemptions', {
  redemptionId: text('redemption_id').primaryKey(),
  rewardId: text('reward_id').notNull().references(() => rewards.rewardId, { onDelete: 'cascade' }),
  childId: text('child_id').notNull().references(() => children.childId, { onDelete: 'cascade' }),
  pointsSpent: integer('points_spent').notNull(),
  redeemedAt: text('redeemed_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Redemption status
  status: text('status').notNull().default('pending'),
  approvedBy: text('approved_by').references(() => parents.parentId, { onDelete: 'set null' }),
  approvedAt: text('approved_at'),
  fulfilledAt: text('fulfilled_at'),
  notes: text('notes'),
});

// Notifications table
export const notifications = sqliteTable('notifications', {
  notificationId: text('notification_id').primaryKey(),
  recipientId: text('recipient_id').notNull(),
  recipientType: text('recipient_type').notNull(),
  title: text('title').notNull(),
  message: text('message').notNull(),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  
  // Notification properties
  type: text('type').notNull(),
  priority: text('priority').default('normal'),
  
  // Notification status
  isRead: integer('is_read', { mode: 'boolean' }).notNull().default(false),
  readAt: text('read_at'),
  
  // Related entities
  relatedTaskId: text('related_task_id').references(() => tasks.taskId, { onDelete: 'set null' }),
  relatedRewardId: text('related_reward_id').references(() => rewards.rewardId, { onDelete: 'set null' }),
  relatedChildId: text('related_child_id').references(() => children.childId, { onDelete: 'set null' }),
  
  // Notification delivery
  deliveryMethod: text('delivery_method').default('in_app'),
  deliveredAt: text('delivered_at'),
});

// Email verification tokens table
export const emailVerificationTokens = sqliteTable('email_verification_tokens', {
  tokenId: text('token_id').primaryKey(),
  parentId: text('parent_id').notNull().references(() => parents.parentId, { onDelete: 'cascade' }),
  email: text('email').notNull(),
  tokenHash: text('token_hash').notNull().unique(),
  expiresAt: text('expires_at').notNull(),
  usedAt: text('used_at'),
  createdAt: text('created_at').notNull().default(sql`CURRENT_TIMESTAMP`),
  invalidatedAt: text('invalidated_at'),
});

// Export all tables for relations
export const tables = {
  parents,
  children,
  categories,
  tasks,
  taskComments,
  rewards,
  rewardRedemptions,
  notifications,
  emailVerificationTokens,
};

// Define relations
export const parentsRelations = {
  children: children,
  categories: categories,
  tasks: tasks,
  rewards: rewards,
  emailVerificationTokens: emailVerificationTokens,
};

export const childrenRelations = {
  parent: parents,
  tasks: tasks,
  rewards: rewards,
  rewardRedemptions: rewardRedemptions,
};

export const tasksRelations = {
  parent: parents,
  child: children,
  category: categories,
  comments: taskComments,
  verifier: parents,
  parentTask: tasks,
  childTasks: tasks,
};

export const rewardsRelations = {
  parent: parents,
  child: children,
  redemptions: rewardRedemptions,
};

// Type exports
export type Parent = typeof parents.$inferSelect;
export type NewParent = typeof parents.$inferInsert;
export type Child = typeof children.$inferSelect;
export type NewChild = typeof children.$inferInsert;
export type Task = typeof tasks.$inferSelect;
export type NewTask = typeof tasks.$inferInsert;
export type Category = typeof categories.$inferSelect;
export type NewCategory = typeof categories.$inferInsert;
export type Reward = typeof rewards.$inferSelect;
export type NewReward = typeof rewards.$inferInsert;
export type Notification = typeof notifications.$inferSelect;
export type NewNotification = typeof notifications.$inferInsert;
