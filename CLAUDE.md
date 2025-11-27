# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CheatMeter is an iOS weight loss companion app with gamification. Users lose weight, reach checkpoints, and earn "cheat meals" as rewards. All data is stored locally using SwiftData - no accounts, no server sync.

## Tech Stack

- Swift 5.9+, SwiftUI, iOS 17.0+
- SwiftData for persistence
- Swift Charts for graphs
- MVVM + Repository Pattern
- SF Symbols for icons

## Build & Run

Open `Cheat Meter/Cheat Meter.xcodeproj` in Xcode and run on simulator or device.

```bash
# Run tests
xcodebuild test -project "Cheat Meter/Cheat Meter.xcodeproj" -scheme "Cheat Meter" -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

### Data Flow
`ContentView` checks `UserSettings.hasCompletedOnboarding` to show either:
- `OnboardingContainerView` (4-step flow) for new users
- `TabView` with 5 tabs (Dashboard, Analytics, Food, Body, Profile) for returning users

### SwiftData Models
All models are `@Model` classes defined in `Cheat Meter/Cheat Meter/Models/`:

- **Journey** - Core entity. Has relationships to WeightEntry, Cheatmeal, Slip, MeasurementEntry
- **WeightEntry** - Weight recordings linked to Journey
- **Cheatmeal** - Reward with lifecycle: locked → available → active → completed
- **Slip** - Unplanned cheat meals (tracking "failures")
- **MeasurementEntry** - Body measurements (8 body parts)
- **Recipe** - Food recipes with KBJU (calories/protein/carbs/fat)
- **Achievement** - Gamification badges with categories and rarity
- **UserSettings** - User preferences and onboarding state

### ViewModels
Located in `Cheat Meter/Cheat Meter/ViewModels/`. Each uses `@Observable` and receives `ModelContext` for SwiftData operations.

### Checkpoint System
When weight is logged, `DashboardViewModel.checkCheckpoints()` calculates earned checkpoints based on metric type (kg/percent/micro) and unlocks Cheatmeals accordingly.

## Color Scheme (Dark Theme Default)

| Name | Hex |
|------|-----|
| Background | #000000 |
| Card | #1C1C1E |
| Accent | #34C759 (iOS Green) |
| Destructive | #FF453A |
| Border | #3A3A3C |

## Key Files

- `Cheat_MeterApp.swift` - App entry, ModelContainer setup, achievement initialization
- `ContentView.swift` - Root navigation (onboarding vs main tabs)
- `Services/AchievementsService.swift` - Achievement tracking and unlocking logic
- `ViewModels/DashboardViewModel.swift` - Core weight entry and checkpoint logic
