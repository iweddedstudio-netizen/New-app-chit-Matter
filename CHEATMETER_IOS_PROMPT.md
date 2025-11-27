# CheatMeter iOS - Промпт для создания приложения

## Описание проекта

Создай iOS приложение **CheatMeter** на Swift — компаньон для похудения с геймификацией. Суть: пользователь теряет вес, достигает контрольных точек (checkpoints), и получает награды в виде "читмилов" — разрешённых вкусных приёмов пищи.

**Локальная база данных, без аккаунтов, без сервера.**

---

## Рекомендуемый стек

- **Язык:** Swift 5.9+
- **UI:** SwiftUI
- **Минимальная iOS:** 17.0
- **Архитектура:** MVVM + Repository Pattern
- **База данных:** SwiftData
- **Графики:** Swift Charts
- **Навигация:** NavigationStack
- **Иконки:** SF Symbols

---

## Цветовая схема (iOS Dark Theme)

| Название | Цвет |
|----------|------|
| Background | #000000 |
| Card | #1C1C1E |
| Accent | #34C759 (iOS Green) |
| Destructive | #FF453A (iOS Red) |
| Muted | #2C2C2E |
| Border | #3A3A3C |
| Secondary | #8E8E93 |

---

## Структура проекта

```
CheatMeter/
├── App/
├── Models/
├── Views/
│   ├── Onboarding/
│   ├── Main/
│   ├── Components/
│   └── Modals/
├── ViewModels/
├── Services/
├── Utilities/
└── Resources/
```

---

## Модели данных (SwiftData)

### Journey (Путь похудения)
- id: UUID
- startWeight: Double (кг)
- goalWeight: Double (кг)
- checkpointMetric: enum (kg, percent, micro)
- checkpointValue: Double
- rewardType: enum (meals, days)
- mealsCount: Int? (1-3 читмила)
- daysCount: Int? (дней на читмил)
- cheatmealDuration: Int (часы длительности читмила)
- isActive: Bool
- completedCheckpoints: Int
- startDate: Date
- endDate: Date?
- Связи: weightEntries, cheatmeals, slips, measurements

### WeightEntry (Запись веса)
- id: UUID
- weight: Double (кг)
- date: Date
- note: String?
- journey: связь с Journey

### Cheatmeal (Читмил)
- id: UUID
- status: enum (locked, available, active, completed)
- checkpointNumber: Int
- weightAtUnlock: Double
- activatedAt: Date?
- completedAt: Date?
- expiresAt: Date?
- note: String?
- photoData: Data?
- journey: связь с Journey

### Slip (Срыв)
- id: UUID
- food: String (что съел)
- date: Date
- note: String?
- journey: связь с Journey

### MeasurementEntry (Замеры тела)
- id: UUID
- date: Date
- weight: Double
- chest, waist, hips, shoulders, thighs, calves, arms, neck: Double? (см)
- journey: связь с Journey

### Recipe (Рецепт)
- id: UUID
- name, description, category: String
- calories, protein, carbs, fat: Int
- ingredients, instructions: String
- imageURL: String?
- isFavorite: Bool
- isUserCreated: Bool

### Achievement (Достижение)
- id: String
- category: enum (weight, checkpoints, consistency, milestones)
- name, description: String
- iconName: String (SF Symbol)
- rarity: enum (common, rare, epic, legendary)
- targetValue: Double
- currentProgress: Double
- isUnlocked: Bool
- unlockedAt: Date?

### UserSettings (Настройки)
- weightUnit: enum (kg, lbs)
- heightUnit: enum (cm, ft)
- gender: enum (male, female, other)
- age: Int
- height: Double (см)
- birthday: Date?
- hasCompletedOnboarding: Bool

---

## Экраны и функционал

### 1. Онбординг (4 экрана)

**WelcomeView**
- Логотип и приветствие
- Краткое описание концепции приложения
- Кнопка "Начать"

**BasicInfoView**
- Пол (male/female/other)
- Возраст (picker)
- Рост (см или футы/дюймы)
- Текущий вес
- Целевой вес
- Дата рождения (опционально)

**SetupView** (настройка программы)
- Тип метрики checkpoint:
  - По килограммам (каждые X кг)
  - По проценту от цели (каждые X%)
  - Микро-чекпоинты (каждые 500г)
- Значение checkpoint (слайдер или picker)
- Тип награды:
  - Количество читмилов за checkpoint (1-3)
  - Или дни на читмил
- Длительность активного читмила (в часах: 2, 4, 8, 12, 24)

**ReviewView**
- Сводка всех настроек
- Визуальный расчёт: сколько checkpoints до цели
- Предпросмотр: "Вам нужно сбросить X кг → это Y чекпоинтов → Z читмилов"
- Кнопка "Начать путь"

