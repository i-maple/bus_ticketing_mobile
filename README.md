# Ticket Booking Mobile App

## Theming

- Palette source of truth: `lib/config/theme/app_colors.dart`
- App theme setup: `lib/config/theme/app_theme.dart`
- App bootstrap uses centralized theme in `lib/main.dart`

`AppColors` is used for all UI colors to avoid inline hex values in widgets. Colors aren't hardcoded anywhere in the widgets, to avoid scattered colors everywhere in the project.
