import SwiftUI

struct InsightsCard: View {
    let projectedWeight: Double
    let estimatedDate: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Future You", systemImage: "sparkles")
                        .font(.caption)
                        .foregroundStyle(.purple)
                    
                    if projectedWeight > 0 {
                        Text("In 30 days you could weigh **\(String(format: "%.1f", projectedWeight)) kg**")
                            .font(.subheadline)
                    } else {
                        Text("Log more data to see predictions")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Label("Goal Date", systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(AppColors.accent)

                    if let date = estimatedDate {
                        Text("You could reach your goal by **\(date.formatted(date: .abbreviated, time: .omitted))**")
                            .font(.subheadline)
                    } else {
                        Text("Keep going to see estimate")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.md)
                .background(AppColors.accent.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

#Preview {
    InsightsCard(projectedWeight: 75.0, estimatedDate: Date().addingTimeInterval(86400 * 45))
        .padding()
        .preferredColorScheme(.dark)
}
