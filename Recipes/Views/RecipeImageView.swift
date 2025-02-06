//
//  RecipeImageView.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import SwiftUI

struct RecipeImageView: View {
    @ObservedObject var viewModel: RecipesViewModel
    
    let recipe: Recipe
    let size: RecipeImageCache.ImageSize
    
    
    var body: some View {
        
        viewModel.image(for: recipe, size: size)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 8))

    }
}

#Preview {
    RecipeImageView(
        viewModel: RecipesViewModel(),
        recipe: Recipe(
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            name: "Apam Balik",
            cuisine: "Malaysian",
            sourceUrl: nil,
            youtubeUrl: nil,
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        ),
        size: .small
    )
}

