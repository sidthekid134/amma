import { 
  RecipeIngredient,
  RecipeStep,
  RecipeMetadata,
  Recipe,
  RecipeBook,
  CookSession
} from '../models/schemas';

import {
  RecipeRepository,
  RecipeIngredientRepository,
  RecipeStepRepository,
  RecipeMetadataRepository,
  RecipeBookRepository,
  CookSessionRepository
} from '../storage/repositories';
import { Storage } from '../storage/asyncStorage';

// Repositories
const recipeRepo = new RecipeRepository();
const ingredientRepo = new RecipeIngredientRepository();
const stepRepo = new RecipeStepRepository();
const metadataRepo = new RecipeMetadataRepository();
const recipeBookRepo = new RecipeBookRepository();
const cookSessionRepo = new CookSessionRepository();

/**
 * Sample recipe ingredients
 */
export const sampleRecipeIngredients: Omit<RecipeIngredient, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'>[] = [
  {
    name: 'Spaghetti',
    quantity: '200g',
    type: 'Pasta',
  },
  {
    name: 'Eggs',
    quantity: '2',
    type: 'Dairy',
  },
  {
    name: 'Pancetta',
    quantity: '100g',
    type: 'Meat',
  },
  {
    name: 'Parmesan Cheese',
    quantity: '50g',
    type: 'Dairy',
  },
  {
    name: 'Black Pepper',
    quantity: 'to taste',
    type: 'Spice',
  },
  {
    name: 'Flour',
    quantity: '200g',
    type: 'Baking',
  },
  {
    name: 'Milk',
    quantity: '300ml',
    type: 'Dairy',
  },
  {
    name: 'Sugar',
    quantity: '2 tbsp',
    type: 'Baking',
  },
  {
    name: 'Butter',
    quantity: 'for frying',
    type: 'Dairy',
  },
];

/**
 * Sample recipe steps
 */
export const createSampleRecipeSteps = (ingredients: RecipeIngredient[]): Omit<RecipeStep, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'>[] => [
  {
    stepNumber: 1,
    title: 'Boil Pasta',
    equipmentNeeded: ['Pot', 'Strainer'],
    instructions: 'Cook spaghetti in salted boiling water until al dente.',
    ingredientsUsed: [ingredients[0]], // Spaghetti
    estimatedTimeMinutes: 10,
    definitionOfDone: 'Pasta is al dente.',
  },
  {
    stepNumber: 2,
    title: 'Prepare Sauce',
    equipmentNeeded: ['Bowl', 'Pan'],
    instructions: 'Mix eggs and cheese. Fry pancetta until crisp.',
    ingredientsUsed: [
      ingredients[1], // Eggs
      ingredients[3], // Parmesan
      ingredients[2], // Pancetta
    ],
    estimatedTimeMinutes: 10,
    definitionOfDone: 'Sauce is creamy, pancetta is crisp.',
  },
  {
    stepNumber: 1,
    title: 'Mix Ingredients',
    equipmentNeeded: ['Bowl', 'Whisk'],
    instructions: 'Mix flour, sugar, eggs, and milk to form batter.',
    ingredientsUsed: [
      ingredients[5], // Flour
      ingredients[6], // Milk
      ingredients[1], // Eggs
      ingredients[7], // Sugar
    ],
    estimatedTimeMinutes: 5,
    definitionOfDone: 'Batter is smooth.',
  },
  {
    stepNumber: 2,
    title: 'Cook Pancakes',
    equipmentNeeded: ['Frying Pan', 'Spatula'],
    instructions: 'Fry pancakes in butter until golden on both sides.',
    ingredientsUsed: [
      ingredients[8], // Butter
    ],
    estimatedTimeMinutes: 10,
    definitionOfDone: 'Pancakes are golden and cooked through.',
  },
];

/**
 * Sample recipe metadata
 */
export const sampleRecipeMetadata: Omit<RecipeMetadata, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'>[] = [
  {
    cuisine: 'Italian',
    dishType: 'Pasta',
    difficultyLevel: 'Medium',
  },
  {
    cuisine: 'American',
    dishType: 'Breakfast',
    difficultyLevel: 'Easy',
  },
];

