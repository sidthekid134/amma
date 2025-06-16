import SwiftUI
import FoundationModels
import SwiftData
import os

private let formCardBackground = Color(.secondarySystemGroupedBackground)

private enum RecipeEntryMode: String, CaseIterable, Identifiable {
    case manual = "Manual"
    case url = "URL"
    case comingSoon = "Coming Soon"
    var id: String { rawValue }
}

struct AddRecipeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMode: RecipeEntryMode = .manual
    @State private var manualText: String = ""
    @State private var urlText: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    private var modeColor: Color {
        switch selectedMode {
        case .manual: return .cyan
        case .url: return .green
        case .comingSoon: return .gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Add a New Recipe")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 2)
                .accessibilityAddTraits(.isHeader)
            
            // Removed shared description above the Picker
            
            // Picker section
            Picker("Add Recipe Method", selection: $selectedMode) {
                ForEach(RecipeEntryMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .tint(modeColor)
            .padding(.top)

            Group {
                switch selectedMode {
                case .manual:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type your recipe:")
                            .font(.headline)
                            .foregroundColor(modeColor)
                        Text("Type your recipe below. Format it however you like!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 2)
                        TextEditor(text: $manualText)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(.systemBackground).opacity(0.85))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(modeColor.opacity(0.7))
                            )
                            .padding(.vertical, 4)
                    }
                    .padding(.horizontal)
                case .url:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Paste recipe URL:")
                            .font(.headline)
                            .foregroundColor(modeColor)
                        Text("Paste a recipe link from your favorite website.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 2)
                        TextField("https://example.com/recipe", text: $urlText)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(10)
                            .background(Color(.systemBackground).opacity(0.85))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(modeColor.opacity(0.7))
                            )
                            .padding(.vertical, 4)
                    }
                    .padding(.horizontal)
                case .comingSoon:
                    VStack(alignment: .center) {
                        Spacer().frame(height: 36)
                        HStack { Spacer() }
                        Text("A new way to add recipes is coming soon!")
                            .font(.headline)
                            .foregroundColor(modeColor)
                        Text("We’re working on more ways to add recipes. Stay tuned!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        HStack { Spacer() }
                        Spacer().frame(height: 36)
                    }
                    .padding(.horizontal)
                }
            }
            .animation(.default, value: selectedMode)

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            }

            Spacer()

            Button(action: {
                Task {
                    await handleSubmit()
                }
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(modeColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .padding()
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleSubmit() async {
        switch selectedMode {
        case .manual:
            guard #available(iOS 26.0, *) else {
                errorMessage = "Manual recipe generation requires iOS 26.0+."
                return
            }
            isLoading = true
            errorMessage = nil
            print("here")
            do {
                let newRecipe = try await ManualRecipeUtil.generateRecipe(
                    from: manualText
                )
                // Deep copy mock recipe fields into a brand new instance for SwiftData persistence
//                let mock = Recipe.mockRecipes.first!
//                let newRecipe = Recipe(
//                    id: UUID().uuidString,
//                    title: mock.title,
//                    servings: mock.servings,
//                    totalTimeMinutes: mock.totalTimeMinutes,
//                    activeTimeMinutes: mock.activeTimeMinutes,
//                    passiveTimeMinutes: mock.passiveTimeMinutes,
//                    metadata: RecipeMetadata(
//                        cuisine: mock.metadata.cuisine,
//                        dishType: mock.metadata.dishType,
//                        difficultyLevel: mock.metadata.difficultyLevel
//                    ),
//                    ingredients: mock.ingredients.map { RecipeIngredient(name: $0.name, quantity: $0.quantity, type: $0.type) },
//                    steps: mock.steps.map { step in
//                        RecipeStep(
//                            stepNumber: step.stepNumber,
//                            title: step.title,
//                            equipmentNeeded: step.equipmentNeeded,
//                            instructions: step.instructions,
//                            ingredientsUsed: step.ingredientsUsed.map {
//                                RecipeIngredient(name: $0.name, quantity: $0.quantity, type: $0.type)
//                            },
//                            estimatedTimeMinutes: step.estimatedTimeMinutes,
//                            definitionOfDone: step.definitionOfDone
//                        )
//                    },
//                    allEquipmentNeeded: mock.allEquipmentNeeded,
//                    createdAt: Date()
//                )
                print("Generated recipe: \(newRecipe)")
                // Insert the new recipe directly into the model context on the main actor
                await MainActor.run {
                    print("Saving")
                    modelContext.insert(newRecipe)
                    try? modelContext.save()
                    dismiss()
                }
            }
            catch {
                errorMessage = "An error occurred: \(error.localizedDescription)"
                print("Error in manual recipe generation: \(error)")
            }
            isLoading = false
        case .url:
            print("Submitting recipe URL: \(urlText)")
        case .comingSoon:
            print("Coming soon selected. No action.")
        }
    }
}


#if DEBUG
#Preview {
    NavigationStack {
        AddRecipeView()
    }
    .modelContainer(ModelContainer.appContainer(inMemory: false))
}
#endif

