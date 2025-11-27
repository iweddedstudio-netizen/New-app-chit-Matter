import SwiftUI

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background(isEnabled ? AppColors.accent : AppColors.accent.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Destructive Button

struct DestructiveButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background(isEnabled ? AppColors.error : AppColors.error.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
    }
}

// MARK: - Option Button (for settings/selection)

struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? AppColors.accent.opacity(0.15) : AppColors.tertiaryBackground)
                .foregroundStyle(isSelected ? AppColors.accent : .primary)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(isSelected ? AppColors.accent : AppColors.separator, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Card Container

struct CardContainer<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppSpacing.lg
    var cornerRadius: CGFloat = AppRadius.xxl

    init(padding: CGFloat = AppSpacing.lg, cornerRadius: CGFloat = AppRadius.xxl, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(AppColors.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Action Row Button (for sheets like BodyActionSheet)

struct ActionRowButton: View {
    let icon: String
    let title: String
    var iconColor: Color = AppColors.accent
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.tertiaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.separator, lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Divider Fade

struct FadeDivider: View {
    var body: some View {
        Rectangle()
            .fill(AppGradients.fadeHorizontal)
            .frame(height: 1)
    }
}

// MARK: - Preview

#Preview("Buttons") {
    VStack(spacing: 20) {
        PrimaryButton(title: "Save Weight") {}
        SecondaryButton(title: "Cancel") {}
        DestructiveButton(title: "Record Slip") {}

        HStack(spacing: 12) {
            OptionButton(title: "Kilograms", isSelected: true) {}
            OptionButton(title: "Percent", isSelected: false) {}
        }

        ActionRowButton(icon: "scalemass.fill", title: "Record Weight") {}

        CardContainer {
            Text("Card Content")
                .font(.headline)
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}
