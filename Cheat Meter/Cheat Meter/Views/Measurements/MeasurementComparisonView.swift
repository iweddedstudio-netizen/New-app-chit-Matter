import SwiftUI

struct MeasurementComparisonView: View {
    let earlier: MeasurementEntry
    let later: MeasurementEntry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        ComparisonDateCard(title: "Earlier", date: earlier.date, weight: earlier.weight)
                        
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        ComparisonDateCard(title: "Later", date: later.date, weight: later.weight)
                    }
                    .padding()
                    
                    VStack(spacing: 12) {
                        Text("Measurements Comparison")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ComparisonRow(label: "Weight", earlier: earlier.weight, later: later.weight, unit: "kg")
                        
                        if let earlierChest = earlier.chest, let laterChest = later.chest {
                            ComparisonRow(label: "Chest", earlier: earlierChest, later: laterChest, unit: "cm")
                        }
                        
                        if let earlierWaist = earlier.waist, let laterWaist = later.waist {
                            ComparisonRow(label: "Waist", earlier: earlierWaist, later: laterWaist, unit: "cm")
                        }
                        
                        if let earlierHips = earlier.hips, let laterHips = later.hips {
                            ComparisonRow(label: "Hips", earlier: earlierHips, later: laterHips, unit: "cm")
                        }
                        
                        if let earlierShoulders = earlier.shoulders, let laterShoulders = later.shoulders {
                            ComparisonRow(label: "Shoulders", earlier: earlierShoulders, later: laterShoulders, unit: "cm")
                        }
                        
                        if let earlierThighs = earlier.thighs, let laterThighs = later.thighs {
                            ComparisonRow(label: "Thighs", earlier: earlierThighs, later: laterThighs, unit: "cm")
                        }
                        
                        if let earlierCalves = earlier.calves, let laterCalves = later.calves {
                            ComparisonRow(label: "Calves", earlier: earlierCalves, later: laterCalves, unit: "cm")
                        }
                        
                        if let earlierArms = earlier.arms, let laterArms = later.arms {
                            ComparisonRow(label: "Arms", earlier: earlierArms, later: laterArms, unit: "cm")
                        }
                        
                        if let earlierNeck = earlier.neck, let laterNeck = later.neck {
                            ComparisonRow(label: "Neck", earlier: earlierNeck, later: laterNeck, unit: "cm")
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(AppColors.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .navigationTitle("Comparison")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ComparisonDateCard: View {
    let title: String
    let date: Date
    let weight: Double
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
                .bold()
            Text("\(String(format: "%.1f", weight)) kg")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.tertiaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
}

struct ComparisonRow: View {
    let label: String
    let earlier: Double
    let later: Double
    let unit: String
    
    var difference: Double {
        later - earlier
    }
    
    var diffColor: Color {
        if difference < 0 { return AppColors.accent }
        if difference > 0 { return AppColors.error }
        return .secondary
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(String(format: "%.1f", earlier)) \(unit)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Image(systemName: "arrow.right")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text("\(String(format: "%.1f", later)) \(unit)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(String(format: "%+.1f", difference))
                .font(.caption)
                .bold()
                .foregroundStyle(diffColor)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}
