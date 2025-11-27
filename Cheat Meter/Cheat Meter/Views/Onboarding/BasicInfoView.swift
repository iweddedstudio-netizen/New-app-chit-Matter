import SwiftUI

struct BasicInfoView: View {
    @Bindable var viewModel: OnboardingViewModel
    var onNext: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xxl) {
                // Header
                VStack(spacing: AppSpacing.xs) {
                    Text("Let's get started")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Tell us about yourself")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, AppSpacing.lg)

                // Gender Selection
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Gender")
                        .font(.headline)

                    HStack(spacing: AppSpacing.sm) {
                        GenderButton(
                            title: "Male",
                            icon: "figure.stand",
                            isSelected: viewModel.gender == .male,
                            action: { viewModel.gender = .male }
                        )

                        GenderButton(
                            title: "Female",
                            icon: "figure.stand.dress",
                            isSelected: viewModel.gender == .female,
                            action: { viewModel.gender = .female }
                        )

                        GenderButton(
                            title: "Other",
                            icon: "person.fill",
                            isSelected: viewModel.gender == .other,
                            action: { viewModel.gender = .other }
                        )
                    }
                }
                .padding(.horizontal, AppSpacing.md)

                // Height with Wheel Picker
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Height")
                        .font(.headline)

                    HeightWheelPicker(height: $viewModel.height)
                }
                .padding(.horizontal, AppSpacing.md)

                // Weight Goals with Wheel Picker
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Current Weight")
                        .font(.headline)

                    WeightWheelPicker(weight: $viewModel.currentWeight)
                }
                .padding(.horizontal, AppSpacing.md)

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Goal Weight")
                        .font(.headline)

                    WeightWheelPicker(weight: $viewModel.goalWeight)
                }
                .padding(.horizontal, AppSpacing.md)

                // Next Button
                PrimaryButton(title: "Next", action: onNext)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.lg)
            }
        }
        .background(AppColors.background)
        .navigationTitle("Basic Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Gender Button

struct GenderButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(isSelected ? AppColors.accent.opacity(0.15) : AppColors.secondaryBackground)
            .foregroundStyle(isSelected ? AppColors.accent : .primary)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(isSelected ? AppColors.accent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Height Wheel Picker

struct HeightWheelPicker: View {
    @Binding var height: Double

    private var heightInt: Int {
        Int(height)
    }

    private var heights: [Int] {
        Array(120...220)
    }

    var body: some View {
        HStack {
            Picker("", selection: Binding(
                get: { heightInt },
                set: { height = Double($0) }
            )) {
                ForEach(heights, id: \.self) { h in
                    Text("\(h) cm")
                        .tag(h)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
        }
    }
}

#Preview {
    NavigationStack {
        BasicInfoView(viewModel: OnboardingViewModel(), onNext: {})
            .preferredColorScheme(.dark)
    }
}
