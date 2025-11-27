import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var weight: Double
    var date: Date
    var note: String?
    
    @Relationship var journey: Journey?
    
    init(weight: Double, date: Date = Date(), note: String? = nil, journey: Journey? = nil) {
        self.id = UUID()
        self.weight = weight
        self.date = date
        self.note = note
        self.journey = journey
    }
}
