# Phase 3: Dashboard & Core Logic

**Status:** ✅ Completed

## Objectives
Implement the main application loop: viewing progress, logging weight, and managing rewards.

## Tasks

### Dashboard UI
- [x] **DashboardView**: Main container.
- [x] **JourneyOverviewCard**: Visual progress bar and stats.
- [x] **NextCheatmealCard**: Progress towards the next specific reward.
- [x] **QuickStatsView**: Summary of slips and usage.
- [x] **QuickActions**: Buttons for logging.

### Core Features
- [x] **Weight Entry**: `WeightEntrySheet` with date and note.
- [x] **Checkpoint Logic**: Calculation of unlocked rewards based on weight loss.
- [x] **Reward System**:
    - [x] Unlock mechanism.
    - [x] Activation logic (timer start).
    - [x] `CheatmealActivationSheet`.
- [x] **Slips**: `SlipSheet` for recording diet deviations.
- [x] **Celebration**: `CelebrationSheet` when a checkpoint is hit.

## Notes
- The core loop is functional.
- Checkpoint logic supports re-calculation if historical data changes (basic implementation).
