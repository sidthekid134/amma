import { Storage, ModelName } from './asyncStorage';
import { 
  Recipe, 
  RecipeIngredient, 
  RecipeStep, 
  RecipeMetadata,
  RecipeBook,
  CookSession 
} from '../models/schemas';

/**
 * Base repository class for common CRUD operations
 */
abstract class BaseRepository<T> {
  protected modelName: ModelName;

  constructor(modelName: ModelName) {
    this.modelName = modelName;
  }

  /**
   * Create a new entity
   */
  async create(data: Omit<T, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'>): Promise<T> {
    return Storage.create<T>(this.modelName, data);
  }

  /**
   * Get an entity by ID
   */
  async getById(id: string): Promise<T | null> {
    return Storage.get<T>(this.modelName, id);
  }

  /**
   * Get all entities
   */
  async getAll(): Promise<T[]> {
    return Storage.getAll<T>(this.modelName);
  }

  /**
   * Update an entity
   */
  async update(id: string, data: Partial<Omit<T, 'id' | 'createdAt' | 'schemaVersion'>>): Promise<T | null> {
    return Storage.update<T>(this.modelName, id, data);
  }

  /**
   * Delete an entity
   */
  async delete(id: string): Promise<boolean> {
    return Storage.delete(this.modelName, id);
  }

  /**
   * Delete all entities
   */
  async deleteAll(): Promise<void> {
    return Storage.deleteAll(this.modelName);
  }

  /**
   * Find entities matching a predicate
   */
  async find(predicate: (item: T) => boolean): Promise<T[]> {
    return Storage.find<T>(this.modelName, predicate);
  }
}

/**
 * Repository for Recipe model
 */
export class RecipeRepository extends BaseRepository<Recipe> {
  constructor() {
    super('Recipe');
  }

  /**
   * Find recipes by title (case insensitive)
   */
  async findByTitle(title: string): Promise<Recipe[]> {
    return this.find(recipe => 
      recipe.title.toLowerCase().includes(title.toLowerCase())
    );
  }

  /**
   * Find recipes by cuisine type
   */
  async findByCuisine(cuisine: string): Promise<Recipe[]> {
    return this.find(recipe => 
      recipe.metadata.cuisine.toLowerCase() === cuisine.toLowerCase()
    );
  }

  /**
   * Find recipes by difficulty level
   */
  async findByDifficulty(difficultyLevel: string): Promise<Recipe[]> {
    return this.find(recipe => 
      recipe.metadata.difficultyLevel.toLowerCase() === difficultyLevel.toLowerCase()
    );
  }

  /**
   * Find recipes by ingredient (partial name match)
   */
  async findByIngredient(ingredientName: string): Promise<Recipe[]> {
    return this.find(recipe => 
      recipe.ingredients.some(ingredient => 
        ingredient.name.toLowerCase().includes(ingredientName.toLowerCase())
      )
    );
  }

  /**
   * Find recipes that can be made within specified time (in minutes)
   */
  async findByMaxTotalTime(maxMinutes: number): Promise<Recipe[]> {
    return this.find(recipe => recipe.totalTimeMinutes <= maxMinutes);
  }
}

/**
 * Repository for RecipeIngredient model
 */
export class RecipeIngredientRepository extends BaseRepository<RecipeIngredient> {
  constructor() {
    super('RecipeIngredient');
  }

  /**
   * Find ingredients by type
   */
  async findByType(type: string): Promise<RecipeIngredient[]> {
    return this.find(ingredient => 
      ingredient.type.toLowerCase() === type.toLowerCase()
    );
  }
}

/**
 * Repository for RecipeStep model
 */
export class RecipeStepRepository extends BaseRepository<RecipeStep> {
  constructor() {
    super('RecipeStep');
  }

  /**
   * Find steps that use a specific piece of equipment
   */
  async findByEquipment(equipment: string): Promise<RecipeStep[]> {
    return this.find(step => 
      step.equipmentNeeded.some(eq => 
        eq.toLowerCase().includes(equipment.toLowerCase())
      )
    );
  }
}

/**
 * Repository for RecipeMetadata model
 */
export class RecipeMetadataRepository extends BaseRepository<RecipeMetadata> {
  constructor() {
    super('RecipeMetadata');
  }
}

/**
 * Repository for RecipeBook model
 */
export class RecipeBookRepository extends BaseRepository<RecipeBook> {
  constructor() {
    super('RecipeBook');
  }

  /**
   * Find recipe books by title (case insensitive)
   */
  async findByTitle(title: string): Promise<RecipeBook[]> {
    return this.find(book => 
      book.title.toLowerCase().includes(title.toLowerCase())
    );
  }

  /**
   * Add a recipe to a recipe book
   */
  async addRecipe(bookId: string, recipe: Recipe): Promise<RecipeBook | null> {
    const book = await this.getById(bookId);
    if (!book) return null;

    const updatedBook = {
      ...book,
      recipes: [...book.recipes, recipe]
    };

    return this.update(bookId, updatedBook);
  }

  /**
   * Remove a recipe from a recipe book
   */
  async removeRecipe(bookId: string, recipeId: string): Promise<RecipeBook | null> {
    const book = await this.getById(bookId);
    if (!book) return null;

    const updatedBook = {
      ...book,
      recipes: book.recipes.filter(recipe => recipe.id !== recipeId)
    };

    return this.update(bookId, updatedBook);
  }
}

/**
 * Repository for CookSession model
 */
export class CookSessionRepository extends BaseRepository<CookSession> {
  constructor() {
    super('CookSession');
  }

  /**
   * Find active (not completed) cooking sessions
   */
  async findActiveSessions(): Promise<CookSession[]> {
    return this.find(session => !session.isCompleted);
  }

  /**
   * Find cooking sessions for a specific recipe
   */
  async findByRecipeId(recipeId: string): Promise<CookSession[]> {
    return this.find(session => session.recipeId === recipeId);
  }

  /**
   * Complete a cooking session
   */
  async completeSession(sessionId: string): Promise<CookSession | null> {
    return this.update(sessionId, {
      isCompleted: true,
      endTime: new Date()
    });
  }

  /**
   * Update the current step in a session
   */
  async updateCurrentStep(
    sessionId: string, 
    stepIndex: number
  ): Promise<CookSession | null> {
    return this.update(sessionId, { currentStepIndex: stepIndex });
  }

  /**
   * Add notes to a cooking session
   */
  async addNotes(sessionId: string, notes: string): Promise<CookSession | null> {
    const session = await this.getById(sessionId);
    if (!session) return null;

    const updatedNotes = session.notes 
      ? `${session.notes}\n\n${notes}`
      : notes;

    return this.update(sessionId, { notes: updatedNotes });
  }
}