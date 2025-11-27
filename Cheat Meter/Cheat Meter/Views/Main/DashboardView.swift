import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Journey.startDate, order: .reverse) private var journeys: [Journey]
    @Query private var userSettings: [UserSettings]

    @State private var showWeightEntrySheet = false
    @State private var showSlipSheet = false
    @State private var showCheatmealActivationSheet = false
    @State private var showCelebrationSheet = false
    @State private var showSettingsSheet = false
    @State private var selectedCheatmeal: Cheatmeal?

    private var journey: Journey? { journeys.first }
    private var settings: UserSettings? { userSettings.first }

    // MARK: - Computed Properties

    private var currentWeight: Double {
        journey?.weightEntries.sorted(by: { $0.date > $1.date }).first?.weight ?? journey?.startWeight ?? 0
    }

    private var startWeight: Double { journey?.startWeight ?? 0 }
    private var goalWeight: Double { journey?.goalWeight ?? 0 }
    private var weightLost: Double { startWeight - currentWeight }
    private var userHeight: Double? { settings?.height }

    private var daysWithoutSlips: Int {
        guard let journey = journey else { return 0 }
        let sortedSlips = journey.slips.sorted(by: { $0.date > $1.date })
        guard let lastSlip = sortedSlips.first else {
            return Calendar.current.dateComponents([.day], from: journey.startDate, to: Date()).day ?? 0
        }
        return Calendar.current.dateComponents([.day], from: lastSlip.date, to: Date()).day ?? 0
    }

    private var stepsDone: Int { journey?.completedCheckpoints ?? 0 }

    private var stepsTotal: Int {
        guard let journey = journey else { return 0 }
        let totalToLose = journey.startWeight - journey.goalWeight
        guard totalToLose > 0 else { return 0 }

        switch journey.checkpointMetric {
        case .kg: return Int(ceil(totalToLose / journey.checkpointValue))
        case .percent: return Int(ceil(100 / journey.checkpointValue))
        case .micro: return Int(ceil(totalToLose / 0.5))
        }
    }

    private var slipsTotal: Int { journey?.slips.count ?? 0 }

    private var nextCheckpointWeight: Double {
        guard let journey = journey else { return 0 }
        let completed = journey.completedCheckpoints

        switch journey.checkpointMetric {
        case .kg:
            return journey.startWeight - (Double(completed + 1) * journey.checkpointValue)
        case .percent:
            let totalToLose = journey.startWeight - journey.goalWeight
            let kgPerCheckpoint = totalToLose * (journey.checkpointValue / 100.0)
            return journey.startWeight - (Double(completed + 1) * kgPerCheckpoint)
        case .micro:
            return journey.startWeight - (Double(completed + 1) * 0.5)
        }
    }

    private var lastCheckpointWeight: Double {
        guard let journey = journey else { return startWeight }
        let completed = journey.completedCheckpoints
        if completed == 0 { return journey.startWeight }

        switch journey.checkpointMetric {
        case .kg:
            return journey.startWeight - (Double(completed) * journey.checkpointValue)
        case .percent:
            let totalToLose = journey.startWeight - journey.goalWeight
            let kgPerCheckpoint = totalToLose * (journey.checkpointValue / 100.0)
            return journey.startWeight - (Double(completed) * kgPerCheckpoint)
        case .micro:
            return journey.startWeight - (Double(completed) * 0.5)
        }
    }

    private var hasUnlockedCheatmeal: Bool {
        journey?.cheatmeals.contains { $0.status == .available } ?? false
    }

    private var availableCheatmeals: [Cheatmeal] {
        journey?.cheatmeals.filter { $0.status == .available } ?? []
    }

    private var hasActiveCheatmeal: Bool {
        journey?.cheatmeals.contains { $0.status == .active } ?? false
    }

    private var activeCheatmeal: Cheatmeal? {
        journey?.cheatmeals.first { $0.status == .active }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                if let journey = journey {
                    if hasActiveCheatmeal, let activeCheatmeal = activeCheatmeal {
                        ActiveCheatmealBanner(cheatmeal: activeCheatmeal) {
                            selectedCheatmeal = activeCheatmeal
                            showCheatmealActivationSheet = true
                        }
                    } else {
                        NextCheatmealCard(
                            currentWeight: currentWeight,
                            nextCheckpointWeight: nextCheckpointWeight,
                            lastCheckpointWeight: lastCheckpointWeight,
                            checkpointMetric: journey.checkpointMetric,
                            checkpointValue: journey.checkpointValue,
                            rewardType: journey.rewardType,
                            rewardAmount: journey.rewardType == .meals ? (journey.mealsCount ?? 1) : (journey.daysCount ?? 1),
                            isUnlocked: hasUnlockedCheatmeal,
                            onOpenSettings: { showSettingsSheet = true },
                            onStartNewStep: hasUnlockedCheatmeal ? {
                                if let cheatmeal = availableCheatmeals.first {
                                    selectedCheatmeal = cheatmeal
                                    showCheatmealActivationSheet = true
                                }
                            } : nil
                        )
                    }

                    JourneyOverviewCard(
                        currentWeight: currentWeight,
                        startWeight: startWeight,
                        goalWeight: goalWeight,
                        height: userHeight,
                        daysWithoutSlips: daysWithoutSlips,
                        stepsDone: stepsDone,
                        stepsTotal: stepsTotal,
                        slipsTotal: slipsTotal
                    )

                    QuickActionsCard(
                        onLogWeight: { showWeightEntrySheet = true },
                        onLogSlip: { showSlipSheet = true },
                        onFood: { }
                    )
                } else {
                    ContentUnavailableView(
                        "No Active Journey",
                        systemImage: "flag.slash",
                        description: Text("Please complete onboarding to start.")
                    )
                }
            }
            .padding(AppSpacing.md)
            .padding(.bottom, 80)
        }
        .background(AppColors.background)
        .sheet(isPresented: $showWeightEntrySheet) {
            WeightEntrySheet(journey: journey)
        }
        .sheet(isPresented: $showSlipSheet) {
            SlipEntrySheet(journey: journey)
        }
        .sheet(isPresented: $showCheatmealActivationSheet) {
            if let cheatmeal = selectedCheatmeal {
                CheatmealActivationSheet(cheatmeal: cheatmeal)
            }
        }
        .sheet(isPresented: $showCelebrationSheet) {
            CelebrationSheet()
        }
        .sheet(isPresented: $showSettingsSheet) {
            if let journey = journey {
                CheckpointSettingsSheet(journey: journey) { metric, value, rewardType, rewardAmount in
                    updateJourneySettings(journey: journey, metric: metric, value: value, rewardType: rewardType, rewardAmount: rewardAmount)
                }
            }
        }
    }

    private func updateJourneySettings(journey: Journey, metric: CheckpointMetric, value: Double, rewardType: RewardType, rewardAmount: Int) {
        journey.checkpointMetric = metric
        journey.checkpointValue = value
        journey.rewardType = rewardType
        if rewardType == .meals {
            journey.mealsCount = rewardAmount
            journey.daysCount = nil
        } else {
            journey.daysCount = rewardAmount
            journey.mealsCount = nil
        }
        try? modelContext.save()
    }
}

