//
//  RecipesService.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import Foundation

class RecipesService {
    
    let recipeURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    func fetchAllRecipes(with url: URL) async throws -> [Recipe] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipesContainer = try JSONDecoder().decode(RecipesContainer.self, from: data)
            return recipesContainer.recipes
        } catch {
            NSLog("Error fetching recipes from \(recipeURL): \(error)")
            throw error
        }
    }
}
