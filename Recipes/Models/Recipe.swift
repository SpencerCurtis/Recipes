//
//  Recipe.swift
//  Recipe
//
//  Created by Spencer Curtis on 2/5/25.
//

struct Recipe: Decodable, Identifiable, Equatable {
    
    var id: String { uuid }
    
    let uuid: String
    let name: String
    let cuisine: String
    let sourceUrl: String?
    let youtubeUrl: String?
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
    }
}

struct RecipesContainer: Decodable {
    let recipes: [Recipe]
}
