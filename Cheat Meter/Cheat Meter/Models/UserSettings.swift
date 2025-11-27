import Foundation
import SwiftData

enum WeightUnit: String, Codable {
    case kg
    case lbs
}

enum HeightUnit: String, Codable {
    case cm
    case ft
}

enum Gender: String, Codable {
    case male
    case female
    case other
}

enum AppTheme: String, Codable {
    case system
    case light
    case dark
}

@Model
final class UserSettings {
    var weightUnit: WeightUnit
    var heightUnit: HeightUnit
    var gender: Gender
    var height: Double
    var hasCompletedOnboarding: Bool
    var appTheme: AppTheme

    init(weightUnit: WeightUnit = .kg, heightUnit: HeightUnit = .cm, gender: Gender = .male, height: Double = 175, hasCompletedOnboarding: Bool = false, appTheme: AppTheme = .system) {
        self.weightUnit = weightUnit
        self.heightUnit = heightUnit
        self.gender = gender
        self.height = height
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.appTheme = appTheme
    }
}
