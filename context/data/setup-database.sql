-- ============================================================================
-- Taskify Database Setup Script
-- ============================================================================
-- Complete database initialization script for SQLite
-- Date: May 26, 2025
--
-- This script will:
-- 1. Create a fresh database
-- 2. Apply the complete schema
-- 3. Load sample data (optional)
-- 4. Verify the setup
-- ============================================================================

-- Enable foreign key constraints (critical for SQLite)
PRAGMA foreign_keys = ON;

-- Performance optimizations for SQLite
-- PRAGMA journal_mode = WAL;
-- PRAGMA synchronous = NORMAL;
-- PRAGMA cache_size = 10000;
-- PRAGMA temp_store = memory;

-- Begin transaction for atomic setup
BEGIN TRANSACTION;

-- ============================================================================
-- SCHEMA CREATION
-- ============================================================================

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS reward_pledges;
DROP TABLE IF EXISTS task_completions;
DROP TABLE IF EXISTS child_badges;
DROP TABLE IF EXISTS badge_types;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS task_lists;
DROP TABLE IF EXISTS children;
DROP TABLE IF EXISTS parents;

-- Drop existing views if they exist
DROP VIEW IF EXISTS task_summary;
DROP VIEW IF EXISTS parent_dashboard;
DROP VIEW IF EXISTS child_stats;

-- ============================================================================
-- TABLE CREATION
-- ============================================================================

-- Parents Table
CREATE TABLE parents (
    parent_id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_parent_email_format CHECK (
        email LIKE '%_@_%.__%' AND 
        LENGTH(email) <= 254 AND 
        LENGTH(email) >= 5
    ),
    CONSTRAINT chk_parent_password_length CHECK (LENGTH(password_hash) >= 60),
    CONSTRAINT chk_parent_name_length CHECK (
        LENGTH(first_name) BETWEEN 1 AND 50 AND 
        LENGTH(last_name) BETWEEN 1 AND 50
    )
);

-- Children Table
CREATE TABLE children (
    child_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_date DATE NOT NULL,
    total_task_points INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_id) REFERENCES parents(parent_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_child_username_format CHECK (
        username GLOB '[A-Za-z0-9_-]*' AND 
        LENGTH(username) BETWEEN 3 AND 30
    ),
    CONSTRAINT chk_child_name_length CHECK (
        LENGTH(first_name) BETWEEN 1 AND 50 AND 
        LENGTH(last_name) BETWEEN 1 AND 50
    ),
    CONSTRAINT chk_child_birth_date CHECK (
        birth_date >= '1900-01-01' AND 
        birth_date <= DATE('2100-01-01')
    ),
    CONSTRAINT chk_child_task_points CHECK (total_task_points >= 0)
);

-- Task Lists Table
CREATE TABLE task_lists (
    list_id TEXT PRIMARY KEY,
    child_id TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    color TEXT NOT NULL,
    is_repeatable BOOLEAN NOT NULL DEFAULT FALSE,
    repeat_frequency TEXT NOT NULL DEFAULT 'none',
    view_type TEXT NOT NULL DEFAULT 'list',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_task_list_name_length CHECK (LENGTH(name) BETWEEN 1 AND 100),
    CONSTRAINT chk_task_list_description_length CHECK (LENGTH(description) <= 500),
    -- CONSTRAINT chk_task_list_color_format CHECK (color GLOB '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]*'),
    CONSTRAINT chk_task_list_repeat_frequency CHECK (
        repeat_frequency IN ('none', 'daily', 'weekly', 'monthly', 'yearly')
    ),
    CONSTRAINT chk_task_list_view_type CHECK (
        view_type IN ('list', 'grid', 'calendar', 'kanban')
    )
);

