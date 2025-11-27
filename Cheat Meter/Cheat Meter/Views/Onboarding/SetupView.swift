import SwiftUI

struct SetupView: View {
    @Bindable var viewModel: OnboardingViewModel
    var onNext: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Checkpoint Strategy"), footer: Text("Choose how you want to track your progress.")) {
                Picker("Metric", selection: $viewModel.checkpointMetric) {
                    Text("Every X kg").tag(CheckpointMetric.kg)
                    Text("Percentage").tag(CheckpointMetric.percent)
                    Text("Micro (500g)").tag(CheckpointMetric.micro)
                }

                if viewModel.checkpointMetric == .kg {
                    HStack {
                        Text("Checkpoint every (kg)")
                        Spacer()
                        TextField("Value", value: $viewModel.checkpointValue, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                } else if viewModel.checkpointMetric == .percent {
                    HStack {
                        Text("Checkpoint every (%)")
                        Spacer()
                        TextField("Value", value: $viewModel.checkpointValue, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
            }

            Section(header: Text("Rewards"), footer: Text("Define your reward for reaching a checkpoint.")) {
                Picker("Reward Type", selection: $viewModel.rewardType) {
                    Text("Cheat Meals").tag(RewardType.meals)
                    Text("Cheat Days").tag(RewardType.days)
                }

                if viewModel.rewardType == .meals {
                    Stepper(value: $viewModel.mealsCount, in: 1...3) {
                        HStack {
                            Text("Meals per checkpoint")
                            Spacer()
                            Text("\(viewModel.mealsCount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Stepper(value: $viewModel.daysCount, in: 1...3) {
                        HStack {
                            Text("Days per checkpoint")
                            Spacer()
                            Text("\(viewModel.daysCount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Picker("Active Duration", selection: $viewModel.cheatmealDuration) {
                    Text("2 Hours").tag(2)
                    Text("4 Hours").tag(4)
                    Text("8 Hours").tag(8)
                    Text("12 Hours").tag(12)
                    Text("24 Hours").tag(24)
                }
            }

            Section {
                Button(action: onNext) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(AppColors.accent)
                }
            }
        }
        .navigationTitle("Program Setup")
    }
}

#Preview {
    NavigationStack {
        SetupView(viewModel: OnboardingViewModel(), onNext: {})
            .preferredColorScheme(.dark)
    }
}
