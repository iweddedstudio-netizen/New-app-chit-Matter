import Foundation
import SwiftData
import SwiftUI

@Observable
class FoodDiaryViewModel {
    var modelContext: ModelContext?
    var recipes: [Recipe] = []
    var searchText: String = ""
    var showFavoritesOnly: Bool = false
    
    var filteredRecipes: [Recipe] {
        var result = recipes
        
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        if !searchText.isEmpty {
            result = result.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.name < $1.name }
    }
    
    func loadRecipes() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)])
            self.recipes = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        guard let modelContext = modelContext else { return }
        modelContext.insert(recipe)
        
        do {
            try modelContext.save()
            loadRecipes()
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        guard let modelContext = modelContext else { return }
        modelContext.delete(recipe)
        
        do {
            try modelContext.save()
            loadRecipes()
        } catch {
            print("Failed to delete recipe: \(error)")
        }
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        recipe.isFavorite.toggle()
        
        do {
            try modelContext?.save()
        } catch {
            print("Failed to update favorite: \(error)")
        }
    }
}
