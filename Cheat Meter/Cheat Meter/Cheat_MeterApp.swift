//
//  Cheat_MeterApp.swift
//  Cheat Meter
//
//  Created by Alex on 27.11.2025.
//

import SwiftUI
import SwiftData

@main
struct Cheat_MeterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Journey.self,
            WeightEntry.self,
            Cheatmeal.self,
            Slip.self,
            MeasurementEntry.self,
            Recipe.self,
            Achievement.self,
            UserSettings.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    initializeAchievements()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func initializeAchievements() {
        let context = sharedModelContainer.mainContext
        let service = AchievementsService(modelContext: context)
        service.initializeDefaultAchievements()
    }
}

// MARK: - Root View with Theme Support

struct RootView: View {
    @Query private var userSettings: [UserSettings]

    private var settings: UserSettings? {
        userSettings.first
    }

    private var colorScheme: ColorScheme? {
        guard let settings = settings else { return nil }
        switch settings.appTheme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var body: some View {
        ContentView()
            .preferredColorScheme(colorScheme)
    }
}
