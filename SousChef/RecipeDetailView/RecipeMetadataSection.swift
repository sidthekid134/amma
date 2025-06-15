// This file modularizes the RecipeMetadataSection view from RecipeDetailView.swift.
import SwiftUI

struct RecipeMetadataSection: View {
    let recipe: Recipe
    let createdAtFormatted: String
    
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