---

### 2. Dashboard (Главный экран)

**JourneyOverviewCard**
- Круговой прогресс (текущий вес → цель)
- Процент выполнения
- Сброшено кг
- Дней в пути
- BMI

**NextCheatmealCard**
- Прогресс-бар до следующего checkpoint
- Вес последнего checkpoint → текущий вес → следующий checkpoint
- Анимация при приближении к цели
- Кнопка "Записать вес"

**QuickStats**
- Срывов всего
- Читмилов использовано
- Дней без срывов (streak)

**QuickActions (кнопки)**
- Записать вес → WeightEntrySheet
- Добавить замеры → MeasurementsSheet
- Записать срыв → SlipSheet

---

### 3. Analytics (Аналитика)

**3 таба:**
1. **Weight** — график веса (линейный)
2. **Body** — сравнение замеров
3. **Slips** — таймлайн срывов

**Фильтр времени:** Неделя / Месяц / 3 месяца / Всё время

---

### 4. Food Diary (Дневник еды)

**Список рецептов**
- Название, категория, калории
- Поиск по названию
- Фильтр избранного
- Кнопка добавить рецепт

**Детали рецепта**
- КБЖУ (калории, белки, жиры, углеводы)
- Ингредиенты
- Инструкция
- Добавить в избранное

---

### 5. Body Tracking (Замеры тела)

**Силуэт тела** (мужской/женский)
- Интерактивные точки на теле
- При нажатии — показать историю замеров

**История замеров**
- Список всех checkpoint замеров
- Сравнение: выбрать 2 даты и сравнить

**Добавить замеры**
- 8 полей: грудь, талия, бёдра, плечи, бёдра (ноги), икры, руки, шея

---

### 6. Profile (Профиль)

**Статистика пользователя**
- Дней в пути
- Всего сброшено
- Checkpoints пройдено
- Читмилов заработано

**Меню:**
- Достижения → AchievementsView
- Настройки → SettingsView
- О приложении

---

### 7. Achievements (Достижения)

**Weight Loss (Потеря веса):**
- First Steps — сбросить 1 кг
- Getting Started — сбросить 5 кг
- Halfway Hero — 50% цели
- Almost There — 75% цели
- Goal Crusher — 100% цели
- Overachiever — превысить цель на 5%

**Checkpoints:**
- First Milestone — первый checkpoint
- Checkpoint Master — 5 checkpoints
- Unstoppable — 10 checkpoints

**Consistency (Постоянство):**
- Week Warrior — 7 дней записей подряд
- Month Master — 30 дней записей
- Clean Streak — 14 дней без срывов

**Milestones:**
- Journey Beginner — 7 дней в пути
- Journey Veteran — 30 дней в пути
- Journey Legend — 100 дней в пути

---

## Логика Checkpoint системы

1. При записи нового веса вычисляем сколько кг сброшено от startWeight
2. В зависимости от checkpointMetric считаем заработанные checkpoints:
   - kg: weightLost / checkpointValue
   - percent: (weightLost / totalToLose * 100) / checkpointValue
   - micro: weightLost / 0.5
3. Если новых checkpoints больше чем completedCheckpoints — разблокируем читмилы
4. Показываем celebration модал
5. Читмил переходит в статус "available"

**Жизненный цикл читмила:**
- locked → available (при достижении checkpoint)
- available → active (пользователь активирует)
- active → completed (истекло время или пользователь завершил)

---

## Модальные окна

- **WeightEntrySheet** — дата, вес, заметка
- **SlipSheet** — что съел, дата, заметка
- **MeasurementsSheet** — 8 полей замеров
- **CheatmealActivationSheet** — подтверждение активации читмила
- **CelebrationSheet** — анимация при достижении checkpoint

---

## Навигация

- **Главная навигация:** TabView с 5 табами (Home, Analytics, Food, Body, Profile)
- **Онбординг:** NavigationStack с 4 экранами
- **Модалки:** .sheet() для всех модальных окон

---

## Что НЕ включено

- AI Coach
- Синхронизация между устройствами
- Аккаунты и авторизация

---

## Порядок разработки

1. Настройка проекта — SwiftData, структура папок
2. Модели данных — все @Model классы
3. Онбординг — 4 экрана + сохранение настроек
4. Dashboard — основной экран с картами
5. Запись веса — модальное окно + логика checkpoint
6. Читмил система — разблокировка, активация, завершение
7. Analytics — графики Swift Charts
8. Body Tracking — замеры тела + силуэт
9. Food Diary — рецепты + избранное
10. Achievements — система достижений
11. Полировка UI — анимации, celebrations

---

## Дополнительные рекомендации

- Тёмная тема по умолчанию
- Haptic Feedback при достижениях
- Поддержка Dynamic Type для accessibility
