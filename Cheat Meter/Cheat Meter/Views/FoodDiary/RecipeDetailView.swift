import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let onFavoriteToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.largeTitle)
                            .bold()
                        Text(recipe.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onFavoriteToggle) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundStyle(recipe.isFavorite ? .red : .secondary)
                    }
                }
                
                // Macros
                HStack(spacing: 16) {
                    MacroItem(label: "Calories", value: "\(recipe.calories)", unit: "kcal", color: .orange)
                    MacroItem(label: "Protein", value: "\(recipe.protein)", unit: "g", color: .red)
                    MacroItem(label: "Carbs", value: "\(recipe.carbs)", unit: "g", color: .blue)
                    MacroItem(label: "Fat", value: "\(recipe.fat)", unit: "g", color: .yellow)
                }
                
                Divider()
                
                // Description
                if !recipe.recipeDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(recipe.recipeDescription)
                            .font(.body)
                    }
                }
                
                // Ingredients
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                    Text(recipe.ingredients)
                        .font(.body)
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.headline)
                    Text(recipe.instructions)
                        .font(.body)
                }
            }
            .padding()
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        onDelete()
                        dismiss()
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct MacroItem: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title3)
                .bold()
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