/**
 * Create sample recipes
 */
export const createSampleRecipes = (
  ingredients: RecipeIngredient[],
  steps: RecipeStep[],
  metadata: RecipeMetadata[]
): Omit<Recipe, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'>[] => [
  {
    title: 'Carbonara',
    servings: '2',
    totalTimeMinutes: 30,
    activeTimeMinutes: 15,
    passiveTimeMinutes: 10,
    metadata: metadata[0],
    ingredients: ingredients.slice(0, 5), // First 5 ingredients
    steps: steps.slice(0, 2), // First 2 steps
    allEquipmentNeeded: ['Pot', 'Strainer', 'Bowl', 'Pan'],
  },
  {
    title: 'Classic Pancakes',
    servings: '4',
    totalTimeMinutes: 20,
    activeTimeMinutes: 15,
    passiveTimeMinutes: 5,
    metadata: metadata[1],
    ingredients: ingredients.slice(5), // Last 4 ingredients
    steps: steps.slice(2), // Last 2 steps
    allEquipmentNeeded: ['Bowl', 'Whisk', 'Frying Pan', 'Spatula'],
  },
];

/**
 * Create a sample recipe book
 */
export const createSampleRecipeBook = (recipes: Recipe[]): Omit<RecipeBook, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'> => ({
  title: 'My Favorite Recipes',
  recipes,
});

/**
 * Create a sample cook session
 */
export const createSampleCookSession = (recipeId: string): Omit<CookSession, 'id' | 'createdAt' | 'updatedAt' | 'schemaVersion'> => ({
  recipeId,
  startTime: new Date(),
  endTime: null,
  currentStepIndex: 0,
  isCompleted: false,
  notes: 'Added more garlic than the recipe called for.',
  servingsAdjustment: 2,
});

/**
 * Load seed data into storage
 */
export async function seedDatabase(): Promise<void> {
  console.log('Seeding database with sample data...');
  
  try {
    // Clear existing data
    await Storage.clearAll();
    
    // Create ingredients
    const ingredients: RecipeIngredient[] = [];
    for (const ingredientData of sampleRecipeIngredients) {
      const ingredient = await ingredientRepo.create(ingredientData);
      ingredients.push(ingredient);
    }
    
    // Create steps with references to ingredients
    const stepDataList = createSampleRecipeSteps(ingredients);
    const steps: RecipeStep[] = [];
    for (const stepData of stepDataList) {
      const step = await stepRepo.create(stepData);
      steps.push(step);
    }
    
    // Create metadata
    const metadata: RecipeMetadata[] = [];
    for (const metadataData of sampleRecipeMetadata) {
      const meta = await metadataRepo.create(metadataData);
      metadata.push(meta);
    }
    
    // Create recipes with references
    const recipeDataList = createSampleRecipes(ingredients, steps, metadata);
    const recipes: Recipe[] = [];
    for (const recipeData of recipeDataList) {
      const recipe = await recipeRepo.create(recipeData);
      recipes.push(recipe);
    }
    
    // Create recipe book
    const recipeBookData = createSampleRecipeBook(recipes);
    const recipeBook = await recipeBookRepo.create(recipeBookData);
    
    // Create cook session for first recipe
    if (recipes.length > 0) {
      const cookSessionData = createSampleCookSession(recipes[0].id);
      await cookSessionRepo.create(cookSessionData);
    }
    
    console.log('Database seeded successfully');
  } catch (error) {
    console.error('Error seeding database:', error);
    throw error;
  }
}

/**
 * Clear all seed data from storage
 */
export async function clearSeedData(): Promise<void> {
  try {
    await Storage.clearAll();
    console.log('All seed data cleared');
  } catch (error) {
    console.error('Error clearing seed data:', error);
    throw error;
  }
}

/**
 * Check if seed data exists
 */
export async function checkSeedDataExists(): Promise<boolean> {
  try {
    const recipes = await recipeRepo.getAll();
    return recipes.length > 0;
  } catch (error) {
    console.error('Error checking for seed data:', error);
    return false;
  }
}