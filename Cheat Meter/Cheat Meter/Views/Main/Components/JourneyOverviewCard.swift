import SwiftUI

struct JourneyOverviewCard: View {
    let currentWeight: Double
    let startWeight: Double
    let goalWeight: Double
    let height: Double?
    let daysWithoutSlips: Int
    let stepsDone: Int
    let stepsTotal: Int
    let slipsTotal: Int

    private var weightLost: Double {
        startWeight - currentWeight
    }

    private var progress: Double {
        let totalToLose = startWeight - goalWeight
        guard totalToLose > 0 else { return 0 }
        return min(max(weightLost / totalToLose, 0), 1)
    }

    private var toGoal: Double {
        currentWeight - goalWeight
    }

    private var bmi: Double? {
        guard let h = height, h > 0 else { return nil }
        let heightInMeters = h / 100
        return currentWeight / (heightInMeters * heightInMeters)
    }

    private var bmiCategory: String {
        guard let bmi = bmi else { return "" }
        if bmi >= 40 { return " (Obesity III)" }
        if bmi >= 35 { return " (Obesity II)" }
        if bmi >= 30 { return " (Obesity I)" }
        if bmi >= 25 { return " (Overweight)" }
        if bmi >= 18.5 { return " (Normal)" }
        return " (Underweight)"
    }

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Current Weight - Large Centered
            VStack(spacing: AppSpacing.xxs) {
                Text(String(format: "%.1f", currentWeight))
                    .font(.system(size: AppFontSize.weightDisplayLarge, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("kg")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                if let bmi = bmi {
                    Text("BMI \(String(format: "%.1f", bmi))\(bmiCategory)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.top, AppSpacing.xxs)
                }
            }

            // Lost Badge
            HStack(spacing: 6) {
                Image(systemName: "arrow.down.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("LOST: \(String(format: "%.1f", weightLost)) kg")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(AppColors.accent)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
            .background(AppColors.accent.opacity(0.15))
            .clipShape(Capsule())

            // Divider
            FadeDivider()

            // Stats Row
            StatsRowView(
                daysWithoutSlips: daysWithoutSlips,
                stepsDone: stepsDone,
                stepsTotal: stepsTotal,
                slipsTotal: slipsTotal
            )

            // Progress Section
            VStack(spacing: AppSpacing.sm) {
                // To Go indicator
                VStack(spacing: 2) {
                    Text("To Go")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xxs) {
                        Text(String(format: "%.1f", toGoal))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Text("kg")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // Progress Bar with Start/Goal
                HStack(alignment: .top, spacing: 0) {
                    // Start
                    VStack(spacing: AppSpacing.xxs) {
                        Text("Start")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        Text("\(String(format: "%.0f", startWeight))kg")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }

                    // Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(AppGradients.progress)
                                .frame(height: 4)

                            Circle()
                                .fill(.primary)
                                .frame(width: 12, height: 12)
                                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                                .offset(x: geometry.size.width * progress - 6)
                                .animation(.easeOut(duration: AppAnimation.progress), value: progress)
                        }
                    }
                    .frame(height: 12)
                    .padding(.horizontal, AppSpacing.sm)

                    // Goal
                    VStack(spacing: AppSpacing.xxs) {
                        Text("Goal")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        Text("\(String(format: "%.0f", goalWeight))kg")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.accent)
                    }
                }
            }
            .padding(.top, AppSpacing.xs)
        }
        .padding(AppSpacing.lg)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xxl))
    }
}

// MARK: - Stats Row Component

struct StatsRowView: View {
    let daysWithoutSlips: Int
    let stepsDone: Int
    let stepsTotal: Int
    let slipsTotal: Int

    var body: some View {
        HStack(spacing: 0) {
            StatItemCompact(
                value: "\(daysWithoutSlips)",
                label: "Discipline days",
                valueColor: .primary
            )

            Divider()
                .frame(height: 40)
                .padding(.horizontal, AppSpacing.xs)

            HStack(spacing: 2) {
                Text("\(stepsDone)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text("/")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Text("\(stepsTotal)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.accent)
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottom) {
                Text("Steps")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .offset(y: AppSpacing.md)
            }

            Divider()
                .frame(height: 40)
                .padding(.horizontal, AppSpacing.xs)

            StatItemCompact(
                value: "\(slipsTotal)",
                label: "Slips total",
                valueColor: AppColors.error
            )
        }
        .padding(.vertical, AppSpacing.sm)
        .padding(.horizontal, AppSpacing.md)
        .background(AppColors.tertiaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

struct StatItemCompact: View {
    let value: String
    let label: String
    let valueColor: Color

    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(valueColor)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    JourneyOverviewCard(
        currentWeight: 77.5,
        startWeight: 85.0,
        goalWeight: 70.0,
        height: 178,
        daysWithoutSlips: 12,
        stepsDone: 3,
        stepsTotal: 15,
        slipsTotal: 2
    )
    .padding()
    .preferredColorScheme(.dark)
}
