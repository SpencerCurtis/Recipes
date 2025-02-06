//
//  RecipesService.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import Foundation

class RecipesService {
    
    func fetchAllRecipes(with url: URL) async throws -> [Recipe] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipesContainer = try JSONDecoder().decode(RecipesContainer.self, from: data)
            return recipesContainer.recipes
        } catch {
            NSLog("Error fetching recipes from \(url): \(error)")
            throw error
        }
    }
}
