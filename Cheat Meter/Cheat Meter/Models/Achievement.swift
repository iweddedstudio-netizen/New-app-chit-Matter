import Foundation
import SwiftData

enum AchievementCategory: String, Codable {
    case weight
    case checkpoints
    case consistency
    case milestones
}

enum AchievementRarity: String, Codable {
    case common
    case rare
    case epic
    case legendary
}

@Model
final class Achievement {
    var id: String
    var category: AchievementCategory
    var name: String
    var achievementDescription: String
    var iconName: String
    var rarity: AchievementRarity
    var targetValue: Double
    var currentProgress: Double
    var isUnlocked: Bool
    var unlockedAt: Date?
    
    init(id: String, category: AchievementCategory, name: String, description: String, iconName: String, rarity: AchievementRarity, targetValue: Double) {
        self.id = id
        self.category = category
        self.name = name
        self.achievementDescription = description
        self.iconName = iconName
        self.rarity = rarity
        self.targetValue = targetValue
        self.currentProgress = 0
        self.isUnlocked = false
    }
}
