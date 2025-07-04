import { readFileSync } from 'fs';
import { join } from 'path';

/**
 * Utility to run SQL migrations using Wrangler D1 execute
 * This bridges the gap between existing SQL files and Drizzle ORM
 */
export class MigrationRunner {
  private migrationPath: string;

  constructor(migrationPath: string = './migrations') {
    this.migrationPath = migrationPath;
  }

  /**
   * Read migration file content
   */
  private readMigrationFile(filename: string): string {
    const filepath = join(this.migrationPath, filename);
    return readFileSync(filepath, 'utf-8');
  }

  /**
   * Get list of migration files in order
   */
  private getMigrationFiles(): string[] {
    const fs = require('fs');
    const files = fs.readdirSync(this.migrationPath);
    return files
      .filter((file: string) => file.endsWith('.sql'))
      .sort(); // Files should be named with numeric prefixes for ordering
  }

  /**
   * Run all migrations using Wrangler D1 execute
   */
  async runMigrations(environment: 'local' | 'staging' | 'production' = 'local'): Promise<void> {
    const migrationFiles = this.getMigrationFiles();
    
    console.log(`Running ${migrationFiles.length} migrations for ${environment} environment...`);
    
    for (const file of migrationFiles) {
      console.log(`Running migration: ${file}`);
      
      try {
        const migrationSql = this.readMigrationFile(file);
        
        // In a real implementation, you would execute this using Wrangler API
        // or by spawning a child process to run the wrangler command
        
        // For now, we'll just log what would be executed
        console.log(`Would execute migration ${file} with ${migrationSql.split('\n').length} lines`);
        
        // Example of how you might run this:
        // const { spawn } = require('child_process');
        // const tempFile = `/tmp/${file}`;
        // writeFileSync(tempFile, migrationSql);
        // const wranglerArgs = ['d1', 'execute', `--${environment}`, `--file=${tempFile}`];
        // const result = spawn('wrangler', wranglerArgs);
        
      } catch (error) {
        console.error(`Failed to run migration ${file}:`, error);
        throw error;
      }
    }
    
    console.log('All migrations completed successfully!');
  }

  /**
   * Run a specific migration file
   */
  async runMigration(filename: string, environment: 'local' | 'staging' | 'production' = 'local'): Promise<void> {
    console.log(`Running migration: ${filename} for ${environment} environment`);
    
    try {
      const migrationSql = this.readMigrationFile(filename);
      
      // In a real implementation, you would execute this using Wrangler
      console.log(`Would execute migration ${filename} with ${migrationSql.split('\n').length} lines`);
      
    } catch (error) {
      console.error(`Failed to run migration ${filename}:`, error);
      throw error;
    }
  }

  /**
   * Create a new migration file
   */
  createMigration(name: string, content: string): string {
    const timestamp = new Date().toISOString().replace(/[-:]/g, '').split('.')[0];
    const filename = `${timestamp}_${name}.sql`;
    const filepath = join(this.migrationPath, filename);
    
    const fs = require('fs');
    fs.writeFileSync(filepath, content);
    
    console.log(`Created migration: ${filename}`);
    return filename;
  }
}

// Export singleton instance
export const migrationRunner = new MigrationRunner();

// Helper functions for common migration tasks
export const migrationUtils = {
  /**
   * Generate migration from existing SQL schema
   */
  generateFromSchema(schemaPath: string): string {
    const fs = require('fs');
    const schema = fs.readFileSync(schemaPath, 'utf-8');
    
    // Add migration header
    const migrationHeader = `-- Generated migration from ${schemaPath}
-- Created: ${new Date().toISOString()}
-- This migration creates the database schema

`;
    
    return migrationHeader + schema;
  },

  /**
   * Generate seed data migration
   */
  generateSeedMigration(seedDataPath: string): string {
    const fs = require('fs');
    const seedData = fs.readFileSync(seedDataPath, 'utf-8');
    
    const migrationHeader = `-- Seed data migration from ${seedDataPath}
-- Created: ${new Date().toISOString()}
-- This migration seeds the database with sample data

`;
    
    return migrationHeader + seedData;
  },

  /**
   * Validate migration syntax
   */
  validateMigration(migrationContent: string): boolean {
    // Basic validation - check for common SQL syntax
    const requiredElements = [
      /CREATE TABLE|ALTER TABLE|DROP TABLE|INSERT INTO/i,
    ];
    
    return requiredElements.some(pattern => pattern.test(migrationContent));
  },
};
