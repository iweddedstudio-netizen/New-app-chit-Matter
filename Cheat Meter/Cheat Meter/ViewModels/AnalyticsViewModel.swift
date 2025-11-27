import Foundation
import SwiftData
import SwiftUI

enum TimeRange: String, CaseIterable {
    case week = "1W"
    case month = "1M"
    case threeMonths = "3M"
    case all = "All"
}

@Observable
class AnalyticsViewModel {
    var modelContext: ModelContext?
    var selectedTimeRange: TimeRange = .month
    var weightEntries: [WeightEntry] = []
    var journey: Journey?
    
    var filteredEntries: [WeightEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch selectedTimeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .threeMonths:
            startDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .all:
            return weightEntries.sorted { $0.date < $1.date }
        }
        
        return weightEntries.filter { $0.date >= startDate }.sorted { $0.date < $1.date }
    }
    
    var currentWeight: Double {
        weightEntries.sorted(by: { $0.date > $1.date }).first?.weight ?? journey?.startWeight ?? 0
    }
    
    var startWeight: Double {
        journey?.startWeight ?? 0
    }
    
    var goalWeight: Double {
        journey?.goalWeight ?? 0
    }
    
    var totalLost: Double {
        startWeight - currentWeight
    }
    
    var bmi: Double {
        guard let modelContext = journey?.modelContext else { return 0 }
        do {
            let height = try modelContext.fetch(FetchDescriptor<UserSettings>()).first?.height ?? 0
            guard height > 0 else { return 0 }
            let heightInMeters = height / 100.0
            return currentWeight / (heightInMeters * heightInMeters)
        } catch {
            return 0
        }
    }
    
    // Insights
    var averageDailyLoss: Double {
        guard let firstEntry = weightEntries.sorted(by: { $0.date < $1.date }).first else { return 0 }
        let days = Calendar.current.dateComponents([.day], from: firstEntry.date, to: Date()).day ?? 1
        return max(0, totalLost / Double(max(1, days)))
    }
    
    var projectedWeightInMonth: Double {
        return max(0, currentWeight - (averageDailyLoss * 30))
    }
    
    var estimatedGoalDate: Date? {
        guard averageDailyLoss > 0 else { return nil }
        let remaining = currentWeight - goalWeight
        guard remaining > 0 else { return Date() }
        let daysRemaining = Int(remaining / averageDailyLoss)
        return Calendar.current.date(byAdding: .day, value: daysRemaining, to: Date())
    }
    
    func loadData() {
        guard let modelContext = modelContext else { return }
        
        do {
            let journeyDescriptor = FetchDescriptor<Journey>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
            self.journey = try modelContext.fetch(journeyDescriptor).first
            
            let entryDescriptor = FetchDescriptor<WeightEntry>(sortBy: [SortDescriptor(\.date, order: .forward)])
            self.weightEntries = try modelContext.fetch(entryDescriptor)
        } catch {
            print("Failed to fetch analytics data: \(error)")
        }
    }
}
