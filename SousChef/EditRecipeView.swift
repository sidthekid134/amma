import SwiftUI
import SwiftData

struct EditRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let recipe: Recipe
    
    @State private var title: String
    @State private var servings: String
    @State private var totalTimeMinutes: String
    @State private var activeTimeMinutes: String
    @State private var passiveTimeMinutes: String
    @State private var cuisine: String
    @State private var dishType: String
    @State private var difficultyLevel: String
    
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
    init(recipe: Recipe) {
        self.recipe = recipe
        _title = State(initialValue: recipe.title)
        _servings = State(initialValue: recipe.servings)
        _totalTimeMinutes = State(initialValue: String(recipe.totalTimeMinutes))
        _activeTimeMinutes = State(initialValue: String(recipe.activeTimeMinutes))
        _passiveTimeMinutes = State(initialValue: String(recipe.passiveTimeMinutes))
        _cuisine = State(initialValue: recipe.metadata.cuisine)
        _dishType = State(initialValue: recipe.metadata.dishType)
        _difficultyLevel = State(initialValue: recipe.metadata.difficultyLevel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Recipe Title", text: $title)
                    TextField("Servings", text: $servings)
                }
                
                Section(header: Text("Timing (minutes)")) {
                    TextField("Total Time", text: $totalTimeMinutes)
                        .keyboardType(.numberPad)
                    TextField("Active Time", text: $activeTimeMinutes)
                        .keyboardType(.numberPad)
                    TextField("Passive Time", text: $passiveTimeMinutes)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Metadata")) {
                    TextField("Cuisine", text: $cuisine)
                    TextField("Dish Type", text: $dishType)
                    Picker("Difficulty Level", selection: $difficultyLevel) {
                        Text("Easy").tag("Easy")
                        Text("Medium").tag("Medium")
                        Text("Hard").tag("Hard")
                        Text("Very Hard").tag("Very Hard")
                    }
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(recipe.ingredients, id: \.name) { ingredient in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ingredient.name)
                                .font(.headline)
                            Text("\(ingredient.quantity) • \(ingredient.type)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Steps")) {
                    ForEach(recipe.steps.sorted(by: { $0.stepNumber < $1.stepNumber }), id: \.stepNumber) { step in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Step \(step.stepNumber): \(step.title)")
                                .font(.headline)
                            Text(step.instructions)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .alert("Validation Error", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }
    
    private func saveChanges() {
        guard !title.isEmpty else {
            validationMessage = "Recipe title cannot be empty"
            showValidationAlert = true
            return
        }
        
        guard let totalTime = Int(totalTimeMinutes),
              let activeTime = Int(activeTimeMinutes),
              let passiveTime = Int(passiveTimeMinutes) else {
            validationMessage = "Time values must be valid numbers"
            showValidationAlert = true
            return
        }
        
        recipe.title = title
        recipe.servings = servings
        recipe.totalTimeMinutes = totalTime
        recipe.activeTimeMinutes = activeTime
        recipe.passiveTimeMinutes = passiveTime
        recipe.metadata.cuisine = cuisine
        recipe.metadata.dishType = dishType
        recipe.metadata.difficultyLevel = difficultyLevel
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            validationMessage = "Failed to save changes: \(error.localizedDescription)"
            showValidationAlert = true
        }
    }
}

#Preview {
    let mockRecipe = Recipe.mockRecipes.first!
    return NavigationStack {
        EditRecipeView(recipe: mockRecipe)
    }
    .modelContainer(ModelContainer.appContainer(inMemory: true))
}
