import SwiftUI

struct ReviewView: View {
    var viewModel: OnboardingViewModel
    var onFinish: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Text("Ready to Start?")
                .font(.largeTitle)
                .bold()
                .padding(.top, AppSpacing.md)

            VStack(spacing: AppSpacing.md) {
                ReviewCard(title: "Goal", value: "\(Int(viewModel.weightToLose)) kg to lose", icon: "target")
                ReviewCard(title: "Checkpoints", value: "\(viewModel.totalCheckpoints) milestones", icon: "flag.fill")
                ReviewCard(title: "Rewards", value: "\(viewModel.totalRewards) \(viewModel.rewardType == .meals ? "meals" : "days")", icon: "gift.fill")
            }
            .padding(AppSpacing.md)

            Spacer()

            Text("You are about to begin your journey. Good luck!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(AppSpacing.md)

            PrimaryButton(title: "Start Journey", action: onFinish)
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.lg)
        }
    }
}

struct ReviewCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppColors.accent)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
}

#Preview {
    ReviewView(viewModel: OnboardingViewModel(), onFinish: {})
        .preferredColorScheme(.dark)
}
