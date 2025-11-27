import Foundation
import SwiftData

class AchievementsService {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func initializeDefaultAchievements() {
        let descriptor = FetchDescriptor<Achievement>()
        let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        
        guard existingCount == 0 else { return }
        
        let defaultAchievements: [Achievement] = [
            // Weight Loss
            Achievement(id: "first_steps", category: .weight, name: "First Steps", description: "Lost 1 kg", iconName: "figure.walk", rarity: .common, targetValue: 1),
            Achievement(id: "getting_started", category: .weight, name: "Getting Started", description: "Lost 5 kg", iconName: "figure.run", rarity: .rare, targetValue: 5),
            Achievement(id: "halfway_hero", category: .weight, name: "Halfway Hero", description: "Reached 50% of your goal", iconName: "star.fill", rarity: .epic, targetValue: 50),
            Achievement(id: "almost_there", category: .weight, name: "Almost There", description: "Reached 75% of your goal", iconName: "star.leadinghalf.filled", rarity: .epic, targetValue: 75),
            Achievement(id: "goal_crusher", category: .weight, name: "Goal Crusher", description: "Reached 100% of your goal", iconName: "trophy.fill", rarity: .legendary, targetValue: 100),
            
            // Checkpoints
            Achievement(id: "first_milestone", category: .checkpoints, name: "First Milestone", description: "Reached your first checkpoint", iconName: "flag.fill", rarity: .common, targetValue: 1),
            Achievement(id: "checkpoint_master", category: .checkpoints, name: "Checkpoint Master", description: "Reached 5 checkpoints", iconName: "flag.2.crossed.fill", rarity: .rare, targetValue: 5),
            Achievement(id: "unstoppable", category: .checkpoints, name: "Unstoppable", description: "Reached 10 checkpoints", iconName: "flame.fill", rarity: .epic, targetValue: 10),
            
            // Consistency
            Achievement(id: "week_warrior", category: .consistency, name: "Week Warrior", description: "7 days of logging", iconName: "calendar.badge.checkmark", rarity: .common, targetValue: 7),
            Achievement(id: "month_master", category: .consistency, name: "Month Master", description: "30 days of logging", iconName: "calendar", rarity: .rare, targetValue: 30),
            
            // Milestones
            Achievement(id: "journey_beginner", category: .milestones, name: "Journey Beginner", description: "7 days on the journey", iconName: "figure.walk.circle", rarity: .common, targetValue: 7),
            Achievement(id: "journey_veteran", category: .milestones, name: "Journey Veteran", description: "30 days on the journey", iconName: "figure.run.circle", rarity: .rare, targetValue: 30),
            Achievement(id: "journey_legend", category: .milestones, name: "Journey Legend", description: "100 days on the journey", iconName: "crown.fill", rarity: .legendary, targetValue: 100),
        ]
        
        for achievement in defaultAchievements {
            modelContext.insert(achievement)
        }
        
        try? modelContext.save()
    }
    
    func checkAchievements(journey: Journey) {
        let descriptor = FetchDescriptor<Achievement>()
        guard let achievements = try? modelContext.fetch(descriptor) else { return }
        
        for achievement in achievements where !achievement.isUnlocked {
            updateProgress(achievement: achievement, journey: journey)
        }
    }
    
    private func updateProgress(achievement: Achievement, journey: Journey) {
        switch achievement.category {
        case .weight:
            let weightLost = journey.startWeight - (journey.weightEntries.sorted(by: { $0.date > $1.date }).first?.weight ?? journey.startWeight)
            
            if achievement.id.contains("halfway") || achievement.id.contains("almost") || achievement.id.contains("goal_crusher") {
                let totalToLose = journey.startWeight - journey.goalWeight
                let progress = (weightLost / totalToLose) * 100
                achievement.currentProgress = progress
            } else {
                achievement.currentProgress = weightLost
            }
            
        case .checkpoints:
            achievement.currentProgress = Double(journey.completedCheckpoints)
            
        case .consistency:
            // Simplified: count unique days with weight entries
            let uniqueDays = Set(journey.weightEntries.map { Calendar.current.startOfDay(for: $0.date) }).count
            achievement.currentProgress = Double(uniqueDays)
            
        case .milestones:
            let days = Calendar.current.dateComponents([.day], from: journey.startDate, to: Date()).day ?? 0
            achievement.currentProgress = Double(days)
        }
        
        if achievement.currentProgress >= achievement.targetValue && !achievement.isUnlocked {
            achievement.isUnlocked = true
            achievement.unlockedAt = Date()
            try? modelContext.save()
        }
    }
}
