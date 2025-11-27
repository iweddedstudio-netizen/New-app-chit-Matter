import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case analytics
    case add // FAB
    case body
    case profile

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .analytics: return "chart.xyaxis.line"
        case .add: return "plus"
        case .body: return "figure.arms.open"
        case .profile: return "person.fill"
        }
    }

    var label: String {
        switch self {
        case .home: return "Home"
        case .analytics: return "Analytics"
        case .add: return ""
        case .body: return "Body"
        case .profile: return "Profile"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    let onFABTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                if tab == .add {
                    // FAB Button
                    FABButton(action: onFABTap)
                } else {
                    TabBarButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: { selectedTab = tab }
                    )
                }
            }
        }
        .padding(.horizontal, AppSpacing.xs)
        .padding(.top, AppSpacing.xs)
        .padding(.bottom, AppSpacing.xl)
        .background(
            AppColors.secondaryBackground
                .opacity(0.95)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AppColors.separator)
                .frame(height: 0.5)
        }
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xxs) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))
                    .fontWeight(isSelected ? .semibold : .regular)

                Text(tab.label)
                    .font(.system(size: 10))
                    .fontWeight(isSelected ? .semibold : .medium)
            }
            .foregroundStyle(isSelected ? .primary : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

struct FABButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(AppColors.accent)
                    .frame(width: 52, height: 52)
                    .shadow(color: AppColors.accent.opacity(0.4), radius: 8, y: 2)

                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
        .buttonStyle(FABButtonStyle())
        .frame(maxWidth: .infinity)
    }
}

struct FABButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: AppAnimation.fast), value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(
            selectedTab: .constant(.home),
            onFABTap: {}
        )
    }
    .preferredColorScheme(.dark)
}
