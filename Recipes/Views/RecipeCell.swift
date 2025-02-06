//
//  RecipeCell.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import SwiftUI

struct RecipeCell: View {
    
    private var isExpanded: Bool {
        viewModel.expandedRecipe == recipe
    }
    
    @ObservedObject var viewModel: RecipesViewModel
    var recipe: Recipe
    
    var body: some View {
        if viewModel.expandedRecipe != recipe {
            closedContent()
        } else {
            expandedContent()
        }
    }
    
    func closedContent() -> some View {
        
        HStack(alignment: .top) {
            RecipeImageView(viewModel: viewModel, recipe: recipe, size: .small)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(recipe.cuisine) cuisine")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            
            Spacer()
            
            chevron()
        }
        .padding(.top)
    }
    
    func expandedContent() -> some View {
        VStack(alignment: .leading) {
                        
            HStack(alignment: .top) {
                RecipeImageView(viewModel: viewModel, recipe: recipe, size: .large)
                    .aspectRatio(contentMode: .fit)
                
                chevron()
            }
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title3)
                Text("\(recipe.cuisine) cuisine")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if let urlString = recipe.sourceUrl,
               let sourceUrl = URL(string: urlString) {
                sourceButton(sourceUrl: sourceUrl)
            }
            
            if let urlString = recipe.youtubeUrl,
               let youtubeUrl = URL(string: urlString) {
                youtubeButton(youtubeUrl: youtubeUrl)
            }
        }
        .padding(.top)
        .task {
            await viewModel.loadLargeImageForRecipe(recipe)
        }
    }
    
    func chevron() -> some View {
        Image(systemName: "chevron.down")
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
            .onTapGesture {
                withAnimation {
                    if viewModel.expandedRecipe != recipe {
                        viewModel.expandedRecipe = recipe
                    } else {
                        viewModel.expandedRecipe = nil
                    }
                }
            }
    }
    
    func sourceButton(sourceUrl: URL) -> some View {
        Link(destination: sourceUrl) {
            HStack {
                Label("View Recipe Source", systemImage: "link")
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func youtubeButton(youtubeUrl: URL) -> some View {
        Link(destination: youtubeUrl) {
            HStack {
                Label("Watch on YouTube", systemImage: "play.rectangle.fill")
                    .foregroundColor(.red)
                Spacer()
            }
            .padding(8)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
