import SwiftUI

struct WelcomeView: View {
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()

            Image(systemName: "trophy.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.yellow)
                .padding(AppSpacing.md)
                .background(
                    Circle()
                        .fill(Color.yellow.opacity(0.2))
                        .frame(width: 180, height: 180)
                )

            VStack(spacing: AppSpacing.md) {
                Text("Welcome to CheatMeter")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("Your personal weight loss companion. Earn cheat meals by reaching your goals.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.md)
            }

            Spacer()

            PrimaryButton(title: "Get Started", action: onNext)
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.lg)
        }
        .padding(AppSpacing.md)
    }
}

#Preview {
    WelcomeView(onNext: {})
        .preferredColorScheme(.dark)
}
