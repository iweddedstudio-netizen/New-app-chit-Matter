import SwiftUI

struct NextCheatmealCard: View {
    let currentWeight: Double
    let nextCheckpointWeight: Double
    let lastCheckpointWeight: Double
    let checkpointMetric: CheckpointMetric
    let checkpointValue: Double
    let rewardType: RewardType
    let rewardAmount: Int
    let isUnlocked: Bool
    let onOpenSettings: (() -> Void)?
    let onStartNewStep: (() -> Void)?

    private var progressPercent: Double {
        let totalRange = lastCheckpointWeight - nextCheckpointWeight
        guard totalRange > 0 else { return 0 }
        let currentProgress = lastCheckpointWeight - currentWeight
        return min(max(currentProgress / totalRange, 0), 1)
    }

    private var isApproaching: Bool {
        let remaining = currentWeight - nextCheckpointWeight
        return remaining < 0.5 && remaining > 0
    }

    private var rewardDescription: String {
        let metricText = checkpointMetric == .percent
            ? "\(String(format: "%.0f", checkpointValue))%"
            : "\(String(format: "%.1f", checkpointValue))kg"
        let rewardText = rewardType == .meals
            ? "\(rewardAmount) cheatmeal\(rewardAmount > 1 ? "s" : "")"
            : "\(rewardAmount) free day\(rewardAmount > 1 ? "s" : "")"
        return "\(metricText) → \(rewardText)"
    }

    var body: some View {
        ZStack {
            if isApproaching || isUnlocked {
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(AppColors.accent.opacity(0.1))
                    .blur(radius: 8)
                    .scaleEffect(1.05)
            }

            VStack(alignment: .leading, spacing: 0) {
                if isUnlocked {
                    unlockedContent
                } else {
                    normalContent
                }
            }
            .padding(AppSpacing.lg)
            .background(isUnlocked ? AppColors.accentDark : AppColors.accent)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .stroke(
                        isUnlocked ? AppColors.accent.opacity(0.3) : Color.clear,
                        lineWidth: 1
                    )
            )
        }
    }

    // MARK: - Normal State

    private var normalContent: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Next Cheatmeal at")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.8))

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(String(format: "%.1f", nextCheckpointWeight))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)

                        Text("kg")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }

                Spacer()

                if let onOpenSettings = onOpenSettings {
                    Button(action: onOpenSettings) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }
            }

            VStack(spacing: AppSpacing.md) {
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(height: 1)

                Text(rewardDescription)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(.white.opacity(0.3))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(.white)
                            .frame(width: geometry.size.width * progressPercent, height: 6)
                            .animation(.easeOut(duration: AppAnimation.progress), value: progressPercent)
                    }
                }
                .frame(height: 6)

                Text("Progress since last cheatmeal: \(Int(progressPercent * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }

    // MARK: - Unlocked State

    private var unlockedContent: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("Congratulations")
                        .font(.caption)
                        .foregroundStyle(Color(white: 0.8))

                    Text("Cheatmeal unlocked")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    HStack(spacing: AppSpacing.xxs) {
                        Text("Enjoy your")
                            .foregroundStyle(Color(white: 0.75))
                        Text("reward")
                            .foregroundStyle(AppColors.accentLight)
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                }

                Spacer()

                if let onOpenSettings = onOpenSettings {
                    Button(action: onOpenSettings) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundStyle(AppColors.accentLight)
                            .frame(width: 40, height: 40)
                            .background(AppColors.accentBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }
            }

            HStack(spacing: AppSpacing.sm) {
                if let onStartNewStep = onStartNewStep {
                    Button(action: onStartNewStep) {
                        Text("Start New Step")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.vertical, AppSpacing.sm)
                            .background(AppColors.accent)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }

                Button {
                    // Later action
                } label: {
                    Text("Later")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(white: 0.75))
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.sm)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .stroke(Color(white: 0.17), lineWidth: 1)
                        )
                }
            }
        }
    }
}

#Preview("Normal State") {
    NextCheatmealCard(
        currentWeight: 78.2,
        nextCheckpointWeight: 77.5,
        lastCheckpointWeight: 80.0,
        checkpointMetric: .kg,
        checkpointValue: 2.5,
        rewardType: .meals,
        rewardAmount: 1,
        isUnlocked: false,
        onOpenSettings: {},
        onStartNewStep: nil
    )
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Unlocked State") {
    NextCheatmealCard(
        currentWeight: 77.5,
        nextCheckpointWeight: 77.5,
        lastCheckpointWeight: 80.0,
        checkpointMetric: .kg,
        checkpointValue: 2.5,
        rewardType: .meals,
        rewardAmount: 1,
        isUnlocked: true,
        onOpenSettings: {},
        onStartNewStep: {}
    )
    .padding()
    .preferredColorScheme(.dark)
}
