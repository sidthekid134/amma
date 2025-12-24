# Type-Safe Local Storage for Recipe Data Models

This project implements type-safe local storage for recipe data models using TypeScript, Zod for schema validation, and AsyncStorage for persistence.

## Features

- **Type-Safe Data Models**: Zod schemas for Recipe, Ingredient, Step, and CookSession models
- **AsyncStorage Integration**: CRUD operations for all models
- **Migration Strategy**: Handles future schema changes gracefully
- **Seed Data**: Sample data for testing and demos
- **JSON Serialization**: Full support for serializing/deserializing complex objects

## Project Structure

```
src/
├── models/
│   └── schemas.ts         # Zod schemas and TypeScript types
├── storage/
│   ├── asyncStorage.ts    # AsyncStorage wrapper with CRUD methods
│   ├── repositories.ts    # Model-specific repositories
│   └── migrations.ts      # Migration system for schema changes
├── utils/
│   ├── serialization.ts   # JSON serialization utilities
│   └── seedData.ts        # Sample data for testing
├── index.ts               # Main exports
└── demo.ts                # Usage examples
```

## Getting Started

1. **Install dependencies**:

```bash
npm install
```

2. **Initialize the storage system**:

```typescript
import { initStorage } from 'sous-chef-app';

// Initialize storage with migrations and seed data
await initStorage();
```

3. **Use repositories to work with data**:

```typescript
import { 
  RecipeRepository, 
  RecipeIngredientRepository 
} from 'sous-chef-app';

// Create repositories
const recipeRepo = new RecipeRepository();
const ingredientRepo = new RecipeIngredientRepository();

// Get all recipes
const recipes = await recipeRepo.getAll();

// Create a new ingredient
const tomato = await ingredientRepo.create({
  name: 'Tomato',
  quantity: '2',
  type: 'Vegetable'
});
```

## Model Schema Examples

### Recipe

```typescript
const recipe = {
  id: '123e4567-e89b-12d3-a456-426614174000',
  title: 'Spaghetti Carbonara',
  servings: '2',
  totalTimeMinutes: 30,
  activeTimeMinutes: 20,
  passiveTimeMinutes: 10,
  metadata: {
    id: '123e4567-e89b-12d3-a456-426614174001',
    cuisine: 'Italian',
    dishType: 'Pasta',
    difficultyLevel: 'Medium',
    createdAt: new Date(),
    updatedAt: new Date(),
    schemaVersion: 1
  },
  ingredients: [...],
  steps: [...],
  allEquipmentNeeded: ['Pot', 'Pan', 'Colander'],
  createdAt: new Date(),
  updatedAt: new Date(),
  schemaVersion: 1
};
```

### CookSession

```typescript
const cookSession = {
  id: '123e4567-e89b-12d3-a456-426614174002',
  recipeId: '123e4567-e89b-12d3-a456-426614174000',
  startTime: new Date(),
  endTime: null,
  currentStepIndex: 0,
  isCompleted: false,
  notes: 'Added extra garlic',
  servingsAdjustment: 1,
  createdAt: new Date(),
  updatedAt: new Date(),
  schemaVersion: 1
};
```

## Migration System

When you need to update your schemas, use the migration system:

```typescript
import { addMigration, updateSchema } from 'sous-chef-app';

// Add a migration from version 1 to 2
addMigration(2, (data) => {
  if (data.modelType === 'Recipe') {
    return {
      ...data,
      isPublic: false  // New field added in version 2
    };
  }
  return data;
});

// Update the schema to version 2
await updateSchema(2);
```

## JSON Serialization

The system handles complex data types like Dates in JSON:

```typescript
import { ModelSerializer, Recipe } from 'sous-chef-app';

// Serialize a recipe to JSON
const json = ModelSerializer.serialize<Recipe>(recipe);

// Deserialize back to a recipe object
const deserializedRecipe = ModelSerializer.deserialize<Recipe>(json, 'Recipe');

// Export to a plain object (for file saving, etc.)
const exportObject = ModelSerializer.toJSON<Recipe>(recipe);
```

## Running the Demo

To see the implementation in action:

```bash
npx ts-node src/demo.ts
```