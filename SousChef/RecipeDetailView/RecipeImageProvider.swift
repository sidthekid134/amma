import Foundation
import UIKit
import SwiftUI
import SwiftData
import ImagePlayground

@available(iOS 18.0, *)
enum RecipeImageProviderError: Error {
    case notConfigured
}

@available(iOS 18.0, *)
actor RecipeImageProvider {
    static let shared = RecipeImageProvider()
    private var modelContext: ModelContext?
    private var tasks: [String: Task<Image?, Error>] = [:]
    
    /// Call from an async context before using fetchImage
    func configure(with context: ModelContext) {
        self.modelContext = context
    }
    
    /// Fetches or generates an image for a concept, with caching and parallel safety
    func fetchImage(for concept: String) async throws -> Image? {
        guard let context = modelContext else {
            throw RecipeImageProviderError.notConfigured
        }
        
        // 1️⃣ Check cache
        let descriptor = FetchDescriptor<SavedImageRecord>(predicate: #Predicate { $0.key == concept })
        if let record = try? context.fetch(descriptor).first {
            return await convert(data: record.imageData)
        }
        
        // 2️⃣ Return existing or start new generation task
        if let existing = tasks[concept] {
            return try await existing.value
        }
        
        let task = Task<Image?, Error>(priority: .userInitiated) {
            let creator = try await ImageCreator()
            let images = try await creator.images(
                for: [.text(concept)],
                style: .illustration,
                limit: 1
            )
            guard let cgImage = try await images.first(where: { _ in true })?.cgImage else {
                return nil
            }
            
            // Convert CGImage to UIImage and PNG data on MainActor
            let uiImage = await MainActor.run(resultType: UIImage.self) { UIImage(cgImage: cgImage) }
            let imageData = await MainActor.run(resultType: Data?.self) { uiImage.pngData() }
            
            // Cache if data exists
            if let data = imageData {
                let record = SavedImageRecord(key: concept, imageData: data)
                await MainActor.run(resultType: Void.self) {
                    context.insert(record)
                    try? context.save()
                }
            }
            
            // Return SwiftUI Image on MainActor
            return await MainActor.run(resultType: Image.self) { Image(decorative: cgImage, scale: 1.0) }
        }
        
        tasks[concept] = task
        defer { tasks[concept] = nil }
        return try await task.value
    }
    
    /// Convert Data to SwiftUI Image safely
    private func convert(data: Data) async -> Image? {
        await MainActor.run(resultType: Image?.self) {
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        }
    }
}
