import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_dark_mode_preference_usecase.dart';
import '../../domain/usecases/set_dark_mode_preference_usecase.dart';

part 'theme_mode_provider.g.dart';

@riverpod
class ThemeModeController extends _$ThemeModeController {
  late final GetDarkModePreferenceUseCase _getDarkModePreferenceUseCase;
  late final SetDarkModePreferenceUseCase _setDarkModePreferenceUseCase;

  @override
  ThemeMode build() {
    _getDarkModePreferenceUseCase = sl<GetDarkModePreferenceUseCase>();
    _setDarkModePreferenceUseCase = sl<SetDarkModePreferenceUseCase>();
    Future.microtask(_load);
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final result = await _getDarkModePreferenceUseCase(const NoParams());
    state = result.fold((_) => ThemeMode.system, (enabled) {
      if (enabled == null) return ThemeMode.system;
      return enabled ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> setDarkMode(bool enabled) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    state = mode;

    final result = await _setDarkModePreferenceUseCase(
      SetDarkModePreferenceParams(enabled: enabled),
    );

    if (result.isLeft()) {
      state = ThemeMode.system;
    }
  }
}
