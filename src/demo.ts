import {
  initStorage,
  RecipeRepository,
  RecipeIngredientRepository,
  RecipeStepRepository,
  RecipeMetadataRepository,
  RecipeBookRepository,
  CookSessionRepository,
  ModelSerializer,
  Recipe,
  CookSession
} from './index';

/**
 * Demo for the type-safe storage implementation
 */
async function runDemo(): Promise<void> {
  try {
    console.log('Initializing storage system...');
    await initStorage();
    
    // Create repository instances
    const recipeRepo = new RecipeRepository();
    const ingredientRepo = new RecipeIngredientRepository();
    const stepRepo = new RecipeStepRepository();
    const metadataRepo = new RecipeMetadataRepository();
    const recipeBookRepo = new RecipeBookRepository();
    const cookSessionRepo = new CookSessionRepository();
    
    // Demo 1: Fetch recipes and display
    console.log('\n--- Demo 1: Fetch Recipes ---');
    const recipes = await recipeRepo.getAll();
    console.log(`Found ${recipes.length} recipes:`);
    recipes.forEach(recipe => {
      console.log(`- ${recipe.title} (${recipe.metadata.cuisine} - ${recipe.metadata.difficultyLevel})`);
      console.log(`  ${recipe.ingredients.length} ingredients, ${recipe.steps.length} steps`);
    });
    
    // Demo 2: Create a new recipe
    console.log('\n--- Demo 2: Create a New Recipe ---');
    // First, create metadata
    const newMetadata = await metadataRepo.create({
      cuisine: 'Mexican',
      dishType: 'Main',
      difficultyLevel: 'Medium'
    });
    
    // Create ingredients
    const tortillas = await ingredientRepo.create({
      name: 'Corn Tortillas',
      quantity: '8',
      type: 'Grain'
    });
    
    const chicken = await ingredientRepo.create({
      name: 'Chicken Breast',
      quantity: '400g',
      type: 'Meat'
    });
    
    const salsa = await ingredientRepo.create({
      name: 'Salsa',
      quantity: '200g',
      type: 'Sauce'
    });
    
    // Create steps
    const step1 = await stepRepo.create({
      stepNumber: 1,
      title: 'Cook Chicken',
      equipmentNeeded: ['Pan', 'Knife'],
      instructions: 'Season and cook chicken until done.',
      ingredientsUsed: [chicken],
      estimatedTimeMinutes: 15,
      definitionOfDone: 'Chicken is fully cooked and tender.'
    });
    
    const step2 = await stepRepo.create({
      stepNumber: 2,
      title: 'Assemble Tacos',
      equipmentNeeded: ['Plate'],
      instructions: 'Place chicken on tortillas and top with salsa.',
      ingredientsUsed: [tortillas, chicken, salsa],
      estimatedTimeMinutes: 5,
      definitionOfDone: 'Tacos assembled and ready to eat.'
    });
    
    // Create recipe
    const tacos = await recipeRepo.create({
      title: 'Simple Chicken Tacos',
      servings: '4',
      totalTimeMinutes: 25,
      activeTimeMinutes: 20,
      passiveTimeMinutes: 5,
      metadata: newMetadata,
      ingredients: [tortillas, chicken, salsa],
      steps: [step1, step2],
      allEquipmentNeeded: ['Pan', 'Knife', 'Plate']
    });
    
    console.log(`Created new recipe: ${tacos.title}`);
    
    // Demo 3: Create a cooking session
    console.log('\n--- Demo 3: Create a Cooking Session ---');
    const session = await cookSessionRepo.create({
      recipeId: tacos.id,
      startTime: new Date(),
      endTime: null,
      currentStepIndex: 0,
      isCompleted: false,
      servingsAdjustment: 2,
      notes: 'Adding extra spice to the chicken.'
    });
    
    console.log(`Started cooking session for ${tacos.title}`);
    
    // Demo 4: Update the cooking session
    console.log('\n--- Demo 4: Update Cooking Session ---');
    const updatedSession = await cookSessionRepo.updateCurrentStep(session.id, 1);
    if (updatedSession) {
      console.log(`Updated session - now on step ${updatedSession.currentStepIndex + 1}`);
    }
    
    // Demo 5: JSON Serialization and Deserialization
    console.log('\n--- Demo 5: JSON Serialization/Deserialization ---');
    const recipeJson = ModelSerializer.serialize<Recipe>(tacos);
    console.log('Serialized recipe to JSON');
    
    const deserializedRecipe = ModelSerializer.deserialize<Recipe>(recipeJson, 'Recipe');
    console.log(`Deserialized recipe: ${deserializedRecipe.title}`);
    console.log('Recipe successfully round-tripped through JSON');
    
    // Demo 6: Export a recipe to a file (simulated)
    console.log('\n--- Demo 6: Export to JSON File ---');
    const exportObject = ModelSerializer.toJSON<Recipe>(tacos);
    console.log('Recipe exported to JSON object format suitable for file storage');
    
    // Demo 7: Find recipes by criteria
    console.log('\n--- Demo 7: Find Recipes by Criteria ---');
    const mexicanRecipes = await recipeRepo.findByCuisine('Mexican');
    console.log(`Found ${mexicanRecipes.length} Mexican recipes`);
    
    // Demo 8: Complete the cooking session
    console.log('\n--- Demo 8: Complete Cooking Session ---');
    const completedSession = await cookSessionRepo.completeSession(session.id);
    if (completedSession) {
      console.log(`Completed cooking session for ${tacos.title}`);
      console.log(`Session duration: ${Math.round((completedSession.endTime!.getTime() - completedSession.startTime.getTime()) / 1000)} seconds`);
    }
    
    console.log('\nDemo completed successfully!');
    
  } catch (error) {
    console.error('Error running demo:', error);
  }
}

// Run the demo if this file is executed directly
if (require.main === module) {
  runDemo();
}

export { runDemo };