// Export models
export * from './models/schemas';

// Export storage utilities
export { Storage, Serializer, StorageError, ValidationError, ModelName } from './storage/asyncStorage';
export {
  RecipeRepository,
  RecipeIngredientRepository,
  RecipeStepRepository,
  RecipeMetadataRepository,
  RecipeBookRepository,
  CookSessionRepository
} from './storage/repositories';

// Export migration utilities
export { 
  migrations, 
  CURRENT_SCHEMA_VERSION, 
  migrateToLatest, 
  initializeStorage,
  updateSchema,
  addMigration
} from './storage/migrations';

// Export serialization utilities
export { ModelSerializer } from './utils/serialization';

// Export seed data utilities
export {
  seedDatabase,
  clearSeedData,
  checkSeedDataExists
} from './utils/seedData';

// Main function to initialize the storage system
async function initStorage(): Promise<void> {
  try {
    // Initialize storage with migrations if needed
    await initializeStorage();
    
    // Check for seed data and load if not present
    const hasSeedData = await checkSeedDataExists();
    if (!hasSeedData) {
      await seedDatabase();
    }
    
    console.log('Storage system initialized successfully');
  } catch (error) {
    console.error('Failed to initialize storage system:', error);
    throw error;
  }
}

// Export initialization function
export { initStorage };