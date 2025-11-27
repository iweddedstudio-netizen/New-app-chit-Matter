//
//  ContentView.swift
//  Cheat Meter
//
//  Created by Alex on 27.11.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userSettings: [UserSettings]

    @State private var selectedTab: TabItem = .home
    @State private var showBodyActionSheet = false
    @State private var showWeightEntrySheet = false
    @State private var showMeasurementsSheet = false

    var body: some View {
        if let settings = userSettings.first, settings.hasCompletedOnboarding {
            MainTabView(
                selectedTab: $selectedTab,
                showBodyActionSheet: $showBodyActionSheet,
                showWeightEntrySheet: $showWeightEntrySheet,
                showMeasurementsSheet: $showMeasurementsSheet
            )
        } else {
            OnboardingContainerView()
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: TabItem
    @Binding var showBodyActionSheet: Bool
    @Binding var showWeightEntrySheet: Bool
    @Binding var showMeasurementsSheet: Bool

    var body: some View {
        ZStack {
            // Content
            Group {
                switch selectedTab {
                case .home:
                    DashboardView()
                case .analytics:
                    AnalyticsView()
                case .add:
                    // FAB handles this, show home
                    DashboardView()
                case .body:
                    MeasurementsView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Tab Bar
            VStack {
                Spacer()
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onFABTap: {
                        showBodyActionSheet = true
                    }
                )
            }
            .ignoresSafeArea(.keyboard)

            // Body Action Sheet
            if showBodyActionSheet {
                BodyActionSheet(
                    isPresented: $showBodyActionSheet,
                    onRecordWeight: {
                        showWeightEntrySheet = true
                    },
                    onRecordMeasurements: {
                        showMeasurementsSheet = true
                    }
                )
                .transition(.opacity)
                .zIndex(100)
            }
        }
        .sheet(isPresented: $showWeightEntrySheet) {
            WeightEntrySheet(journey: nil)
        }
        .sheet(isPresented: $showMeasurementsSheet) {
            MeasurementInputSheet(viewModel: MeasurementsViewModel())
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Journey.self, UserSettings.self], inMemory: true)
        .preferredColorScheme(.dark)
}
