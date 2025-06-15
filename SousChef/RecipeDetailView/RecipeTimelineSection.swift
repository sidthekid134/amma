// This file modularizes the RecipeTimelineSection view from RecipeDetailView.swift.
import SwiftUI

struct RecipeTimelineSection: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.accentColor)
                Text("Timeline")
                    .font(.title3.bold())
            }
            DynamicTimelineView(recipe: recipe)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
