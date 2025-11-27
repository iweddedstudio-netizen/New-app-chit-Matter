import Foundation
import SwiftData
import SwiftUI

@Observable
class AchievementsViewModel {
    var modelContext: ModelContext?
    var achievements: [Achievement] = []
    var selectedCategory: AchievementCategory?
    
    var filteredAchievements: [Achievement] {
        if let category = selectedCategory {
            return achievements.filter { $0.category == category }
        }
        return achievements
    }
    
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    var totalCount: Int {
        achievements.count
    }
    
    func loadAchievements() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Achievement>(sortBy: [SortDescriptor(\.targetValue)])
            self.achievements = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch achievements: \(error)")
        }
    }
}
