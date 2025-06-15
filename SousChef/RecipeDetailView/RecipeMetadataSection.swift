// This file modularizes the RecipeMetadataSection view from RecipeDetailView.swift.
import SwiftUI

struct RecipeMetadataSection<Trailing: View>: View {
    let recipe: Recipe
    let createdAtFormatted: String
//    @ViewBuilder let trailing: () -> Trailing
    
    init(recipe: Recipe, createdAtFormatted: String, @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }) {
        self.recipe = recipe
        self.createdAtFormatted = createdAtFormatted
//        self.trailing = trailing
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "book.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.accentColor)
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                    Text("Created at \(createdAtFormatted)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: {
                    // TODO: Handle cook now action
                }) {
                    Text("Cook Now")
                        .font(.headline)
                        .frame(
                            minWidth: 120,
                            maxWidth: 200,
                            minHeight: 44,
                            maxHeight: 100
                        )
                        .foregroundColor(.white)
                        
                        .buttonStyle(.plain)
                }
                .frame(maxHeight: 100, alignment: .center)
                .padding(.vertical, 6)
                .padding(.trailing, 2)
                .glassEffect(.regular.tint(Color(red: 0.0, green: 0.4, blue: 0.0)).interactive())
            
                .controlSize(.large)

            }
            Divider()
            HStack(spacing: 12) {
                Label("\(recipe.servings)", systemImage: "person.2")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Divider()
            HStack(spacing: 12) {
                Label(recipe.metadata.cuisine, systemImage: "globe")
                Label(recipe.metadata.dishType, systemImage: "fork.knife")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

