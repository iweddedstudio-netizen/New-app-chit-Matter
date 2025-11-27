import Foundation
import SwiftData

enum CheatmealStatus: String, Codable {
    case locked
    case available
    case active
    case completed
}

@Model
final class Cheatmeal {
    var id: UUID
    var status: CheatmealStatus
    var checkpointNumber: Int
    var weightAtUnlock: Double
    var activatedAt: Date?
    var completedAt: Date?
    var expiresAt: Date?
    var note: String?
    @Attribute(.externalStorage) var photoData: Data?
    
    @Relationship var journey: Journey?
    
    init(status: CheatmealStatus = .locked, checkpointNumber: Int, weightAtUnlock: Double, journey: Journey? = nil) {
        self.id = UUID()
        self.status = status
        self.checkpointNumber = checkpointNumber
        self.weightAtUnlock = weightAtUnlock
        self.journey = journey
    }
}
