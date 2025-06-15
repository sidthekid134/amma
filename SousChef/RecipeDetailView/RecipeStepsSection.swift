// Modularizing RecipeStepsSection from RecipeDetailView.swift
import SwiftUI

struct RecipeStepsSection: View {
    let steps: [RecipeStep]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "list.number")
                    .foregroundColor(.accentColor)
                Text("Steps")
                    .font(.title3.bold())
            }
            ForEach(steps.indices, id: \.self) { index in
                let step = steps[index]
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.13))
                                .frame(width: 28, height: 28)
                            Text("\(index + 1)")
                                .font(.subheadline.bold())
                                .foregroundColor(.accentColor)
                        }
                        Text(step.title)
                            .font(.headline)
                    }
                    Text(step.instructions)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 38)
                    if index != steps.count - 1 {
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
