import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var journeys: [Journey]
    @Query private var userSettings: [UserSettings]

    var currentJourney: Journey? {
        journeys.sorted(by: { $0.startDate > $1.startDate }).first
    }

    var settings: UserSettings? {
        userSettings.first
    }

    var body: some View {
        NavigationStack {
            List {
                if let journey = currentJourney {
                    Section {
                        StatRow(label: "Days on Journey", value: "\(daysOnJourney(journey))")
                        StatRow(label: "Total Lost", value: String(format: "%.1f kg", totalLost(journey)))
                        StatRow(label: "Checkpoints Reached", value: "\(journey.completedCheckpoints)")
                        StatRow(label: "Cheat Meals Earned", value: "\(journey.cheatmeals.count)")
                    }
                }

                Section("Features") {
                    NavigationLink {
                        AchievementsView()
                    } label: {
                        Label("Achievements", systemImage: "trophy.fill")
                    }
                }

                Section("Appearance") {
                    if let settings = settings {
                        Picker(selection: Binding(
                            get: { settings.appTheme },
                            set: { newValue in
                                settings.appTheme = newValue
                                try? modelContext.save()
                            }
                        )) {
                            Text("System").tag(AppTheme.system)
                            Text("Light").tag(AppTheme.light)
                            Text("Dark").tag(AppTheme.dark)
                        } label: {
                            Label("Theme", systemImage: "circle.lefthalf.filled")
                        }
                    }
                }

                Section("App") {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                    }

                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "info.circle.fill")
                    }
                }
            }
            .navigationTitle("Profile")
            .padding(.bottom, 60)
        }
    }

    private func daysOnJourney(_ journey: Journey) -> Int {
        Calendar.current.dateComponents([.day], from: journey.startDate, to: Date()).day ?? 0
    }

    private func totalLost(_ journey: Journey) -> Double {
        let currentWeight = journey.weightEntries.sorted(by: { $0.date > $1.date }).first?.weight ?? journey.startWeight
        return journey.startWeight - currentWeight
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userSettings: [UserSettings]

    var settings: UserSettings? {
        userSettings.first
    }

    var body: some View {
        List {
            if let settings = settings {
                Section("Units") {
                    Picker(selection: Binding(
                        get: { settings.weightUnit },
                        set: { newValue in
                            settings.weightUnit = newValue
                            try? modelContext.save()
                        }
                    )) {
                        Text("Kilograms (kg)").tag(WeightUnit.kg)
                        Text("Pounds (lbs)").tag(WeightUnit.lbs)
                    } label: {
                        Label("Weight", systemImage: "scalemass.fill")
                    }

                    Picker(selection: Binding(
                        get: { settings.heightUnit },
                        set: { newValue in
                            settings.heightUnit = newValue
                            try? modelContext.save()
                        }
                    )) {
                        Text("Centimeters (cm)").tag(HeightUnit.cm)
                        Text("Feet & Inches (ft)").tag(HeightUnit.ft)
                    } label: {
                        Label("Height", systemImage: "ruler.fill")
                    }
                }

                Section("Personal") {
                    HStack {
                        Label("Height", systemImage: "figure.stand")
                        Spacer()
                        Text("\(Int(settings.height)) cm")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - About View

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(AppColors.accent)

                    Text("CheatMeter")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.lg)
            }

            Section {
                Text("CheatMeter helps you lose weight by rewarding your progress with cheat meals. Set checkpoints, reach your goals, and enjoy your well-deserved rewards!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .bold()
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [Journey.self, UserSettings.self], inMemory: true)
        .preferredColorScheme(.dark)
}
