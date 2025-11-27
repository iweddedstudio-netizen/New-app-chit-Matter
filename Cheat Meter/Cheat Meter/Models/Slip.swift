import Foundation
import SwiftData

@Model
final class Slip {
    var id: UUID
    var food: String
    var date: Date
    var note: String?
    
    @Relationship var journey: Journey?
    
    init(food: String, date: Date = Date(), note: String? = nil, journey: Journey? = nil) {
        self.id = UUID()
        self.food = food
        self.date = date
        self.note = note
        self.journey = journey
    }
}
