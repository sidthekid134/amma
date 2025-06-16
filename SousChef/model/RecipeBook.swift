import Foundation
import SwiftData

@Model
public final class RecipeBook {
    public var id: String
    public var title: String
    public var recipes: [Recipe]
    public var createdAt: Date

    public init(id: String = UUID().uuidString, title: String, recipes: [Recipe] = [], createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.recipes = recipes
        self.createdAt = createdAt
    }
}
