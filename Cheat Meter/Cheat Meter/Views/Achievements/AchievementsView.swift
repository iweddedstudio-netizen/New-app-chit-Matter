import SwiftUI
import SwiftData

struct AchievementsView: View {
    @State private var viewModel = AchievementsViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress Summary
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(viewModel.unlockedCount)/\(viewModel.totalCount)")
                                .font(.title)
                                .bold()
                            Text("Achievements Unlocked")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        CircularProgressView(progress: Double(viewModel.unlockedCount) / Double(max(1, viewModel.totalCount)))
                    }
                    .padding(AppSpacing.md)
                    .background(AppColors.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            CategoryChip(title: "All", isSelected: viewModel.selectedCategory == nil) {
                                viewModel.selectedCategory = nil
                            }
                            
                            ForEach([AchievementCategory.weight, .checkpoints, .consistency, .milestones], id: \.self) { category in
                                CategoryChip(title: categoryName(category), isSelected: viewModel.selectedCategory == category) {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                    }
                    
                    // Achievements Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.filteredAchievements) { achievement in
                            AchievementBadge(achievement: achievement)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadAchievements()
            }
        }
    }
    
    private func categoryName(_ category: AchievementCategory) -> String {
        switch category {
        case .weight: return "Weight Loss"
        case .checkpoints: return "Checkpoints"
        case .consistency: return "Consistency"
        case .milestones: return "Milestones"
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .bold()
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(isSelected ? AppColors.accent : AppColors.tertiaryBackground)
                .foregroundStyle(isSelected ? .black : .primary)
                .clipShape(Capsule())
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 8)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColors.accent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .bold()
        }
    }
}

#Preview {
    AchievementsView()
        .preferredColorScheme(.dark)
}
