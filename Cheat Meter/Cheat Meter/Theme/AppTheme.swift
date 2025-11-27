import SwiftUI

// MARK: - App Colors

enum AppColors {
    // Primary
    static let accent = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let accentLight = Color(red: 0.55, green: 0.89, blue: 0.64)
    static let accentDark = Color(red: 0.07, green: 0.18, blue: 0.1)
    static let accentBackground = Color(red: 0.09, green: 0.23, blue: 0.13)

    // Semantic
    static let success = accent
    static let error = Color(red: 1, green: 0.23, blue: 0.19)
    static let warning = Color(red: 1, green: 0.62, blue: 0.04)

    // Gradient colors (for progress bar)
    static let gradientRed = Color(red: 1, green: 0.27, blue: 0.23)
    static let gradientOrange = Color(red: 1, green: 0.62, blue: 0.04)
    static let gradientYellow = Color(red: 1, green: 0.84, blue: 0.04)
    static let gradientGreen = accent

    // Background
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)

    // Separator
    static let separator = Color(uiColor: .separator)

    // Text
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary = Color(white: 0.5)
}

// MARK: - App Spacing

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
}

// MARK: - App Corner Radius

enum AppRadius {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 10
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
}

// MARK: - App Font Sizes

enum AppFontSize {
    static let caption2: CGFloat = 10
    static let caption: CGFloat = 12
    static let subheadline: CGFloat = 14
    static let body: CGFloat = 16
    static let headline: CGFloat = 17
    static let title3: CGFloat = 20
    static let title2: CGFloat = 22
    static let title: CGFloat = 28
    static let largeTitle: CGFloat = 34

    // Special sizes
    static let weightDisplay: CGFloat = 48
    static let weightDisplayLarge: CGFloat = 56
}

// MARK: - App Animation

enum AppAnimation {
    static let fast: Double = 0.15
    static let normal: Double = 0.25
    static let slow: Double = 0.5
    static let progress: Double = 1.2
}

// MARK: - Gradients

enum AppGradients {
    static let progress = LinearGradient(
        colors: [
            AppColors.gradientRed,
            AppColors.gradientOrange,
            AppColors.gradientYellow,
            AppColors.gradientGreen
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let fadeHorizontal = LinearGradient(
        colors: [.clear, AppColors.separator, .clear],
        startPoint: .leading,
        endPoint: .trailing
    )
}
