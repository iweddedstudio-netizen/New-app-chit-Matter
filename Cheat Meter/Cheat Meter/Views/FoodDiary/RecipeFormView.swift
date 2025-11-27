import SwiftUI
import SwiftData

struct RecipeFormView: View {
    @Bindable var viewModel: FoodDiaryViewModel
    @Environment(\.dismiss) private var dismiss
    
    var recipeToEdit: Recipe?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var calories: Int = 0
    @State private var protein: Int = 0
    @State private var carbs: Int = 0
    @State private var fat: Int = 0
    @State private var ingredients: String = ""
    @State private var instructions: String = ""
    
    var isEditing: Bool {
        recipeToEdit != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Recipe Name", text: $name)
                    TextField("Category (e.g., Breakfast)", text: $category)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Nutrition") {
                    HStack {
                        Text("Calories")
                        Spacer()
                        TextField("0", value: $calories, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Protein (g)")
                        Spacer()
                        TextField("0", value: $protein, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Carbs (g)")
                        Spacer()
                        TextField("0", value: $carbs, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Fat (g)")
                        Spacer()
                        TextField("0", value: $fat, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                
                Section("Ingredients") {
                    TextField("List ingredients...", text: $ingredients, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section("Instructions") {
                    TextField("Cooking instructions...", text: $instructions, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle(isEditing ? "Edit Recipe" : "New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let recipe = recipeToEdit {
                    name = recipe.name
                    description = recipe.recipeDescription
                    category = recipe.category
                    calories = recipe.calories
                    protein = recipe.protein
                    carbs = recipe.carbs
                    fat = recipe.fat
                    ingredients = recipe.ingredients
                    instructions = recipe.instructions
                }
            }
        }
    }
    
    private func saveRecipe() {
        if let existingRecipe = recipeToEdit {
            // Update existing
            existingRecipe.name = name
            existingRecipe.recipeDescription = description
            existingRecipe.category = category
            existingRecipe.calories = calories
            existingRecipe.protein = protein
            existingRecipe.carbs = carbs
            existingRecipe.fat = fat
            existingRecipe.ingredients = ingredients
            existingRecipe.instructions = instructions
            
            do {
                try viewModel.modelContext?.save()
                viewModel.loadRecipes()
            } catch {
                print("Failed to update recipe: \(error)")
            }
        } else {
            // Create new
            let newRecipe = Recipe(
                name: name,
                description: description,
                category: category,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                ingredients: ingredients,
                instructions: instructions,
                isUserCreated: true
            )
            viewModel.addRecipe(newRecipe)
        }
        
        dismiss()
    }
}
