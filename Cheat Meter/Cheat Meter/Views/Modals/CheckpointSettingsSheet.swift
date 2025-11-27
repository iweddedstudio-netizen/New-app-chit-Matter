import SwiftUI

struct CheckpointSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss

    let journey: Journey
    let onSave: (CheckpointMetric, Double, RewardType, Int) -> Void

    @State private var selectedMetric: CheckpointMetric
    @State private var checkpointValue: Double
    @State private var selectedRewardType: RewardType
    @State private var rewardAmount: Int

    init(journey: Journey, onSave: @escaping (CheckpointMetric, Double, RewardType, Int) -> Void) {
        self.journey = journey
        self.onSave = onSave

        _selectedMetric = State(initialValue: journey.checkpointMetric)
        _checkpointValue = State(initialValue: journey.checkpointValue)
        _selectedRewardType = State(initialValue: journey.rewardType)
        _rewardAmount = State(initialValue: journey.rewardType == .meals ? (journey.mealsCount ?? 1) : (journey.daysCount ?? 1))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // Progress Tracking Type
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Label("Progress Tracking", systemImage: "target")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        HStack(spacing: AppSpacing.sm) {
                            OptionButton(
                                title: "Kilograms",
                                isSelected: selectedMetric == .kg,
                                action: {
                                    selectedMetric = .kg
                                    checkpointValue = 1.0
                                }
                            )

                            OptionButton(
                                title: "Percent",
                                isSelected: selectedMetric == .percent,
                                action: {
                                    selectedMetric = .percent
                                    checkpointValue = 5
                                }
                            )
                        }
                    }

                    // Checkpoint Value with Wheel Picker
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Label("Checkpoint Value", systemImage: "slider.horizontal.3")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        ValueWheelPicker(
                            value: $checkpointValue,
                            type: selectedMetric == .kg ? .kg : .percent
                        )

                        Text(selectedMetric == .kg
                            ? "Unlock reward every \(formatValue(checkpointValue)) kg lost"
                            : "Unlock reward every \(Int(checkpointValue))% of progress")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Reward Type
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Label("Reward Type", systemImage: "gift.fill")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        HStack(spacing: AppSpacing.sm) {
                            OptionButton(
                                title: "Cheat Meals",
                                isSelected: selectedRewardType == .meals,
                                action: {
                                    selectedRewardType = .meals
                                    rewardAmount = 1
                                }
                            )

                            OptionButton(
                                title: "Free Days",
                                isSelected: selectedRewardType == .days,
                                action: {
                                    selectedRewardType = .days
                                    rewardAmount = 1
                                }
                            )
                        }
                    }

                    // Reward Amount with Wheel Picker
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Label("Amount per Checkpoint", systemImage: "number")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        AmountWheelPicker(
                            amount: $rewardAmount,
                            type: selectedRewardType == .meals ? .meals : .days
                        )

                        Text("How many \(selectedRewardType == .meals ? "cheat meals" : "free days") per checkpoint")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Summary
                    SettingsSummaryCard(
                        metric: selectedMetric,
                        value: checkpointValue,
                        rewardType: selectedRewardType,
                        rewardAmount: rewardAmount
                    )
                }
                .padding(AppSpacing.md)
            }
            .background(AppColors.background)
            .navigationTitle("Checkpoint Rules")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(selectedMetric, checkpointValue, selectedRewardType, rewardAmount)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func formatValue(_ val: Double) -> String {
        if val == val.rounded() {
            return String(format: "%.0f", val)
        }
        return String(format: "%.1f", val)
    }
}

// MARK: - Summary Card

struct SettingsSummaryCard: View {
    let metric: CheckpointMetric
    let value: Double
    let rewardType: RewardType
    let rewardAmount: Int

    private func formatValue(_ val: Double) -> String {
        if val == val.rounded() {
            return String(format: "%.0f", val)
        }
        return String(format: "%.1f", val)
    }

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("Summary")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: AppSpacing.xs) {
                Text(metric == .kg ? "\(formatValue(value)) kg" : "\(Int(value))%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.accent)

                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)

                Text("\(rewardAmount) \(rewardType == .meals ? (rewardAmount == 1 ? "cheatmeal" : "cheatmeals") : (rewardAmount == 1 ? "free day" : "free days"))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

#Preview {
    CheckpointSettingsSheet(
        journey: Journey(
            startWeight: 85,
            goalWeight: 70,
            checkpointMetric: .kg,
            checkpointValue: 2.0,
            rewardType: .meals,
            mealsCount: 1,
            cheatmealDuration: 4
        ),
        onSave: { _, _, _, _ in }
    )
    .preferredColorScheme(.dark)
}
