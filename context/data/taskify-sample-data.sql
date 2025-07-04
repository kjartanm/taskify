-- ============================================================================
-- Taskify SQLite Sample Data
-- ============================================================================
-- Sample data for testing and development purposes
-- Date: May 26, 2025
-- 
-- This file provides realistic sample data for the Taskify application
-- including parents, children, tasks, badges, and other entities.
-- ============================================================================

-- Note: This assumes the schema from taskify-sqlite-schema.sql has been loaded

-- ============================================================================
-- SAMPLE PARENTS
-- ============================================================================

INSERT INTO parents (parent_id, email, password_hash, first_name, last_name) VALUES
('parent_001', 'john.smith@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewwCc6j6tgHg7/d.', 'John', 'Smith'),
('parent_002', 'sarah.johnson@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewwCc6j6tgHg7/d.', 'Sarah', 'Johnson'),
('parent_003', 'mike.davis@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewwCc6j6tgHg7/d.', 'Mike', 'Davis'),
('parent_004', 'lisa.wilson@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewwCc6j6tgHg7/d.', 'Lisa', 'Wilson');

-- ============================================================================
-- SAMPLE CHILDREN
-- ============================================================================

INSERT INTO children (child_id, parent_id, username, first_name, last_name, birth_date, total_task_points) VALUES
('child_001', 'parent_001', 'emma_s', 'Emma', 'Smith', '2015-03-15', 150),
('child_002', 'parent_001', 'alex_s', 'Alex', 'Smith', '2012-08-22', 275),
('child_003', 'parent_002', 'maya_j', 'Maya', 'Johnson', '2014-11-08', 98),
('child_004', 'parent_002', 'tommy_j', 'Tommy', 'Johnson', '2016-05-12', 42),
('child_005', 'parent_003', 'sophie_d', 'Sophie', 'Davis', '2013-09-30', 189),
('child_006', 'parent_004', 'jacob_w', 'Jacob', 'Wilson', '2015-01-18', 67);

-- ============================================================================
-- SAMPLE TASK LISTS
-- ============================================================================

INSERT INTO task_lists (list_id, child_id, name, description, color, is_repeatable, repeat_frequency, view_type) VALUES
-- Emma's lists
('list_001', 'child_001', 'Daily Chores', 'Regular household tasks', '#FF6B6B', true, 'daily', 'list'),
('list_002', 'child_001', 'School Work', 'Homework and study tasks', '#4ECDC4', false, 'none', 'calendar'),
('list_003', 'child_001', 'Fun Activities', 'Creative and recreational tasks', '#45B7D1', false, 'none', 'grid'),

-- Alex's lists
('list_004', 'child_002', 'Chores', 'Weekly household responsibilities', '#96CEB4', true, 'weekly', 'kanban'),
('list_005', 'child_002', 'Homework', 'School assignments and projects', '#FFEAA7', false, 'none', 'list'),
('list_006', 'child_002', 'Sports & Exercise', 'Physical activities and training', '#DDA0DD', false, 'none', 'grid'),

-- Maya's lists
('list_007', 'child_003', 'Room Care', 'Bedroom organization and cleaning', '#98D8C8', true, 'daily', 'list'),
('list_008', 'child_003', 'Learning', 'Educational activities', '#F7DC6F', false, 'none', 'calendar'),

-- Tommy's lists
('list_009', 'child_004', 'Simple Tasks', 'Age-appropriate daily tasks', '#BB8FCE', true, 'daily', 'grid'),

-- Sophie's lists
('list_010', 'child_005', 'Weekly Duties', 'Regular weekly responsibilities', '#85C1E9', true, 'weekly', 'kanban'),
('list_011', 'child_005', 'Art Projects', 'Creative and artistic endeavors', '#F8C471', false, 'none', 'grid'),

-- Jacob's lists
('list_012', 'child_006', 'Daily Habits', 'Everyday routine tasks', '#82E0AA', true, 'daily', 'list');

-- ============================================================================
-- SAMPLE TASKS
-- ============================================================================

-- Emma's tasks
INSERT INTO tasks (task_id, list_id, title, description, task_points, deadline, priority, status, is_completed, completed_at) VALUES
('task_001', 'list_001', 'Make bed', 'Make bed neatly every morning', 5, '2025-05-27 09:00:00', 'low', 'completed', true, '2025-05-26 08:30:00'),
('task_002', 'list_001', 'Feed pet cat', 'Give Whiskers breakfast and dinner', 10, '2025-05-27 18:00:00', 'medium', 'pending', false, null),
('task_003', 'list_002', 'Math homework', 'Complete pages 42-45 in workbook', 25, '2025-05-28 16:00:00', 'high', 'in_progress', false, null),
('task_004', 'list_003', 'Draw a picture', 'Create artwork for grandmas birthday', 15, '2025-05-30 12:00:00', 'medium', 'pending', false, null),

