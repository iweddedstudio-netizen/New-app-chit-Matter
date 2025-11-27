import SwiftUI
import SwiftData

struct WeightEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Journey.startDate, order: .reverse) private var journeys: [Journey]

    let providedJourney: Journey?

    @State private var weight: Double = 75.0

    private var journey: Journey? {
        providedJourney ?? journeys.first
    }

    init(journey: Journey? = nil) {
        self.providedJourney = journey
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                // Weight display
                Text(String(format: "%.1f kg", weight))
                    .font(.system(size: AppFontSize.weightDisplay, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                // Wheel Picker
                WeightWheelPicker(weight: $weight)
                    .padding(.horizontal, AppSpacing.xxxl)

                Spacer()

                // Save Button
                PrimaryButton(title: "Save Weight") {
                    saveWeight()
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.md)
            }
            .navigationTitle("Record Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                initializeWeight()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private func initializeWeight() {
        if let journey = journey,
           let lastWeight = journey.weightEntries.sorted(by: { $0.date > $1.date }).first?.weight {
            weight = lastWeight
        } else if let startWeight = journey?.startWeight {
            weight = startWeight
        }
    }

    private func saveWeight() {
        guard let journey = journey else {
            dismiss()
            return
        }

        let entry = WeightEntry(weight: weight, journey: journey)
        modelContext.insert(entry)
        checkCheckpoint(journey: journey)
        try? modelContext.save()
        dismiss()
    }

    private func checkCheckpoint(journey: Journey) {
        let currentLost = journey.startWeight - weight
        var newCheckpoints = 0

        switch journey.checkpointMetric {
        case .kg:
            newCheckpoints = Int(currentLost / journey.checkpointValue)
        case .percent:
            let totalToLose = journey.startWeight - journey.goalWeight
            let kgPerPercent = totalToLose * (journey.checkpointValue / 100.0)
            guard kgPerPercent > 0 else { return }
            newCheckpoints = Int(currentLost / kgPerPercent)
        case .micro:
            newCheckpoints = Int(currentLost / 0.5)
        }

        guard newCheckpoints > journey.completedCheckpoints else { return }

        let diff = newCheckpoints - journey.completedCheckpoints
        journey.completedCheckpoints = newCheckpoints

        let rewardsCount = journey.rewardType == .meals ? (journey.mealsCount ?? 1) : 1
        for _ in 0..<(diff * rewardsCount) {
            let cheatmeal = Cheatmeal(
                status: .available,
                checkpointNumber: newCheckpoints,
                weightAtUnlock: weight,
                journey: journey
            )
            modelContext.insert(cheatmeal)
        }
    }
}

#Preview {
    WeightEntrySheet(journey: nil)
        .preferredColorScheme(.dark)
}
