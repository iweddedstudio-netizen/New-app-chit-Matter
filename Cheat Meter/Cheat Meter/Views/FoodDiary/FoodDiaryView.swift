import SwiftUI
import SwiftData

struct FoodDiaryView: View {
    @State private var viewModel = FoodDiaryViewModel()
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddRecipe = false
    @State private var selectedRecipe: Recipe?
    @State private var editingRecipe: Recipe?
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.filteredRecipes.isEmpty {
                    ContentUnavailableView(
                        "No Recipes",
                        systemImage: "fork.knife",
                        description: Text("Add your first healthy recipe to get started.")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                RecipeCard(recipe: recipe) {
                                    selectedRecipe = recipe
                                } onFavoriteToggle: {
                                    viewModel.toggleFavorite(recipe)
                                }
                            }
                        }
                        .padding()
                    }
                    .searchable(text: $viewModel.searchText, prompt: "Search recipes")
                }
            }
            .navigationTitle("Food Diary")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddRecipe = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Button {
                        viewModel.showFavoritesOnly.toggle()
                    } label: {
                        Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                            .foregroundStyle(viewModel.showFavoritesOnly ? .red : .primary)
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadRecipes()
            }
            .sheet(isPresented: $showAddRecipe) {
                RecipeFormView(viewModel: viewModel)
            }
            .sheet(item: $editingRecipe) { recipe in
                RecipeFormView(viewModel: viewModel, recipeToEdit: recipe)
            }
            .sheet(item: $selectedRecipe) { recipe in
                NavigationStack {
                    RecipeDetailView(recipe: recipe) {
                        viewModel.toggleFavorite(recipe)
                    } onEdit: {
                        selectedRecipe = nil
                        editingRecipe = recipe
                    } onDelete: {
                        viewModel.deleteRecipe(recipe)
                    }
                }
            }
        }
    }
}

#Preview {
    FoodDiaryView()
        .preferredColorScheme(.dark)
}
