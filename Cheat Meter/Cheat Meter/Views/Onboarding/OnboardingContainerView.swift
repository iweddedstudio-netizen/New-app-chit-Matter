import SwiftUI
import SwiftData

enum OnboardingStep {
    case welcome
    case basicInfo
    case setup
    case review
}

struct OnboardingContainerView: View {
    @State private var currentStep: OnboardingStep = .welcome
    @State private var viewModel = OnboardingViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                switch currentStep {
                case .welcome:
                    WelcomeView {
                        withAnimation {
                            currentStep = .basicInfo
                        }
                    }
                case .basicInfo:
                    BasicInfoView(viewModel: viewModel) {
                        withAnimation {
                            currentStep = .setup
                        }
                    }
                case .setup:
                    SetupView(viewModel: viewModel) {
                        withAnimation {
                            currentStep = .review
                        }
                    }
                case .review:
                    ReviewView(viewModel: viewModel) {
                        completeOnboarding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if currentStep != .welcome {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            goBack()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
    }
    
    private func goBack() {
        withAnimation {
            switch currentStep {
            case .welcome: break
            case .basicInfo: currentStep = .welcome
            case .setup: currentStep = .basicInfo
            case .review: currentStep = .setup
            }
        }
    }
    
    private func completeOnboarding() {
        viewModel.saveUserSettings()
        // In a real app, we would probably toggle a state in the main app view
        // For now, we rely on the data being saved and the main view reacting to it
    }
}

#Preview {
    OnboardingContainerView()
        .preferredColorScheme(.dark)
}
