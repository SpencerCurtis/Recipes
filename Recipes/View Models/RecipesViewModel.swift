//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import Foundation
import SwiftUI
class RecipesViewModel: ObservableObject {
    @Published var recipesState: DataLoadState<[Recipe]> = .loading
    
    @Published private(set) var recipeImagesSmall: [String: Image] = [:]
    @Published private(set) var recipeImagesLarge: [String: Image] = [:]
    
    @Published var expandedRecipe: Recipe? = nil
    
    private let recipesService = RecipesService()
    private let recipeURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    private let imageCache = RecipeImageCache.shared

    @MainActor
    @Sendable
    func fetchAllRecipes() async {
        recipesState = .loading
        
        do {
            let recipes = try await recipesService.fetchAllRecipes(with: recipeURL)
            guard recipes.count > 0 else {
                recipesState = .error(RecipeFetchingError.noRecipes)
                return
            }
            
            recipesState = .success(recipes)
            
            await loadSmallImagesForRecipes(recipes)
        } catch {
            recipesState = .error(RecipeFetchingError.decodingError)
        }
    }
    
    @MainActor func fetchAllRecipesSilent() {
        Task {
            await fetchAllRecipes()
        }
    }
    
    @MainActor
    @Sendable
    private func loadSmallImagesForRecipes(_ recipes: [Recipe]) async {
        for recipe in recipes {
            
            if let url = recipe.photoUrlSmall,
               let cached = await imageCache.image(for: url, size: .small) {
                recipeImagesSmall[recipe.id] = cached
                continue
            }
            
            do {
                if let url = recipe.photoUrlSmall {
                    let image = try await imageCache.loadRecipeImage(from: url, size: .small)
                    recipeImagesSmall[recipe.id] = image
                } else {
                    throw RecipeFetchingError.noImageUrl
                }
            } catch {
                print("Failed to load small image for recipe: \(recipe.id)")
                recipeImagesSmall[recipe.id] = Image(systemName: "photo")
            }
        }
    }
    
    @MainActor
    func loadLargeImageForRecipe(_ recipe: Recipe) async {
        if let url = recipe.photoUrlLarge,
           let cached = await imageCache.image(for: url, size: .large) {
            recipeImagesLarge[recipe.id] = cached
            return
        }
        
        do {
            if let url = recipe.photoUrlLarge {
                let image = try await imageCache.loadRecipeImage(from: url, size: .large)
                recipeImagesLarge[recipe.id] = image
            } else {
                throw RecipeFetchingError.noImageUrl
            }
        } catch {
            print("Failed to load large image for recipe: \(recipe.id)")
            recipeImagesSmall[recipe.id] = Image(systemName: "photo")
        }
    }
    
    func image(for recipe: Recipe, size: RecipeImageCache.ImageSize) -> Image {
        switch size {
        case .small:
            recipeImagesSmall[recipe.id] ?? Image(systemName: "photo")
        case .large:
            recipeImagesLarge[recipe.id] ?? Image(systemName: "photo")
        }
    }
}

enum RecipeFetchingError: Error {
    case decodingError
    case noRecipes
    case imageLoadingError
    case noImageUrl
}
