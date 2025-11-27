import SwiftUI

struct StatsGrid: View {
    let totalLost: Double
    let bmi: Double
    let streak: Int
    let cheatmealsEarned: Int

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.md) {
            StatCard(title: "Total Lost", value: String(format: "%.1f kg", totalLost), icon: "arrow.down.circle.fill", color: AppColors.accent)
            StatCard(title: "BMI", value: String(format: "%.1f", bmi), icon: "figure.arms.open", color: .blue)
            StatCard(title: "Streak", value: "\(streak) days", icon: "flame.fill", color: AppColors.warning)
            StatCard(title: "Rewards", value: "\(cheatmealsEarned)", icon: "gift.fill", color: .purple)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text(value)
                    .font(.title2)
                    .bold()
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
}

#Preview {
    StatsGrid(totalLost: 5.2, bmi: 24.5, streak: 12, cheatmealsEarned: 3)
        .padding()
        .preferredColorScheme(.dark)
}
