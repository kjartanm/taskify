-- Migration 0001: Initial schema for Taskify MVP
-- Created: 2025-07-04
-- This migration creates the core database schema for the Taskify application

-- Enable foreign key constraints (important for SQLite)
PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- Parents Table
-- Stores parent/guardian account information
-- ----------------------------------------------------------------------------
CREATE TABLE parents (
    parent_id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Email verification fields
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    email_verified_at DATETIME,
    email_verification_token TEXT,
    email_verification_expires DATETIME,
    
    -- Password reset fields
    password_reset_token TEXT,
    password_reset_expires DATETIME,
    
    -- Account status and preferences
    account_status TEXT NOT NULL DEFAULT 'active' CHECK (account_status IN ('active', 'suspended', 'deleted')),
    timezone TEXT DEFAULT 'UTC',
    language TEXT DEFAULT 'en',
    
    -- Subscription and billing
    subscription_type TEXT NOT NULL DEFAULT 'free' CHECK (subscription_type IN ('free', 'premium', 'family')),
    subscription_expires DATETIME,
    
    -- Privacy and consent
    privacy_consent BOOLEAN NOT NULL DEFAULT FALSE,
    marketing_consent BOOLEAN NOT NULL DEFAULT FALSE,
    data_retention_consent BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Audit fields
    last_login_at DATETIME,
    login_count INTEGER NOT NULL DEFAULT 0,
    failed_login_attempts INTEGER NOT NULL DEFAULT 0,
    account_locked_until DATETIME
);

