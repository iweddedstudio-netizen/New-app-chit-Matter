import SwiftUI
import SwiftData

struct MeasurementsView: View {
    @State private var viewModel = MeasurementsViewModel()
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddMeasurement = false
    @State private var showComparison = false
    @State private var comparisonEntries: (MeasurementEntry, MeasurementEntry)?
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.measurements.isEmpty {
                    ContentUnavailableView(
                        "No Measurements",
                        systemImage: "figure.arms.open",
                        description: Text("Add your first body measurement to track progress.")
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Comparison button (if enough data)
                            if viewModel.measurements.count >= 2 {
                                Button {
                                    if viewModel.measurements.count >= 2 {
                                        comparisonEntries = (viewModel.measurements[1], viewModel.measurements[0])
                                        showComparison = true
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "chart.bar.xaxis")
                                        Text("Compare Latest Two")
                                    }
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                            }
                            
                            ForEach(viewModel.measurements) { measurement in
                                MeasurementCard(measurement: measurement) {
                                    // Tap action (could open detail view)
                                } onDelete: {
                                    viewModel.deleteMeasurement(measurement)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Body Tracking")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddMeasurement = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadMeasurements()
            }
            .sheet(isPresented: $showAddMeasurement) {
                MeasurementInputSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $showComparison) {
                if let entries = comparisonEntries {
                    MeasurementComparisonView(earlier: entries.0, later: entries.1)
                }
            }
        }
    }
}

#Preview {
    MeasurementsView()
        .preferredColorScheme(.dark)
}
