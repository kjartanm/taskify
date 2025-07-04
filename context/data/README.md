# Taskify SQLite Database Schema

This directory contains the complete SQLite database schema and setup files for the Taskify family task management application.

## Files Overview

### 📄 Core Schema Files

- **`taskify-sqlite-schema.sql`** - Complete database schema with all tables, indexes, triggers, and views
- **`setup-database.sql`** - Complete setup script that creates a fresh database from scratch
- **`taskify-sample-data.sql`** - Sample data for testing and development

### 🗂️ Database Structure

The schema implements the following entity relationships from the entity-relations diagram:

#### Core Tables
- **`parents`** - Parent/guardian accounts
- **`children`** - Child accounts linked to parents
- **`task_lists`** - Task categories/lists for each child
- **`tasks`** - Individual tasks within lists
- **`badge_types`** - Available achievement badges
- **`child_badges`** - Badges earned by children
- **`task_completions`** - Task completion history
- **`reward_pledges`** - Rewards from parents to children
- **`notifications`** - System notifications for children

#### Key Features
- ✅ **Foreign Key Constraints** - Proper relational integrity
- ✅ **Check Constraints** - Data validation at database level
- ✅ **Triggers** - Automatic timestamp updates and business logic
- ✅ **Indexes** - Optimized for common query patterns
- ✅ **Views** - Pre-built aggregations for dashboards
- ✅ **Sample Data** - Realistic test data for development

## Quick Start

### Option 1: Complete Setup (Recommended)
```bash
# Create and initialize the database with schema and sample data
sqlite3 taskify.db < setup-database.sql
sqlite3 taskify.db < taskify-sample-data.sql
```

### Option 2: Schema Only
```bash
# Create database with schema only (no sample data)
sqlite3 taskify.db < setup-database.sql
```

### Option 3: Manual Setup
```bash
# Step-by-step setup
sqlite3 taskify.db < taskify-sqlite-schema.sql
# Optionally add sample data
sqlite3 taskify.db < taskify-sample-data.sql
```

## Database Schema Details

### Constraints and Validation

The schema includes comprehensive data validation:

```sql
-- Email format validation
CONSTRAINT chk_parent_email_format CHECK (
    email LIKE '%_@_%.__%' AND 
    LENGTH(email) <= 254 AND 
    LENGTH(email) >= 5
)

-- Username format validation
CONSTRAINT chk_child_username_format CHECK (
    username GLOB '[A-Za-z0-9_-]*' AND 
    LENGTH(username) BETWEEN 3 AND 30
)

-- Task points range validation
CONSTRAINT chk_task_points_range CHECK (task_points BETWEEN 1 AND 1000)

-- Color hex format validation
CONSTRAINT chk_task_list_color_format CHECK (
    color GLOB '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]'
)
```

### Automatic Triggers

Several triggers maintain data consistency:

```sql
-- Auto-update timestamps
CREATE TRIGGER trg_child_updated_at 
    AFTER UPDATE ON children
    FOR EACH ROW
BEGIN
    UPDATE children SET updated_at = CURRENT_TIMESTAMP WHERE child_id = NEW.child_id;
END;

-- Auto-update child points when tasks are completed
CREATE TRIGGER trg_update_child_points_on_completion
    AFTER INSERT ON task_completions
    FOR EACH ROW
BEGIN
    UPDATE children 
    SET total_task_points = total_task_points + NEW.points_earned
    WHERE child_id = NEW.child_id;
END;
```

### Performance Indexes

Optimized indexes for common query patterns:

```sql
-- Primary lookup indexes
CREATE INDEX idx_child_parent_id ON children(parent_id);
CREATE INDEX idx_task_list_child_id ON task_lists(child_id);
CREATE INDEX idx_task_list_id ON tasks(list_id);

-- Query optimization indexes
CREATE INDEX idx_task_deadline ON tasks(deadline);
CREATE INDEX idx_task_status ON tasks(status);
CREATE INDEX idx_notification_scheduled_for ON notifications(scheduled_for);
```

### Useful Views

Pre-built views for common dashboard queries:

```sql
-- Child statistics aggregation
SELECT * FROM child_stats WHERE child_id = 'child_001';

-- Parent dashboard summary
SELECT * FROM parent_dashboard WHERE parent_id = 'parent_001';

-- Task details with relationships
SELECT * FROM task_summary WHERE child_id = 'child_001';
```

## Sample Data Overview

The sample data includes:
- **4 parents** with realistic profiles
- **6 children** across different families
- **12 task lists** with various configurations
- **16 tasks** in different states (pending, completed, overdue)
- **10 task completions** with points earned
- **6 badges earned** by various children
- **8 reward pledges** from parents
- **8 notifications** for reminders and updates