-- Alex's tasks
('task_005', 'list_004', 'Take out trash', 'Empty all wastebaskets and take to curb', 15, '2025-05-27 07:00:00', 'medium', 'completed', true, '2025-05-26 19:00:00'),
('task_006', 'list_004', 'Vacuum living room', 'Vacuum carpet and under furniture', 20, '2025-05-28 14:00:00', 'medium', 'pending', false, null),
('task_007', 'list_005', 'Science project', 'Research and write report on solar system', 50, '2025-06-02 09:00:00', 'urgent', 'in_progress', false, null),
('task_008', 'list_006', 'Soccer practice', 'Attend team practice at community center', 30, '2025-05-27 16:00:00', 'high', 'pending', false, null),

-- Maya's tasks
('task_009', 'list_007', 'Organize bookshelf', 'Sort books by size and put away properly', 12, '2025-05-27 15:00:00', 'low', 'pending', false, null),
('task_010', 'list_008', 'Read chapter 3', 'Read and summarize chapter 3 of class novel', 20, '2025-05-28 20:00:00', 'medium', 'pending', false, null),

-- Tommy's tasks
('task_011', 'list_009', 'Put toys away', 'Clean up toys before bedtime', 8, '2025-05-26 20:00:00', 'low', 'completed', true, '2025-05-26 19:45:00'),
('task_012', 'list_009', 'Brush teeth', 'Brush teeth morning and evening', 5, '2025-05-27 21:00:00', 'medium', 'pending', false, null),

-- Sophie's tasks
('task_013', 'list_010', 'Load dishwasher', 'Load dinner dishes and start cycle', 18, '2025-05-28 21:00:00', 'medium', 'pending', false, null),
('task_014', 'list_011', 'Paint landscape', 'Complete watercolor painting started last week', 35, '2025-06-01 17:00:00', 'low', 'in_progress', false, null),

-- Jacob's tasks
('task_015', 'list_012', 'Water plants', 'Water indoor plants with watering can', 10, '2025-05-27 10:00:00', 'medium', 'pending', false, null),
('task_016', 'list_012', 'Set table', 'Set table for family dinner', 8, '2025-05-26 18:00:00', 'medium', 'completed', true, '2025-05-26 17:30:00');

-- ============================================================================
-- SAMPLE TASK COMPLETIONS
-- ============================================================================

INSERT INTO task_completions (completion_id, task_id, child_id, completed_at, points_earned) VALUES
('comp_001', 'task_001', 'child_001', '2025-05-26 08:30:00', 5),
('comp_002', 'task_005', 'child_002', '2025-05-26 19:00:00', 15),
('comp_003', 'task_011', 'child_004', '2025-05-26 19:45:00', 8),
('comp_004', 'task_016', 'child_006', '2025-05-26 17:30:00', 8),

-- Historical completions for building up points
('comp_005', 'task_001', 'child_001', '2025-05-25 08:30:00', 5),
('comp_006', 'task_001', 'child_001', '2025-05-24 08:30:00', 5),
('comp_007', 'task_001', 'child_001', '2025-05-23 08:30:00', 5),
('comp_008', 'task_005', 'child_002', '2025-05-19 19:00:00', 15),
('comp_009', 'task_005', 'child_002', '2025-05-12 19:00:00', 15),
('comp_010', 'task_011', 'child_004', '2025-05-25 19:45:00', 8);

-- ============================================================================
-- SAMPLE CHILD BADGES
-- ============================================================================

INSERT INTO child_badges (child_badge_id, child_id, badge_type_id, earned_at, awarded_by) VALUES
('cbadge_001', 'child_001', 'badge_first_task', '2025-05-20 10:00:00', 'System'),
('cbadge_002', 'child_002', 'badge_first_task', '2025-05-18 15:30:00', 'System'),
('cbadge_003', 'child_002', 'badge_early_bird', '2025-05-25 14:20:00', 'parent_001'),
('cbadge_004', 'child_004', 'badge_first_task', '2025-05-21 20:00:00', 'System'),
('cbadge_005', 'child_005', 'badge_first_task', '2025-05-15 12:45:00', 'System'),
('cbadge_006', 'child_006', 'badge_first_task', '2025-05-22 18:00:00', 'System');

-- ============================================================================
-- SAMPLE REWARD PLEDGES
-- ============================================================================

INSERT INTO reward_pledges (pledge_id, child_id, parent_id, title, description, required_points, is_redeemed, redeemed_at) VALUES
('reward_001', 'child_001', 'parent_001', 'Movie Night Choice', 'Pick the family movie for Friday night', 50, false, null),
('reward_002', 'child_001', 'parent_001', 'Extra Screen Time', '30 minutes additional tablet time on weekend', 25, true, '2025-05-25 16:00:00'),
('reward_003', 'child_002', 'parent_001', 'New Video Game', 'Choose a new game for gaming console', 200, false, null),
('reward_004', 'child_002', 'parent_001', 'Friend Sleepover', 'Have a friend over for sleepover', 100, false, null),
('reward_005', 'child_003', 'parent_002', 'Art Supplies', 'New set of colored pencils and sketch pad', 75, false, null),
('reward_006', 'child_004', 'parent_002', 'Playground Trip', 'Special trip to the big playground', 30, false, null),
('reward_007', 'child_005', 'parent_003', 'Music Lesson', 'Extra piano lesson with favorite teacher', 150, false, null),
('reward_008', 'child_006', 'parent_004', 'Ice Cream Outing', 'Choose ice cream flavors for family', 40, false, null);

