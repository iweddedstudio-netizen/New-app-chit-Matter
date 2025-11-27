import SwiftUI
import Charts

struct WeightChart: View {
    let entries: [WeightEntry]
    let goalWeight: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weight Trend")
                .font(.headline)
            
            if entries.isEmpty {
                ContentUnavailableView("No Data", systemImage: "chart.xyaxis.line", description: Text("Log your weight to see the chart."))
                    .frame(height: 250)
            } else {
                Chart {
                    RuleMark(y: .value("Goal", goalWeight))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(AppColors.accent)
                        .annotation(position: .leading) {
                            Text("Goal")
                                .font(.caption)
                                .foregroundStyle(AppColors.accent)
                        }

                    ForEach(entries) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(AppColors.accent)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(AppColors.accent)
                    }
                }
                .frame(height: 250)
                .chartYScale(domain: .automatic(includesZero: false))
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

#Preview {
    WeightChart(entries: [], goalWeight: 70)
        .preferredColorScheme(.dark)
}