### Sample Families

1. **Smith Family** (john.smith@email.com)
   - Emma Smith (emma_s) - 150 points
   - Alex Smith (alex_s) - 275 points

2. **Johnson Family** (sarah.johnson@email.com)
   - Maya Johnson (maya_j) - 98 points
   - Tommy Johnson (tommy_j) - 42 points

3. **Davis Family** (mike.davis@email.com)
   - Sophie Davis (sophie_d) - 189 points

4. **Wilson Family** (lisa.wilson@email.com)
   - Jacob Wilson (jacob_w) - 67 points

## Verification Queries

After setup, verify the database with these queries:

```sql
-- Check table structure
SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;

-- Check parent-child relationships
SELECT 
    p.first_name || ' ' || p.last_name as parent_name,
    COUNT(c.child_id) as number_of_children,
    GROUP_CONCAT(c.first_name, ', ') as children_names
FROM parents p
LEFT JOIN children c ON p.parent_id = c.parent_id
GROUP BY p.parent_id;

-- Check task distribution
SELECT 
    c.first_name as child_name,
    COUNT(t.task_id) as total_tasks,
    COUNT(CASE WHEN t.is_completed = TRUE THEN 1 END) as completed_tasks,
    c.total_task_points
FROM children c
LEFT JOIN task_lists tl ON c.child_id = tl.child_id
LEFT JOIN tasks t ON tl.list_id = t.list_id
GROUP BY c.child_id, c.first_name, c.total_task_points;

-- Check badge distribution
SELECT 
    c.first_name as child_name,
    COUNT(cb.child_badge_id) as badges_earned,
    GROUP_CONCAT(bt.name, ', ') as badge_names
FROM children c
LEFT JOIN child_badges cb ON c.child_id = cb.child_id
LEFT JOIN badge_types bt ON cb.badge_type_id = bt.badge_type_id
GROUP BY c.child_id, c.first_name;
```

## Database Configuration

### SQLite Pragmas

The setup script includes performance optimizations:

```sql
PRAGMA foreign_keys = ON;          -- Enable foreign key constraints
PRAGMA journal_mode = WAL;         -- Write-Ahead Logging for better concurrency
PRAGMA synchronous = NORMAL;       -- Balanced durability/performance
PRAGMA cache_size = 10000;         -- Larger cache for better performance
PRAGMA temp_store = memory;        -- Store temp tables in memory
```

### Connection String Examples

**Node.js (sqlite3)**
```javascript
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./taskify.db');
```

**Python (sqlite3)**
```python
import sqlite3
conn = sqlite3.connect('taskify.db')
```

**Go (go-sqlite3)**
```go
import (
    "database/sql"
    _ "github.com/mattn/go-sqlite3"
)

db, err := sql.Open("sqlite3", "./taskify.db")
```

## Schema Migration

When updating the schema:

1. **Backup existing data**
   ```bash
   sqlite3 taskify.db ".backup taskify_backup.db"
   ```

2. **Test migrations on backup**
   ```bash
   sqlite3 taskify_backup.db < migration_script.sql
   ```

3. **Apply to production**
   ```bash
   sqlite3 taskify.db < migration_script.sql
   ```

## TypeScript Integration

This schema is designed to work seamlessly with the TypeScript types in `/src/types/`:

- **Entity interfaces** match table structures exactly
- **Enum values** align with CHECK constraints
- **Validation rules** mirror TypeScript validation
- **Database types** provide ORM integration support

## Performance Considerations

### Query Optimization
- Use prepared statements for repeated queries
- Leverage indexes for WHERE clauses and JOINs
- Use views for complex aggregations
- Consider query planning with `EXPLAIN QUERY PLAN`

### Maintenance
- Regular `VACUUM` operations to reclaim space
- `ANALYZE` to update query planner statistics
- Monitor index usage and add/remove as needed

## Backup and Restore

```bash
# Backup
sqlite3 taskify.db ".backup taskify_backup_$(date +%Y%m%d).db"

# Restore
cp taskify_backup_20250526.db taskify.db

# Export to SQL
sqlite3 taskify.db ".dump" > taskify_export.sql

# Import from SQL
sqlite3 new_taskify.db < taskify_export.sql
```

## Security Considerations

- **Password Hashing**: Store only bcrypt hashes, never plain text
- **Input Validation**: Use constraints and application-level validation
- **SQL Injection**: Always use parameterized queries
- **Access Control**: Implement row-level security in application layer

## Support

For questions about the database schema:
1. Check the TypeScript type definitions in `/src/types/`
2. Review the entity-relations diagram in `/context/diagrams/`
3. Examine the sample data for usage patterns
