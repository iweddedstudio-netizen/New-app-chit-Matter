import Foundation
import SwiftData

enum CheckpointMetric: String, Codable {
    case kg
    case percent
    case micro
}

enum RewardType: String, Codable {
    case meals
    case days
}

@Model
final class Journey {
    var id: UUID
    var startWeight: Double
    var goalWeight: Double
    var checkpointMetric: CheckpointMetric
    var checkpointValue: Double
    var rewardType: RewardType
    var mealsCount: Int?
    var daysCount: Int?
    var cheatmealDuration: Int
    var isActive: Bool
    var completedCheckpoints: Int
    var startDate: Date
    var endDate: Date?
    
    @Relationship(deleteRule: .cascade) var weightEntries: [WeightEntry] = []
    @Relationship(deleteRule: .cascade) var cheatmeals: [Cheatmeal] = []
    @Relationship(deleteRule: .cascade) var slips: [Slip] = []
    @Relationship(deleteRule: .cascade) var measurements: [MeasurementEntry] = []
    
    init(startWeight: Double, goalWeight: Double, checkpointMetric: CheckpointMetric, checkpointValue: Double, rewardType: RewardType, mealsCount: Int? = nil, daysCount: Int? = nil, cheatmealDuration: Int, isActive: Bool = true, startDate: Date = Date()) {
        self.id = UUID()
        self.startWeight = startWeight
        self.goalWeight = goalWeight
        self.checkpointMetric = checkpointMetric
        self.checkpointValue = checkpointValue
        self.rewardType = rewardType
        self.mealsCount = mealsCount
        self.daysCount = daysCount
        self.cheatmealDuration = cheatmealDuration
        self.isActive = isActive
        self.completedCheckpoints = 0
        self.startDate = startDate
    }
}
