import { Storage } from './asyncStorage';
import { 
  Recipe, 
  RecipeIngredient, 
  RecipeStep, 
  RecipeMetadata,
  RecipeBook,
  CookSession 
} from '../models/schemas';

/**
 * Type for migration functions - takes old data and returns new data
 */
export type MigrationFn = (data: any) => any;

/**
 * Migrations for schema changes
 * Each migration function converts from version N to N+1
 */
export const migrations: Record<number, MigrationFn> = {
  // Version 1 to 2 migration example
  1: (data) => {
    // This is just an example - actual migrations depend on schema changes
    if ('Recipe' in data) {
      // Example: Add a new field to Recipe
      return {
        ...data,
        isPublic: false, // New field added in version 2
      };
    }
    
    // Default case - return data unchanged
    return data;
  },
  
  // Version 2 to 3 migration example
  2: (data) => {
    // Example: Rename a field in CookSession
    if ('CookSession' in data && 'notes' in data) {
      const { notes, ...rest } = data;
      return {
        ...rest,
        sessionNotes: notes, // Renamed field
      };
    }
    
    // Default case - return data unchanged
    return data;
  },
  
  // Additional migrations can be added as needed
};

/**
 * Current highest schema version - update this when adding new migrations
 */
export const CURRENT_SCHEMA_VERSION = 1; // Initial version

/**
 * Function to run migrations to the latest version
 */
export async function migrateToLatest(): Promise<void> {
  const currentVersion = await Storage.getSchemaVersion();
  
  if (currentVersion < CURRENT_SCHEMA_VERSION) {
    console.log(`Migrating data from schema version ${currentVersion} to ${CURRENT_SCHEMA_VERSION}`);
    await Storage.migrate(migrations, CURRENT_SCHEMA_VERSION);
    console.log('Migration complete');
  }
}

/**
 * Initialize the storage system, including migrations if needed
 */
export async function initializeStorage(): Promise<void> {
  // Run migrations if needed
  await migrateToLatest();
}

/**
 * Update schema version and apply migrations when needed
 * Call this when deploying a new app version with schema changes
 */
export async function updateSchema(newVersion: number): Promise<void> {
  const currentVersion = await Storage.getSchemaVersion();
  
  if (newVersion > currentVersion) {
    // Validate that we have all required migrations
    for (let v = currentVersion; v < newVersion; v++) {
      if (!migrations[v]) {
        throw new Error(`Missing migration for version ${v} to ${v + 1}`);
      }
    }
    
    // Apply migrations
    await Storage.migrate(migrations, newVersion);
  }
}

/**
 * Example of how to add a new migration when updating the schema
 * @param schemaVersion The version this migration upgrades to
 * @param migrationFn The migration function
 */
export function registerMigration(schemaVersion: number, migrationFn: MigrationFn): void {
  if (migrations[schemaVersion]) {
    throw new Error(`Migration for version ${schemaVersion} already exists`);
  }
  
  migrations[schemaVersion] = migrationFn;
}

/**
 * Safely handle schema changes by registering a migration function.
 * Example usage:
 * 
 * addMigration(2, (data) => {
 *   if (data.modelType === 'Recipe') {
 *     return {
 *       ...data,
 *       newField: 'default value'
 *     };
 *   }
 *   return data;
 * });
 * 
 * updateSchema(2);
 */
export function addMigration(toVersion: number, migrationFn: MigrationFn): void {
  registerMigration(toVersion - 1, migrationFn);
}