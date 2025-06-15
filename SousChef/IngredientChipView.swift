import SwiftUI

#if DEBUG
private var isPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
#else
private let isPreview = false
#endif

@available(iOS 26.0, *)
struct IngredientChipView: View {
    let ingredient: RecipeIngredient
    
    @Environment(\.modelContext) private var modelContext
    @State private var generatedImage: Image? = nil
    @State private var isLoading = false
    @State private var didFail = false
    
    var iconName: String {
        switch ingredient.type.lowercased() {
        case "pasta": return "fork.knife"
        case "meat": return "hare"
        case "dairy": return "carrot"
        case "vegetable": return "carrot"
        case "oil": return "drop"
        case "spice": return "leaf"
        case "baking": return "birthday.cake"
        default: return "leaf"
        }
    }
    
    var backgroundColor: Color {
        switch ingredient.type.lowercased() {
        case "meat", "poultry", "fish", "seafood":
            return Color.red.opacity(0.8)
        case "vegetable", "greens":
            return Color.green.opacity(0.7)
        case "dairy":
            return Color.blue.opacity(0.6)
        case "oil", "liquid":
            return Color(hue: 0.13, saturation: 0.55, brightness: 0.93) // olive-like
        case "spice", "baking", "pasta", "grain":
            return Color.yellow.opacity(0.7)
        default:
            return Color.cyan
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if isPreview {
                    Image("default_ingredient_cyan")
                        .resizable()
                        .scaledToFill()
                } else if isLoading {
                    ProgressView()
                        .frame(width: 52, height: 52)
                        .frame(maxWidth: .infinity, maxHeight: 130)
                } else if didFail {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 52, height: 52)
                        .frame(maxWidth: .infinity, maxHeight: 130)
                } else if let generatedImage {
                    generatedImage
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .frame(maxWidth: .infinity, maxHeight: 130)
                }
            }
            
            Color(.systemGray6)
                .frame(height: 60)
                .overlay(
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ingredient.name)
                            .font(.title2).bold()
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                        Text(ingredient.quantity)
                            .font(.body)
                            .italic()
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .truncationMode(.tail)
                    }
                        .padding(.horizontal, 16),
                    alignment: .leading
                )
            
        }
        
        .frame(width: 130)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(12)
        
        .task(id: ingredient.name) {
            guard !isPreview else { return }
            isLoading = true
            didFail = false
            generatedImage = nil
            do {
                let image = try await RecipeImageProvider.shared.fetchImage(for: "Ingredient: \(ingredient.name), Background: \(backgroundColor)")
                generatedImage = image
                isLoading = false
            } catch {
                isLoading = false
                didFail = true
                generatedImage = nil
            }
        }
    }
}

