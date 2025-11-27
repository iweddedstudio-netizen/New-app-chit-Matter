import SwiftUI

struct MeasurementCard: View {
    let measurement: MeasurementEntry
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(measurement.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                    Text("Weight: \(String(format: "%.1f", measurement.weight)) kg")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(AppColors.error)
                }
                .buttonStyle(.plain)
            }
            
            if hasMeasurements {
                Divider()
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    if let chest = measurement.chest {
                        MeasurementItem(label: "Chest", value: chest)
                    }
                    if let waist = measurement.waist {
                        MeasurementItem(label: "Waist", value: waist)
                    }
                    if let hips = measurement.hips {
                        MeasurementItem(label: "Hips", value: hips)
                    }
                    if let shoulders = measurement.shoulders {
                        MeasurementItem(label: "Shoulders", value: shoulders)
                    }
                    if let thighs = measurement.thighs {
                        MeasurementItem(label: "Thighs", value: thighs)
                    }
                    if let calves = measurement.calves {
                        MeasurementItem(label: "Calves", value: calves)
                    }
                    if let arms = measurement.arms {
                        MeasurementItem(label: "Arms", value: arms)
                    }
                    if let neck = measurement.neck {
                        MeasurementItem(label: "Neck", value: neck)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .onTapGesture(perform: onTap)
    }
    
    var hasMeasurements: Bool {
        measurement.chest != nil || measurement.waist != nil || measurement.hips != nil ||
        measurement.shoulders != nil || measurement.thighs != nil || measurement.calves != nil ||
        measurement.arms != nil || measurement.neck != nil
    }
}

struct MeasurementItem: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(String(format: "%.1f", value)) cm")
                .font(.caption)
                .bold()
        }
    }
}
