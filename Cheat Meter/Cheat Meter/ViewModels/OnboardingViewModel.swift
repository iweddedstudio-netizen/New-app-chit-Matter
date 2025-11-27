import Foundation
import SwiftData
import SwiftUI

@Observable
class OnboardingViewModel {
    var gender: Gender = .male
    var height: Double = 175 // cm
    var currentWeight: Double = 80 // kg
    var goalWeight: Double = 70 // kg

    var checkpointMetric: CheckpointMetric = .kg
    var checkpointValue: Double = 1.0
    var rewardType: RewardType = .meals
    var mealsCount: Int = 1
    var daysCount: Int = 1
    var cheatmealDuration: Int = 2 // hours

    var modelContext: ModelContext?

    func saveUserSettings() {
        guard let modelContext = modelContext else { return }

        // Save UserSettings
        let settings = UserSettings(
            weightUnit: .kg,
            heightUnit: .cm,
            gender: gender,
            height: height,
            hasCompletedOnboarding: true
        )
        modelContext.insert(settings)

        // Create Initial Journey
        let journey = Journey(
            startWeight: currentWeight,
            goalWeight: goalWeight,
            checkpointMetric: checkpointMetric,
            checkpointValue: checkpointValue,
            rewardType: rewardType,
            mealsCount: rewardType == .meals ? mealsCount : nil,
            daysCount: rewardType == .days ? daysCount : nil,
            cheatmealDuration: cheatmealDuration,
            isActive: true,
            startDate: Date()
        )
        modelContext.insert(journey)

        // Create Initial Weight Entry
        let initialWeight = WeightEntry(weight: currentWeight, date: Date(), note: "Starting weight", journey: journey)
        modelContext.insert(initialWeight)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save onboarding data: \(error)")
        }
    }

    // Calculation helpers for ReviewView
    var weightToLose: Double {
        return max(0, currentWeight - goalWeight)
    }

    var totalCheckpoints: Int {
        guard checkpointValue > 0 else { return 0 }
        switch checkpointMetric {
        case .kg:
            return Int(weightToLose / checkpointValue)
        case .percent:
            let kgPerPercent = currentWeight * (checkpointValue / 100.0)
            return Int(weightToLose / kgPerPercent)
        case .micro:
            return Int(weightToLose / 0.5)
        }
    }

    var totalRewards: Int {
        if rewardType == .meals {
            return totalCheckpoints * mealsCount
        } else {
            return totalCheckpoints
        }
    }
}
