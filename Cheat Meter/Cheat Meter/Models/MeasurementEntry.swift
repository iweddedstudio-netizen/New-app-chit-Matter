import Foundation
import SwiftData

@Model
final class MeasurementEntry {
    var id: UUID
    var date: Date
    var weight: Double
    var chest: Double?
    var waist: Double?
    var hips: Double?
    var shoulders: Double?
    var thighs: Double?
    var calves: Double?
    var arms: Double?
    var neck: Double?
    
    @Relationship var journey: Journey?
    
    init(date: Date = Date(), weight: Double, journey: Journey? = nil) {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.journey = journey
    }
}
