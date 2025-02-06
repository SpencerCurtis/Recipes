//
//  ImageCache.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import SwiftUI

actor RecipeImageCache {
    enum ImageSize {
        case large
        case small
    }
    
    enum ImageCacheError: Error {
        case stringIsNotURL
        case dataIsNotAnImage
    }
    
    static let shared = RecipeImageCache()
    
    private var largeImageCache: [String: Image] = [:]
    private var smallImageCache: [String: Image] = [:]
    private var loadingTasks: [String: Task<Image?, Error>] = [:]
    
    var isLoading = false
    
    private init() {}
    
    @discardableResult
    func image(for url: String, size: ImageSize) -> Image? {
        switch size {
        case .large:
            return largeImageCache[url]
        case .small:
            return smallImageCache[url]
        }
    }
    
    @discardableResult
    func loadRecipeImage(from url: String, size: ImageSize) async throws -> Image {
        if let cachedImage = image(for: url, size: size) {
            return cachedImage
        } else if let existingTask = loadingTasks[url] {
            return try await existingTask.value ?? Image(systemName: "photo")
        }
        
        let task = Task<Image?, Error> {
            guard let imageUrl = URL(string: url) else {
                throw ImageCacheError.stringIsNotURL
            }
            
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            
            guard let uiImage = UIImage(data: data) else {
                throw ImageCacheError.dataIsNotAnImage
            }
            
            let image = Image(uiImage: uiImage)
            
            switch size {
            case .large:
                largeImageCache[url] = image
            case .small:
                smallImageCache[url] = image
            }
            
            self.loadingTasks[url] = nil
            return image
        }
        
        loadingTasks[url] = task
        return try await task.value ?? Image(systemName: "photo")
    }
    
    func clearCache() {
        largeImageCache.removeAll()
        smallImageCache.removeAll()
        loadingTasks.removeAll()
    }
}