-- ----------------------------------------------------------------------------
-- Children Table
-- Stores child profiles associated with parents
-- ----------------------------------------------------------------------------
CREATE TABLE children (
    child_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    first_name TEXT NOT NULL,
    birth_date DATE,
    avatar_url TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Child preferences and settings
    reward_points INTEGER NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    preferred_difficulty TEXT DEFAULT 'medium' CHECK (preferred_difficulty IN ('easy', 'medium', 'hard')),
    
    -- Privacy settings for children
    profile_visibility TEXT DEFAULT 'family' CHECK (profile_visibility IN ('family', 'private')),
    
    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    
    FOREIGN KEY (parent_id) REFERENCES parents (parent_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- Categories Table
-- Stores task categories for organization
-- ----------------------------------------------------------------------------
CREATE TABLE categories (
    category_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    color TEXT DEFAULT '#3B82F6',
    icon TEXT DEFAULT 'task',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Category settings
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    
    FOREIGN KEY (parent_id) REFERENCES parents (parent_id) ON DELETE CASCADE,
    UNIQUE (parent_id, name)
);

-- ----------------------------------------------------------------------------
-- Tasks Table
-- Stores individual tasks assigned to children
-- ----------------------------------------------------------------------------
CREATE TABLE tasks (
    task_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    child_id TEXT,
    category_id TEXT,
    title TEXT NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Task scheduling
    due_date DATE,
    due_time TIME,
    recurrence_pattern TEXT, -- JSON string for recurrence rules
    
    -- Task properties
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    difficulty TEXT DEFAULT 'medium' CHECK (difficulty IN ('easy', 'medium', 'hard')),
    estimated_duration INTEGER, -- in minutes
    
    -- Rewards and points
    reward_points INTEGER NOT NULL DEFAULT 10,
    reward_description TEXT,
    
    -- Task status and completion
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'in_progress', 'completed', 'cancelled', 'overdue')),
    completion_date DATETIME,
    completion_notes TEXT,
    
    -- Task assignment
    assigned_at DATETIME,
    
    -- Task validation
    requires_verification BOOLEAN NOT NULL DEFAULT FALSE,
    verification_photo_url TEXT,
    verification_notes TEXT,
    verified_by TEXT,
    verified_at DATETIME,
    
    -- Recurring task tracking
    parent_task_id TEXT, -- Reference to original task for recurring instances
    sequence_number INTEGER DEFAULT 1,
    
    FOREIGN KEY (parent_id) REFERENCES parents (parent_id) ON DELETE CASCADE,
    FOREIGN KEY (child_id) REFERENCES children (child_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES categories (category_id) ON DELETE SET NULL,
    FOREIGN KEY (parent_task_id) REFERENCES tasks (task_id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES parents (parent_id) ON DELETE SET NULL
);

-- ----------------------------------------------------------------------------
-- Task Comments Table
-- Stores comments and communication about tasks
-- ----------------------------------------------------------------------------
CREATE TABLE task_comments (
    comment_id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    author_id TEXT NOT NULL,
    author_type TEXT NOT NULL CHECK (author_type IN ('parent', 'child')),
    content TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Comment properties
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    attachment_url TEXT,
    
    FOREIGN KEY (task_id) REFERENCES tasks (task_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- Rewards Table
-- Stores reward definitions and tracking
-- ----------------------------------------------------------------------------
CREATE TABLE rewards (
    reward_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    child_id TEXT,
    name TEXT NOT NULL,
    description TEXT,
    cost_points INTEGER NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Reward properties
    category TEXT DEFAULT 'general',
    icon TEXT DEFAULT 'gift',
    color TEXT DEFAULT '#10B981',
    
    -- Reward availability
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    max_redemptions INTEGER, -- NULL means unlimited
    redemption_count INTEGER NOT NULL DEFAULT 0,
    
    -- Reward scheduling
    available_from DATE,
    available_until DATE,
    
    FOREIGN KEY (parent_id) REFERENCES parents (parent_id) ON DELETE CASCADE,
    FOREIGN KEY (child_id) REFERENCES children (child_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- Reward Redemptions Table
-- Tracks when rewards are redeemed
-- ----------------------------------------------------------------------------
CREATE TABLE reward_redemptions (
    redemption_id TEXT PRIMARY KEY,
    reward_id TEXT NOT NULL,
    child_id TEXT NOT NULL,
    points_spent INTEGER NOT NULL,
    redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Redemption status
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'fulfilled', 'cancelled')),
    approved_by TEXT,
    approved_at DATETIME,
    fulfilled_at DATETIME,
    notes TEXT,
    
    FOREIGN KEY (reward_id) REFERENCES rewards (reward_id) ON DELETE CASCADE,
    FOREIGN KEY (child_id) REFERENCES children (child_id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES parents (parent_id) ON DELETE SET NULL
);

-- ----------------------------------------------------------------------------
-- Notifications Table
-- Stores system notifications and reminders
-- ----------------------------------------------------------------------------
CREATE TABLE notifications (
    notification_id TEXT PRIMARY KEY,
    recipient_id TEXT NOT NULL,
    recipient_type TEXT NOT NULL CHECK (recipient_type IN ('parent', 'child')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Notification properties
    type TEXT NOT NULL CHECK (type IN ('task_assigned', 'task_completed', 'task_overdue', 'reward_redeemed', 'points_earned', 'system', 'reminder')),
    priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    
    -- Notification status
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at DATETIME,
    
    -- Related entities
    related_task_id TEXT,
    related_reward_id TEXT,
    related_child_id TEXT,
    
    -- Notification delivery
    delivery_method TEXT DEFAULT 'in_app' CHECK (delivery_method IN ('in_app', 'email', 'push')),
    delivered_at DATETIME,
    
    FOREIGN KEY (related_task_id) REFERENCES tasks (task_id) ON DELETE SET NULL,
    FOREIGN KEY (related_reward_id) REFERENCES rewards (reward_id) ON DELETE SET NULL,
    FOREIGN KEY (related_child_id) REFERENCES children (child_id) ON DELETE SET NULL
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Performance indexes for common queries
CREATE INDEX idx_parents_email ON parents (email);
CREATE INDEX idx_children_parent_id ON children (parent_id);
CREATE INDEX idx_tasks_parent_id ON tasks (parent_id);
CREATE INDEX idx_tasks_child_id ON tasks (child_id);
CREATE INDEX idx_tasks_status ON tasks (status);
CREATE INDEX idx_tasks_due_date ON tasks (due_date);
CREATE INDEX idx_task_comments_task_id ON task_comments (task_id);
CREATE INDEX idx_rewards_parent_id ON rewards (parent_id);
CREATE INDEX idx_reward_redemptions_child_id ON reward_redemptions (child_id);
CREATE INDEX idx_notifications_recipient ON notifications (recipient_id, recipient_type);
CREATE INDEX idx_notifications_unread ON notifications (is_read, created_at);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Update timestamp triggers
CREATE TRIGGER update_parents_updated_at
    AFTER UPDATE ON parents
    FOR EACH ROW
    BEGIN
        UPDATE parents SET updated_at = CURRENT_TIMESTAMP WHERE parent_id = NEW.parent_id;
    END;

CREATE TRIGGER update_children_updated_at
    AFTER UPDATE ON children
    FOR EACH ROW
    BEGIN
        UPDATE children SET updated_at = CURRENT_TIMESTAMP WHERE child_id = NEW.child_id;
    END;

CREATE TRIGGER update_tasks_updated_at
    AFTER UPDATE ON tasks
    FOR EACH ROW
    BEGIN
        UPDATE tasks SET updated_at = CURRENT_TIMESTAMP WHERE task_id = NEW.task_id;
    END;

CREATE TRIGGER update_categories_updated_at
    AFTER UPDATE ON categories
    FOR EACH ROW
    BEGIN
        UPDATE categories SET updated_at = CURRENT_TIMESTAMP WHERE category_id = NEW.category_id;
    END;

CREATE TRIGGER update_rewards_updated_at
    AFTER UPDATE ON rewards
    FOR EACH ROW
    BEGIN
        UPDATE rewards SET updated_at = CURRENT_TIMESTAMP WHERE reward_id = NEW.reward_id;
    END;

-- Business logic triggers
CREATE TRIGGER update_redemption_count
    AFTER INSERT ON reward_redemptions
    FOR EACH ROW
    WHEN NEW.status = 'approved'
    BEGIN
        UPDATE rewards 
        SET redemption_count = redemption_count + 1 
        WHERE reward_id = NEW.reward_id;
    END;

CREATE TRIGGER update_child_points_on_completion
    AFTER UPDATE OF status ON tasks
    FOR EACH ROW
    WHEN NEW.status = 'completed' AND OLD.status != 'completed'
    BEGIN
        UPDATE children 
        SET reward_points = reward_points + NEW.reward_points 
        WHERE child_id = NEW.child_id;
    END;
