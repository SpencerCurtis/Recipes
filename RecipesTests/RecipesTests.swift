//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Spencer Curtis on 2/5/25.
//

import Testing
@testable import Recipes
import Foundation

struct RecipesTests {
    
    let malformedJSONURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
    let emptyRecipesJSONURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
    
    @Test func testFetchAllRecipes() async throws {
        let recipeService = RecipesService()
        let recipes = try await recipeService.fetchAllRecipes(with: recipeService.recipeURL)
        #expect(recipes.count > 0)
    }
    
    @Test func testMalformedJSON() async throws {
        let recipeService = RecipesService()
        
        // Test that a decoding error is thrown when fetching malformed JSON
        await #expect(throws: DecodingError.self) {
            _ = try await recipeService.fetchAllRecipes(with: malformedJSONURL)
        }
    }
    
    @Test func testEmptyJSON() async throws {
        let recipeService = RecipesService()
        let recipes = try await recipeService.fetchAllRecipes(with: emptyRecipesJSONURL)
        #expect(recipes.count == 0)
    }

}
