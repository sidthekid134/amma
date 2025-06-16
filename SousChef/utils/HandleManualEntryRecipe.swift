//
//  HandleManualEntryRecipe.swift
//  SousChef
//
//  Created by Sid Moparthi on 6/15/25.
//

import Foundation
import FoundationModels

@available(iOS 26.0, *)
public actor ManualRecipeUtil {
    /// Generates a complete Recipe object from the provided input string by leveraging a FoundationModels text generation model.
    /// - Parameter input: The input string describing the recipe to generate.
    /// - Returns: A Recipe object parsed from the generated JSON response.
    /// - Throws: An error if text generation fails or the JSON parsing fails.
    ///
    /// Requires iOS 18+/macOS 15+ and the FoundationModels framework.
    @available(iOS 26.0, *)
    public static func generateRecipe(from input: String) async throws -> Recipe {
        let prompt = """
        Write a complete recipe for: \(input). Include title, servings, time, metadata, ingredients, steps, equipment. Respond in JSON with fields: id, title, servings, totalTimeMinutes, activeTimeMinutes, passiveTimeMinutes, metadata {cuisine, dishType, difficultyLevel}, ingredients [{name, quantity, type}], steps [{stepNumber, title, equipmentNeeded, instructions, ingredientsUsed, estimatedTimeMinutes, definitionOfDone}], allEquipmentNeeded.
        """
        
        do {
            let session = LanguageModelSession(model: .default)
            print("prompt: \(prompt)")
            let response = try await session.respond(
                to: prompt,
                generating: RecipeEntityLLM.self
            )
            let generatedRecipe: Recipe = await response.content.toModel()
            print("Generated Recipe")
            return generatedRecipe
            
        } catch {
            throw NSError(domain: "ManualRecipeUtilError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate or parse recipe JSON: \(error.localizedDescription)"])
        }
    }
}
