import SwiftUI

private var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

@available(iOS 26.0, *)
struct EquipmentChipView: View {
    let equipment: String

    @Environment(\.modelContext) private var modelContext
    @State private var generatedImage: Image? = nil
    @State private var isLoading = false
    @State private var didFail = false

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
                    Image(systemName: "wrench.and.screwdriver")
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
                        Text(equipment)
                            .font(.title2).bold()
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
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
        .task(id: equipment) {
            guard !isPreview else { return }
            isLoading = true
            didFail = false
            generatedImage = nil
            do {
                let image = try await RecipeImageProvider.shared.fetchImage(for: "Equipment: \(equipment)")
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
