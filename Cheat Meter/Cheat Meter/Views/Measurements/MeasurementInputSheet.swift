import SwiftUI
import SwiftData

struct MeasurementInputSheet: View {
    @Bindable var viewModel: MeasurementsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var date: Date = Date()
    @State private var weight: Double = 0.0
    @State private var chest: String = ""
    @State private var waist: String = ""
    @State private var hips: String = ""
    @State private var shoulders: String = ""
    @State private var thighs: String = ""
    @State private var calves: String = ""
    @State private var arms: String = ""
    @State private var neck: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("0.0", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                
                Section("Upper Body") {
                    MeasurementField(label: "Chest (cm)", text: $chest)
                    MeasurementField(label: "Shoulders (cm)", text: $shoulders)
                    MeasurementField(label: "Arms (cm)", text: $arms)
                    MeasurementField(label: "Neck (cm)", text: $neck)
                }
                
                Section("Core & Lower Body") {
                    MeasurementField(label: "Waist (cm)", text: $waist)
                    MeasurementField(label: "Hips (cm)", text: $hips)
                    MeasurementField(label: "Thighs (cm)", text: $thighs)
                    MeasurementField(label: "Calves (cm)", text: $calves)
                }
            }
            .navigationTitle("New Measurement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMeasurement()
                    }
                    .disabled(weight == 0)
                }
            }
            .onAppear {
                if let currentWeight = viewModel.journey?.weightEntries.sorted(by: { $0.date > $1.date }).first?.weight {
                    weight = currentWeight
                }
            }
        }
    }
    
    private func saveMeasurement() {
        let measurement = MeasurementEntry(date: date, weight: weight, journey: viewModel.journey)
        
        measurement.chest = Double(chest)
        measurement.waist = Double(waist)
        measurement.hips = Double(hips)
        measurement.shoulders = Double(shoulders)
        measurement.thighs = Double(thighs)
        measurement.calves = Double(calves)
        measurement.arms = Double(arms)
        measurement.neck = Double(neck)
        
        viewModel.addMeasurement(measurement)
        dismiss()
    }
}

struct MeasurementField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("Optional", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
        }
    }
}