-- Tasks Table
CREATE TABLE tasks (
    task_id TEXT PRIMARY KEY,
    list_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    task_points INTEGER NOT NULL,
    deadline DATETIME NOT NULL,
    priority TEXT NOT NULL DEFAULT 'medium',
    status TEXT NOT NULL DEFAULT 'pending',
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (list_id) REFERENCES task_lists(list_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_task_title_length CHECK (LENGTH(title) BETWEEN 1 AND 100),
    CONSTRAINT chk_task_description_length CHECK (LENGTH(description) <= 500),
    CONSTRAINT chk_task_points_range CHECK (task_points BETWEEN 1 AND 1000),
    -- CONSTRAINT chk_task_deadline_future CHECK (deadline > created_at),
    CONSTRAINT chk_task_priority CHECK (
        priority IN ('low', 'medium', 'high', 'urgent')
    ),
    CONSTRAINT chk_task_status CHECK (
        status IN ('pending', 'in_progress', 'completed', 'cancelled', 'overdue')
    ),
    CONSTRAINT chk_task_completion_consistency CHECK (
        (is_completed = TRUE AND completed_at IS NOT NULL AND status = 'completed') OR
        (is_completed = FALSE AND (completed_at IS NULL OR status != 'completed'))
    )
);

-- Badge Types Table
CREATE TABLE badge_types (
    badge_type_id TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    icon TEXT NOT NULL,
    color TEXT NOT NULL,
    required_count INTEGER NOT NULL,
    task_category TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    
    CONSTRAINT chk_badge_name_length CHECK (LENGTH(name) BETWEEN 1 AND 50),
    CONSTRAINT chk_badge_description_length CHECK (LENGTH(description) BETWEEN 1 AND 500),
    CONSTRAINT chk_badge_icon_length CHECK (LENGTH(icon) BETWEEN 1 AND 50),
    -- CONSTRAINT chk_badge_color_format CHECK (color GLOB '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]*'),
    CONSTRAINT chk_badge_required_count CHECK (required_count BETWEEN 1 AND 1000),
    CONSTRAINT chk_badge_task_category CHECK (
        task_category IN ('chores', 'homework', 'exercise', 'reading', 'creative', 'social', 'other')
    ),
    CONSTRAINT chk_badge_duration_days CHECK (duration_days BETWEEN 1 AND 365)
);

-- Child Badges Table
CREATE TABLE child_badges (
    child_badge_id TEXT PRIMARY KEY,
    child_id TEXT NOT NULL,
    badge_type_id TEXT NOT NULL,
    earned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    awarded_by TEXT NOT NULL,
    
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    FOREIGN KEY (badge_type_id) REFERENCES badge_types(badge_type_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_child_badge_awarded_by_length CHECK (LENGTH(awarded_by) BETWEEN 1 AND 50),
    UNIQUE(child_id, badge_type_id)
);

-- Task Completions Table
CREATE TABLE task_completions (
    completion_id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    child_id TEXT NOT NULL,
    completed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    points_earned INTEGER NOT NULL,
    
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_completion_points_earned CHECK (points_earned >= 0)
);

-- Reward Pledges Table
CREATE TABLE reward_pledges (
    pledge_id TEXT PRIMARY KEY,
    child_id TEXT NOT NULL,
    parent_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    required_points INTEGER NOT NULL,
    is_redeemed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    redeemed_at DATETIME NULL,
    
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES parents(parent_id) ON DELETE CASCADE,
    
    CONSTRAINT chk_reward_title_length CHECK (LENGTH(title) BETWEEN 1 AND 100),
    CONSTRAINT chk_reward_description_length CHECK (LENGTH(description) <= 500),
    CONSTRAINT chk_reward_required_points CHECK (required_points BETWEEN 1 AND 10000),
    CONSTRAINT chk_reward_redemption_consistency CHECK (
        (is_redeemed = TRUE AND redeemed_at IS NOT NULL) OR
        (is_redeemed = FALSE AND redeemed_at IS NULL)
    )
);

-- Notifications Table
CREATE TABLE notifications (
    notification_id TEXT PRIMARY KEY,
    child_id TEXT NOT NULL,
    task_id TEXT NULL,
    type TEXT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    scheduled_for DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE SET NULL,
    
    CONSTRAINT chk_notification_type CHECK (
        type IN ('task_reminder', 'task_overdue', 'badge_earned', 'reward_available', 'task_completed')
    ),
    CONSTRAINT chk_notification_message_length CHECK (LENGTH(message) BETWEEN 1 AND 1000)
);

-- ============================================================================
-- INDEX CREATION
-- ============================================================================

-- Parent indexes
CREATE INDEX idx_parent_email ON parents(email);

-- Child indexes
CREATE INDEX idx_child_parent_id ON children(parent_id);
CREATE INDEX idx_child_username ON children(username);
CREATE INDEX idx_child_birth_date ON children(birth_date);
CREATE INDEX idx_child_task_points ON children(total_task_points);

-- Task list indexes
CREATE INDEX idx_task_list_child_id ON task_lists(child_id);
CREATE INDEX idx_task_list_name ON task_lists(name);

-- Task indexes
CREATE INDEX idx_task_list_id ON tasks(list_id);
CREATE INDEX idx_task_deadline ON tasks(deadline);
CREATE INDEX idx_task_status ON tasks(status);
CREATE INDEX idx_task_priority ON tasks(priority);
CREATE INDEX idx_task_completed ON tasks(is_completed);
CREATE INDEX idx_task_completed_at ON tasks(completed_at);
CREATE INDEX idx_task_title ON tasks(title);

-- Badge indexes
CREATE INDEX idx_badge_type_name ON badge_types(name);
CREATE INDEX idx_badge_type_category ON badge_types(task_category);
CREATE INDEX idx_child_badge_child_id ON child_badges(child_id);
CREATE INDEX idx_child_badge_type_id ON child_badges(badge_type_id);
CREATE INDEX idx_child_badge_earned_at ON child_badges(earned_at);

-- Task completion indexes
CREATE INDEX idx_task_completion_task_id ON task_completions(task_id);
CREATE INDEX idx_task_completion_child_id ON task_completions(child_id);
CREATE INDEX idx_task_completion_completed_at ON task_completions(completed_at);

-- Reward pledge indexes
CREATE INDEX idx_reward_pledge_child_id ON reward_pledges(child_id);
CREATE INDEX idx_reward_pledge_parent_id ON reward_pledges(parent_id);
CREATE INDEX idx_reward_pledge_redeemed ON reward_pledges(is_redeemed);
CREATE INDEX idx_reward_pledge_created_at ON reward_pledges(created_at);

-- Notification indexes
CREATE INDEX idx_notification_child_id ON notifications(child_id);
CREATE INDEX idx_notification_task_id ON notifications(task_id);
CREATE INDEX idx_notification_type ON notifications(type);
CREATE INDEX idx_notification_read ON notifications(is_read);
CREATE INDEX idx_notification_scheduled_for ON notifications(scheduled_for);
CREATE INDEX idx_notification_created_at ON notifications(created_at);

-- ============================================================================
-- TRIGGER CREATION
-- ============================================================================

-- Update timestamp triggers
CREATE TRIGGER trg_parent_updated_at 
    AFTER UPDATE ON parents
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE parents SET updated_at = CURRENT_TIMESTAMP WHERE parent_id = NEW.parent_id;
END;

CREATE TRIGGER trg_child_updated_at 
    AFTER UPDATE ON children
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE children SET updated_at = CURRENT_TIMESTAMP WHERE child_id = NEW.child_id;
END;

CREATE TRIGGER trg_task_list_updated_at 
    AFTER UPDATE ON task_lists
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE task_lists SET updated_at = CURRENT_TIMESTAMP WHERE list_id = NEW.list_id;
END;

CREATE TRIGGER trg_task_updated_at 
    AFTER UPDATE ON tasks
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE tasks SET updated_at = CURRENT_TIMESTAMP WHERE task_id = NEW.task_id;
END;

-- Business logic triggers
CREATE TRIGGER trg_task_completion_status
    AFTER UPDATE OF is_completed ON tasks
    FOR EACH ROW
    WHEN NEW.is_completed = TRUE AND OLD.is_completed = FALSE
BEGIN
    UPDATE tasks 
    SET completed_at = CURRENT_TIMESTAMP, 
        status = 'completed'
    WHERE task_id = NEW.task_id;
END;

CREATE TRIGGER trg_task_incomplete_status
    AFTER UPDATE OF is_completed ON tasks
    FOR EACH ROW
    WHEN NEW.is_completed = FALSE AND OLD.is_completed = TRUE
BEGIN
    UPDATE tasks 
    SET completed_at = NULL,
        status = CASE 
            WHEN NEW.deadline < CURRENT_TIMESTAMP THEN 'overdue'
            ELSE 'pending'
        END
    WHERE task_id = NEW.task_id;
END;

CREATE TRIGGER trg_update_child_points_on_completion
    AFTER INSERT ON task_completions
    FOR EACH ROW
BEGIN
    UPDATE children 
    SET total_task_points = total_task_points + NEW.points_earned
    WHERE child_id = NEW.child_id;
END;

CREATE TRIGGER trg_update_child_points_on_completion_delete
    AFTER DELETE ON task_completions
    FOR EACH ROW
BEGIN
    UPDATE children 
    SET total_task_points = total_task_points - OLD.points_earned
    WHERE child_id = OLD.child_id;
END;

CREATE TRIGGER trg_reward_redemption_timestamp
    AFTER UPDATE OF is_redeemed ON reward_pledges
    FOR EACH ROW
    WHEN NEW.is_redeemed = TRUE AND OLD.is_redeemed = FALSE
BEGIN
    UPDATE reward_pledges 
    SET redeemed_at = CURRENT_TIMESTAMP
    WHERE pledge_id = NEW.pledge_id;
END;

CREATE TRIGGER trg_reward_unredemption_timestamp
    AFTER UPDATE OF is_redeemed ON reward_pledges
    FOR EACH ROW
    WHEN NEW.is_redeemed = FALSE AND OLD.is_redeemed = TRUE
BEGIN
    UPDATE reward_pledges 
    SET redeemed_at = NULL
    WHERE pledge_id = NEW.pledge_id;
END;

-- ============================================================================
-- VIEW CREATION
-- ============================================================================

-- Child Statistics View
CREATE VIEW child_stats AS
SELECT 
    c.child_id,
    c.username,
    c.first_name,
    c.last_name,
    c.total_task_points,
    c.birth_date,
    
    COUNT(DISTINCT t.task_id) as total_tasks,
    COUNT(DISTINCT CASE WHEN t.is_completed = TRUE THEN t.task_id END) as completed_tasks,
    COUNT(DISTINCT CASE WHEN t.status = 'pending' THEN t.task_id END) as pending_tasks,
    COUNT(DISTINCT CASE WHEN t.status = 'overdue' THEN t.task_id END) as overdue_tasks,
    COUNT(DISTINCT cb.child_badge_id) as total_badges,
    COUNT(DISTINCT rp.pledge_id) as total_rewards,
    COUNT(DISTINCT CASE WHEN rp.is_redeemed = TRUE THEN rp.pledge_id END) as redeemed_rewards,
    COUNT(DISTINCT CASE 
        WHEN tc.completed_at >= datetime('now', '-7 days') 
        THEN tc.completion_id 
    END) as tasks_completed_week,
    COALESCE(SUM(CASE 
        WHEN tc.completed_at >= datetime('now', '-7 days') 
        THEN tc.points_earned 
        ELSE 0 
    END), 0) as points_earned_week

FROM children c
LEFT JOIN task_lists tl ON c.child_id = tl.child_id
LEFT JOIN tasks t ON tl.list_id = t.list_id
LEFT JOIN child_badges cb ON c.child_id = cb.child_id
LEFT JOIN reward_pledges rp ON c.child_id = rp.child_id
LEFT JOIN task_completions tc ON c.child_id = tc.child_id

GROUP BY c.child_id, c.username, c.first_name, c.last_name, c.total_task_points, c.birth_date;

-- ============================================================================
-- DEFAULT DATA INSERTION
-- ============================================================================

-- Default badge types
INSERT INTO badge_types (badge_type_id, name, description, icon, color, required_count, task_category, duration_days) VALUES
('badge_first_task', 'First Task', 'Complete your very first task', '🎉', '#FFD700', 1, 'other', 1),
('badge_early_bird', 'Early Bird', 'Complete 5 tasks before their deadline', '🐦', '#87CEEB', 5, 'other', 30),
('badge_streak_week', 'Week Warrior', 'Complete tasks for 7 consecutive days', '🔥', '#FF4500', 7, 'other', 7),
('badge_chore_master', 'Chore Master', 'Complete 20 household chores', '🏠', '#32CD32', 20, 'chores', 30),
('badge_homework_hero', 'Homework Hero', 'Complete 15 homework assignments', '📚', '#4169E1', 15, 'homework', 30),
('badge_fitness_fan', 'Fitness Fan', 'Complete 10 exercise activities', '💪', '#FF6347', 10, 'exercise', 30),
('badge_bookworm', 'Bookworm', 'Complete 12 reading tasks', '🐛', '#8B4513', 12, 'reading', 30),
('badge_artist', 'Creative Artist', 'Complete 8 creative projects', '🎨', '#9370DB', 8, 'creative', 30),
('badge_social_butterfly', 'Social Butterfly', 'Complete 6 social activities', '🦋', '#FF69B4', 6, 'social', 30);

-- Email Verification Schema Extension
-- Add email verification support to the existing schema

-- Add email verification columns to parents table
ALTER TABLE parents ADD COLUMN email_verified BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE parents ADD COLUMN email_verified_at DATETIME NULL;

-- Create email verification tokens table
CREATE TABLE email_verification_tokens (
    token_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    email TEXT NOT NULL,
    token_hash TEXT NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    used_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    invalidated_at DATETIME NULL,
    
    -- Foreign key constraints
    FOREIGN KEY (parent_id) REFERENCES parents(parent_id) ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_token_expiry CHECK (expires_at > created_at),
    CONSTRAINT chk_email_format CHECK (
        email LIKE '%_@_%.__%' AND 
        LENGTH(email) <= 254 AND 
        LENGTH(email) >= 5
    )
);

-- Create indexes for performance
CREATE INDEX idx_email_verification_tokens_parent_id ON email_verification_tokens(parent_id);
CREATE INDEX idx_email_verification_tokens_token_hash ON email_verification_tokens(token_hash);
CREATE INDEX idx_email_verification_tokens_email ON email_verification_tokens(email);
CREATE INDEX idx_email_verification_tokens_expires_at ON email_verification_tokens(expires_at);
CREATE INDEX idx_parents_email_verified ON parents(email_verified);

-- Create trigger to update parent's updated_at when email is verified
CREATE TRIGGER trg_update_parent_on_email_verification
    AFTER UPDATE OF email_verified ON parents
    FOR EACH ROW
    WHEN NEW.email_verified = TRUE AND OLD.email_verified = FALSE
BEGIN
    UPDATE parents 
    SET updated_at = CURRENT_TIMESTAMP,
        email_verified_at = CURRENT_TIMESTAMP
    WHERE parent_id = NEW.parent_id;
END;

-- Commit the transaction
COMMIT;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify schema creation
SELECT 'Tables created successfully' as status;

SELECT name as table_name 
FROM sqlite_master 
WHERE type='table' 
AND name NOT LIKE 'sqlite_%'
ORDER BY name;

SELECT 'Indexes created successfully' as status;

SELECT name as index_name 
FROM sqlite_master 
WHERE type='index' 
AND name NOT LIKE 'sqlite_%'
ORDER BY name;

SELECT 'Triggers created successfully' as status;

SELECT name as trigger_name 
FROM sqlite_master 
WHERE type='trigger'
ORDER BY name;

SELECT 'Views created successfully' as status;

SELECT name as view_name 
FROM sqlite_master 
WHERE type='view'
ORDER BY name;

-- Check badge types
SELECT 'Default badge types loaded:' as status;

SELECT COUNT(*) as badge_count FROM badge_types;

-- Final status
SELECT 'Database setup completed successfully!' as final_status;
