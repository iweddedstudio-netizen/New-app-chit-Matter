import Foundation
import SwiftData
import SwiftUI

@Observable
class MeasurementsViewModel {
    var modelContext: ModelContext?
    var measurements: [MeasurementEntry] = []
    var journey: Journey?
    
    func loadMeasurements() {
        guard let modelContext = modelContext else { return }
        
        do {
            let journeyDescriptor = FetchDescriptor<Journey>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
            self.journey = try modelContext.fetch(journeyDescriptor).first
            
            let descriptor = FetchDescriptor<MeasurementEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            self.measurements = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch measurements: \(error)")
        }
    }
    
    func addMeasurement(_ measurement: MeasurementEntry) {
        guard let modelContext = modelContext else { return }
        modelContext.insert(measurement)
        
        do {
            try modelContext.save()
            loadMeasurements()
        } catch {
            print("Failed to save measurement: \(error)")
        }
    }
    
    func deleteMeasurement(_ measurement: MeasurementEntry) {
        guard let modelContext = modelContext else { return }
        modelContext.delete(measurement)
        
        do {
            try modelContext.save()
            loadMeasurements()
        } catch {
            print("Failed to delete measurement: \(error)")
        }
    }
    
    func calculateDifference(from: MeasurementEntry, to: MeasurementEntry, field: KeyPath<MeasurementEntry, Double?>) -> Double? {
        guard let fromValue = from[keyPath: field], let toValue = to[keyPath: field] else { return nil }
        return toValue - fromValue
    }
}
