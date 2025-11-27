# Phase 2: Onboarding Flow

**Status:** ✅ Completed

## Objectives
Create a smooth onboarding experience to collect user data and configure the app's mechanics (checkpoints, rewards).

## Tasks

### Views
- [x] **WelcomeView**: Introduction screen.
- [x] **BasicInfoView**: Collect gender, age, height, current weight, goal weight.
- [x] **SetupView**: Configure checkpoint metric (kg/%) and reward type (meals/days).
- [x] **ReviewView**: Summary and visual confirmation of the plan.
- [x] **OnboardingContainerView**: Navigation management.

### Logic
- [x] **OnboardingViewModel**: Temporary state management.
- [x] **Data Persistence**: Saving `Journey` and `UserSettings` to SwiftData upon completion.

## Notes
- Interface is strictly in English as requested.
- Logic handles different checkpoint strategies (kg, percent, micro).
