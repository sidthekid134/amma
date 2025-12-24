import { z } from 'zod';

// Schema version for migration strategy
export const schemaVersion = z.number().default(1);

// RecipeIngredient schema
export const recipeIngredientSchema = z.object({
  id: z.string().uuid().default(() => crypto.randomUUID()),
  name: z.string().min(1, 'Ingredient name is required'),
  quantity: z.string(),
  type: z.string(),
  createdAt: z.date().default(() => new Date()),
  updatedAt: z.date().default(() => new Date()),
  schemaVersion: schemaVersion,
});

// RecipeStep schema
export const recipeStepSchema = z.object({
  id: z.string().uuid().default(() => crypto.randomUUID()),
  stepNumber: z.number().int().positive(),
  title: z.string().min(1, 'Step title is required'),
  equipmentNeeded: z.array(z.string()),
  instructions: z.string().min(1, 'Instructions are required'),
  ingredientsUsed: z.array(recipeIngredientSchema),
  estimatedTimeMinutes: z.number().int().nonnegative(),
  definitionOfDone: z.string(),
  createdAt: z.date().default(() => new Date()),
  updatedAt: z.date().default(() => new Date()),
  schemaVersion: schemaVersion,
});

// RecipeMetadata schema
export const recipeMetadataSchema = z.object({
  id: z.string().uuid().default(() => crypto.randomUUID()),
  cuisine: z.string(),
  dishType: z.string(),
  difficultyLevel: z.string(),
  createdAt: z.date().default(() => new Date()),
  updatedAt: z.date().default(() => new Date()),
  schemaVersion: schemaVersion,
});

// Recipe schema
export const recipeSchema = z.object({
  id: z.string().uuid().default(() => crypto.randomUUID()),
  title: z.string().min(1, 'Recipe title is required'),
  servings: z.string(),
  totalTimeMinutes: z.number().int().nonnegative(),
  activeTimeMinutes: z.number().int().nonnegative(),
  passiveTimeMinutes: z.number().int().nonnegative(),
  metadata: recipeMetadataSchema,
  ingredients: z.array(recipeIngredientSchema),
  steps: z.array(recipeStepSchema),
  allEquipmentNeeded: z.array(z.string()),
  createdAt: z.date().default(() => new Date()),
  updatedAt: z.date().default(() => new Date()),
  schemaVersion: schemaVersion,
});

// RecipeBook schema
export const recipeBookSchema = z.object({
  id: z.string().uuid().default(() => crypto.randomUUID()),
  title: z.string().min(1, 'Recipe book title is required'),
  recipes: z.array(recipeSchema),
  createdAt: z.date().default(() => new Date()),
  updatedAt: z.date().default(() => new Date()),
  schemaVersion: schemaVersion,
});

// CookSession schema (not in original Swift models, added as per requirements)
export const cookSessionSchema = z.object({
  id: z.string().uuid().default(() => crypto.randomUUID()),
  recipeId: z.string().uuid(),
  startTime: z.date(),
  endTime: z.date().nullable(),
  currentStepIndex: z.number().int().nonnegative(),
  isCompleted: z.boolean().default(false),
  notes: z.string().optional(),
  servingsAdjustment: z.number().positive().default(1),
  createdAt: z.date().default(() => new Date()),
  updatedAt: z.date().default(() => new Date()),
  schemaVersion: schemaVersion,
});

// Export types generated from Zod schemas
export type RecipeIngredient = z.infer<typeof recipeIngredientSchema>;
export type RecipeStep = z.infer<typeof recipeStepSchema>;
export type RecipeMetadata = z.infer<typeof recipeMetadataSchema>;
export type Recipe = z.infer<typeof recipeSchema>;
export type RecipeBook = z.infer<typeof recipeBookSchema>;
export type CookSession = z.infer<typeof cookSessionSchema>;

// Export a mapping of model names to their schemas for the storage layer
export const modelSchemas = {
  RecipeIngredient: recipeIngredientSchema,
  RecipeStep: recipeStepSchema,
  RecipeMetadata: recipeMetadataSchema,
  Recipe: recipeSchema,
  RecipeBook: recipeBookSchema,
  CookSession: cookSessionSchema,
};

// Export a type representing all model types
export type ModelType = 
  | RecipeIngredient
  | RecipeStep
  | RecipeMetadata
  | Recipe
  | RecipeBook
  | CookSession;