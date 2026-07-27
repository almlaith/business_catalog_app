import 'package:business_catalog_app/models/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localSettingsServiceProvider = Provider<AppSettingsStore>(
  (ref) => throw UnimplementedError('LocalSettingsService is not initialized.'),
);

final appSettingsControllerProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );

final appSettingsProvider = Provider<AppSettings>(
  (ref) => ref.watch(appSettingsControllerProvider),
);

abstract interface class AppSettingsStore {
  AppSettings readSettings();

  Future<void> saveLocaleCode(String localeCode);

  Future<void> saveThemeMode(String themeMode);

  Future<void> resetAppearanceSettings();
}

class LocalSettingsService implements AppSettingsStore {
  const LocalSettingsService(this._preferences);

  static const _localeCodeKey = 'localeCode';
  static const _themeModeKey = 'themeMode';
  static const allowedKeys = {_localeCodeKey, _themeModeKey};

  final SharedPreferencesWithCache _preferences;

  @override
  AppSettings readSettings() {
    return AppSettings(
      localeCode: _preferences.getString(_localeCodeKey),
      themeMode: _preferences.getString(_themeModeKey) ?? 'dark',
    );
  }

  @override
  Future<void> saveLocaleCode(String localeCode) {
    return _preferences.setString(_localeCodeKey, localeCode);
  }

  @override
  Future<void> saveThemeMode(String themeMode) {
    return _preferences.setString(_themeModeKey, themeMode);
  }

  @override
  Future<void> resetAppearanceSettings() async {
    await _preferences.remove(_localeCodeKey);
    await _preferences.remove(_themeModeKey);
  }
}

class AppSettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.watch(localSettingsServiceProvider).readSettings();
  }

  Future<void> setLocaleCode(String localeCode) async {
    state = state.copyWith(localeCode: localeCode);
    await ref.read(localSettingsServiceProvider).saveLocaleCode(localeCode);
  }

  Future<void> setThemeMode(String themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await ref.read(localSettingsServiceProvider).saveThemeMode(themeMode);
  }

  Future<void> resetAppearanceSettings() async {
    state = const AppSettings();
    await ref.read(localSettingsServiceProvider).resetAppearanceSettings();
  }
}
