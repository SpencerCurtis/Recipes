//
//  RecipesView.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import SwiftUI

struct RecipesView: View {
    
    @StateObject private var viewModel = RecipesViewModel()
     
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.recipesState {
                case .loading:
                    loadingView()
                case .success(let recipes):
                    recipesList(recipes)
                case .error(let error as RecipeFetchingError):
                    switch error {
                    case .noRecipes:
                        noRecipesView()
                    default:
                        errorView()
                    }
                default:
                    errorView()
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchAllRecipes()
            }
            .refreshable(action: viewModel.fetchAllRecipes)
        }
    }
     
     @ViewBuilder
     private func recipesList(_ recipes: [Recipe]) -> some View {
         List(recipes) { recipe in
             RecipeCell(viewModel: viewModel, recipe: recipe)
         }
         .listStyle(.grouped)
     }
    
    func loadingView() -> some View {
        VStack {
            Text("Loading recipes...")
                .font(.title2)
            ProgressView()
        }
    }
    
    func noRecipesView() -> some View {
        VStack {
            Text("No Recipes Found")
                .font(.title2)

            Button(action: viewModel.fetchAllRecipesSilent) {
                Text("Try again")
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
    
    func errorView() -> some View {
        VStack {
            Text("There was an error loading the recipes.")
                .font(.title2)

            Button(action: viewModel.fetchAllRecipesSilent) {
                Text("Try again")
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }
}