// MARK: - Slip Entry Sheet

struct SlipEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let journey: Journey?

    @State private var food: String = ""
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("What did you eat?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("e.g. Pizza, Ice cream...", text: $food)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.xl)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Note (optional)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("How did it happen?", text: $note)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, AppSpacing.md)

                Spacer()

                DestructiveButton(title: "Record Slip", isEnabled: !food.isEmpty) {
                    saveSlip()
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.md)
            }
            .navigationTitle("Record Slip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private func saveSlip() {
        guard let journey = journey, !food.isEmpty else {
            dismiss()
            return
        }
        let slip = Slip(food: food, note: note.isEmpty ? nil : note, journey: journey)
        modelContext.insert(slip)
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Cheatmeal Activation Sheet

struct CheatmealActivationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let cheatmeal: Cheatmeal

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.orange)

                Text("Activate Cheatmeal?")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Once activated, your cheatmeal timer will start.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                VStack(spacing: AppSpacing.sm) {
                    PrimaryButton(title: "Activate Now") {
                        activateCheatmeal()
                    }

                    SecondaryButton(title: "Save for Later") {
                        dismiss()
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.md)
            }
            .navigationTitle("Cheatmeal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private func activateCheatmeal() {
        cheatmeal.status = .active
        cheatmeal.activatedAt = Date()
        if let journey = cheatmeal.journey {
            cheatmeal.expiresAt = Date().addingTimeInterval(TimeInterval(journey.cheatmealDuration * 3600))
        }
        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Active Cheatmeal Banner

struct ActiveCheatmealBanner: View {
    let cheatmeal: Cheatmeal
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("Cheatmeal Active")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text("Tap to track your progress")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .stroke(AppColors.separator, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Actions Card

struct QuickActionsCard: View {
    let onLogWeight: () -> Void
    let onLogSlip: () -> Void
    let onFood: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            QuickActionItem(icon: "scalemass.fill", label: "Weight", color: AppColors.accent, action: onLogWeight)
            QuickActionItem(icon: "xmark.circle.fill", label: "Slip", color: AppColors.error, action: onLogSlip)
            QuickActionItem(icon: "fork.knife", label: "Food", color: AppColors.accent, action: onFood)
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xxl))
    }
}

struct QuickActionItem: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)

                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Journey.self, UserSettings.self, WeightEntry.self, Cheatmeal.self, Slip.self], inMemory: true)
        .preferredColorScheme(.dark)
}
