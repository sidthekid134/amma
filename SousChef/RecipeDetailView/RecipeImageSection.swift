// This file modularizes the RecipeImageSection view from RecipeDetailView.swift.
import SwiftUI
import ImagePlayground
import SwiftData

@available(iOS 26.0, *)
struct RecipeImageSection: View {
    let concept: String

    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = false
    @State private var generatedImage: Image?

    func loadImage() {
        isLoading = true
        Task {
            do {
                if let image = try await RecipeImageProvider.shared.fetchImage(for: concept) {
                    await MainActor.run {
                        generatedImage = image
                        isLoading = false
                    }
                } else {
                    await MainActor.run { isLoading = false }
                }
            } catch {
                await MainActor.run { isLoading = false }
            }
        }
    }

    var body: some View {
        VStack {
            if let generatedImage {
                generatedImage
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding(.horizontal)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    if isLoading {
                        ProgressView()
                    }
                    Text("Tap to generate image")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .onTapGesture { loadImage() }
            }
        }
        .onAppear {
            print("onAppear: \(concept)")
            loadImage()
        }
        
    }
}

