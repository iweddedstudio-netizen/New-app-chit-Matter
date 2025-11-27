import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: onFavoriteToggle) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(recipe.isFavorite ? .red : .secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Text(recipe.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, AppSpacing.xs)
                    .padding(.vertical, AppSpacing.xxs)
                    .background(AppColors.accent.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.xs))
                
                HStack {
                    Label("\(recipe.calories) kcal", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(AppColors.warning)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("P: \(recipe.protein)g")
                        Text("C: \(recipe.carbs)g")
                        Text("F: \(recipe.fat)g")
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        }
        .buttonStyle(.plain)
    }
}
