import Foundation
import SwiftData

@Model
final class Recipe {
    var id: UUID
    var name: String
    var recipeDescription: String
    var category: String
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    var ingredients: String
    var instructions: String
    var imageURL: String?
    var isFavorite: Bool
    var isUserCreated: Bool
    
    init(name: String, description: String, category: String, calories: Int, protein: Int, carbs: Int, fat: Int, ingredients: String, instructions: String, isUserCreated: Bool = true) {
        self.id = UUID()
        self.name = name
        self.recipeDescription = description
        self.category = category
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.ingredients = ingredients
        self.instructions = instructions
        self.isFavorite = false
        self.isUserCreated = isUserCreated
    }
}
