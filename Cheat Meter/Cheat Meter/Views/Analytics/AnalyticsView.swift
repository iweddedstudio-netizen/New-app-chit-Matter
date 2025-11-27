import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @State private var viewModel = AnalyticsViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Time Range", selection: $viewModel.selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    WeightChart(entries: viewModel.filteredEntries, goalWeight: viewModel.goalWeight)
                    
                    StatsGrid(
                        totalLost: viewModel.totalLost,
                        bmi: viewModel.bmi,
                        streak: 0, // Placeholder
                        cheatmealsEarned: viewModel.journey?.completedCheckpoints ?? 0 // Simplified
                    )
                    
                    InsightsCard(
                        projectedWeight: viewModel.projectedWeightInMonth,
                        estimatedDate: viewModel.estimatedGoalDate
                    )
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadData()
            }
        }
    }
}

#Preview {
    AnalyticsView()
        .preferredColorScheme(.dark)
}