-- ============================================================================
-- SAMPLE NOTIFICATIONS
-- ============================================================================

INSERT INTO notifications (notification_id, child_id, task_id, type, message, is_read, scheduled_for) VALUES
('notif_001', 'child_001', 'task_002', 'task_reminder', 'Don''t forget to feed Whiskers today!', false, '2025-05-27 17:00:00'),
('notif_002', 'child_001', 'task_003', 'task_reminder', 'Math homework is due tomorrow', false, '2025-05-27 15:00:00'),
('notif_003', 'child_002', 'task_007', 'task_reminder', 'Science project deadline approaching', false, '2025-05-29 10:00:00'),
('notif_004', 'child_002', 'task_008', 'task_reminder', 'Soccer practice starts in 2 hours', false, '2025-05-27 14:00:00'),
('notif_005', 'child_001', null, 'badge_earned', 'Congratulations! You earned the Early Bird badge!', true, '2025-05-25 14:20:00'),
('notif_006', 'child_003', 'task_009', 'task_reminder', 'Time to organize your bookshelf', false, '2025-05-27 14:00:00'),
('notif_007', 'child_005', 'task_013', 'task_reminder', 'Remember to load the dishwasher after dinner', false, '2025-05-28 20:00:00'),
('notif_008', 'child_006', 'task_015', 'task_reminder', 'Plants need watering today', false, '2025-05-27 09:00:00');

-- ============================================================================
-- ADDITIONAL BADGE TYPES (beyond the defaults)
-- ============================================================================

INSERT INTO badge_types (badge_type_id, name, description, icon, color, required_count, task_category, duration_days) VALUES
('badge_super_star', 'Super Star', 'Complete 50 tasks in one month', '⭐', '#FFD700', 50, 'other', 30),
('badge_helping_hand', 'Helping Hand', 'Complete 25 chore tasks', '🤝', '#90EE90', 25, 'chores', 60),
('badge_brain_power', 'Brain Power', 'Complete 20 homework assignments', '🧠', '#87CEEB', 20, 'homework', 45),
('badge_fitness_champion', 'Fitness Champion', 'Complete 15 exercise activities', '🏆', '#FF6347', 15, 'exercise', 30),
('badge_reading_rocket', 'Reading Rocket', 'Complete 18 reading tasks', '🚀', '#8B4513', 18, 'reading', 60),
('badge_creative_genius', 'Creative Genius', 'Complete 12 creative projects', '💡', '#9370DB', 12, 'creative', 45),
('badge_social_star', 'Social Star', 'Complete 10 social activities', '🌟', '#FF69B4', 10, 'social', 30),
('badge_consistency_king', 'Consistency King', 'Complete tasks for 14 consecutive days', '👑', '#FFD700', 14, 'other', 14),
('badge_point_collector', 'Point Collector', 'Earn 500 total points', '💎', '#00CED1', 500, 'other', 365);

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- These queries can be run to verify the sample data was inserted correctly

/*
-- Check parent-child relationships
SELECT 
    p.first_name || ' ' || p.last_name as parent_name,
    COUNT(c.child_id) as number_of_children,
    GROUP_CONCAT(c.first_name, ', ') as children_names
FROM parents p
LEFT JOIN children c ON p.parent_id = c.parent_id
GROUP BY p.parent_id, p.first_name, p.last_name;

-- Check task distribution
SELECT 
    c.first_name as child_name,
    COUNT(t.task_id) as total_tasks,
    COUNT(CASE WHEN t.is_completed = TRUE THEN 1 END) as completed_tasks,
    COUNT(CASE WHEN t.status = 'pending' THEN 1 END) as pending_tasks,
    c.total_task_points
FROM children c
LEFT JOIN task_lists tl ON c.child_id = tl.child_id
LEFT JOIN tasks t ON tl.list_id = t.list_id
GROUP BY c.child_id, c.first_name, c.total_task_points
ORDER BY c.first_name;

-- Check badge distribution
SELECT 
    c.first_name as child_name,
    COUNT(cb.child_badge_id) as badges_earned,
    GROUP_CONCAT(bt.name, ', ') as badge_names
FROM children c
LEFT JOIN child_badges cb ON c.child_id = cb.child_id
LEFT JOIN badge_types bt ON cb.badge_type_id = bt.badge_type_id
GROUP BY c.child_id, c.first_name
ORDER BY COUNT(cb.child_badge_id) DESC;

-- Check reward status
SELECT 
    c.first_name as child_name,
    COUNT(rp.pledge_id) as total_rewards,
    COUNT(CASE WHEN rp.is_redeemed = TRUE THEN 1 END) as redeemed_rewards,
    COUNT(CASE WHEN rp.is_redeemed = FALSE THEN 1 END) as pending_rewards
FROM children c
LEFT JOIN reward_pledges rp ON c.child_id = rp.child_id
GROUP BY c.child_id, c.first_name
ORDER BY c.first_name;
*/
