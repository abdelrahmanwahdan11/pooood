# Mind Mirror

Mind Mirror recreates the UX of the "Mind Mirror – AI Personality Testing" Behance project using Flutter, Material 3, and GetX. The application ships with Arabic/English localisation, light and dark themes, quiz logic for the OCEAN model, emotion insights, and comparison flows.

## Getting started

```bash
flutter pub get
flutter run
```

The project targets Android, iOS, Web, macOS, and Windows with a shared codebase. Minimum Android SDK is 21.

## Features

- Onboarding narrative with gradients and smooth page indicators.
- Splash screen with animated entry.
- Mock authentication screens for sign in, sign up, and password reset.
- Personality quiz covering the five OCEAN traits with a progress ring and Likert scale.
- Animated results dashboard with fl_chart bars and per-trait coaching copy.
- Emotion chatbot with local NLP placeholder and emotion bar chart.
- Comparison flow using shareable six-digit codes and highlights.
- Settings module with instant locale/theme switches stored via `shared_preferences`.
- Responsive layouts that adapt to phones, tablets, and web/desktop with RTL support.
- Home hub redesigned around gradient cards, quick streaks, and a spotlight row for enabled experiments.
- Profile editing sheet with persisted name/email plus a reflection streak tracker.

### Experience Studio (30 feature toggles)

- Daily reflection reminders
- Weekly personality trends
- Emotion intensity heatmap inside insights
- Quick mood buttons for one-tap logging
- Breathing micro-coach before intense sessions
- Affirmation library aligned to OCEAN
- Social share cards for results
- Offline question bank for the quiz
- Theme scheduler (light/dark automation)
- Voice input for the chatbot
- Conversation history recalls
- Export report as PDF
- Comparison timeline snapshots
- Home screen widgets
- Assistant shortcuts (Siri/Assistant)
- Mindful haptics feedback
- Inline quiz tips
- Reverse scoring helper cues
- Reflection streak tracker with reset control
- Onboarding recaps on demand
- Avatar gallery picker
- High contrast mode for accessibility
- Reduce motion toggle
- Data control panel (text scaling clamp)
- Sleep-friendly dark mode
- Weekly notification digest
- Notebook integration export
- Custom question builder scaffolding
- Focus mode to minimise distractions
- Calendar sync reminders

## Language & Theme

Open **Settings** to switch between Arabic and English or toggle light/dark/system themes. Preferences are saved locally and restored on relaunch.

## Editing quiz questions

Questions live in `lib/app/data/repositories/quiz_repository.dart`. Update or extend the list; each question includes translations, a trait tag, and reverse scoring flag.

## Customising design

- Global colours and typography live in `lib/app/core/theme/app_theme.dart` and `lib/app/core/utils/app_colors.dart`.
- Update gradients and radii in the same files to match branding tweaks.
- Replace assets inside `assets/images/` and fonts within `assets/fonts/` for new visuals.

## Mock data

- Emotion cues and compare profiles live in `lib/app/data/repositories/insights_repository.dart` and `lib/app/data/repositories/compare_repository.dart`.
- Quiz scoring logic resides inside `lib/app/modules/quiz/controllers/quiz_controller.dart`.

## Notes

The app is architected using GetX bindings and controllers, keeping views declarative and lean. Replace mock repositories with API-powered data sources when integrating a backend.
