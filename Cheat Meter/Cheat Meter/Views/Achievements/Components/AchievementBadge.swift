import SwiftUI

struct AchievementBadge: View {
    let achievement: Achievement
    
    var rarityColor: Color {
        switch achievement.rarity {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .yellow
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? rarityColor.opacity(0.2) : AppColors.tertiaryBackground)
                    .frame(width: 80, height: 80)
                
                Image(systemName: achievement.iconName)
                    .font(.largeTitle)
                    .foregroundStyle(achievement.isUnlocked ? rarityColor : .secondary)
                    .opacity(achievement.isUnlocked ? 1 : 0.4)
                
                if !achievement.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .offset(x: 20, y: 20)
                }
            }
            
            VStack(spacing: 4) {
                Text(achievement.name)
                    .font(.subheadline)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.achievementDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.currentProgress, total: achievement.targetValue)
                        .tint(rarityColor)
                        .padding(.top, 4)
                    
                    Text("\(Int(achievement.currentProgress))/\(Int(achievement.targetValue))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}
