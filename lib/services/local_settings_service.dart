import 'package:business_catalog_app/models/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localSettingsServiceProvider = Provider<LocalSettingsService>(
  (ref) => throw UnimplementedError('LocalSettingsService is not initialized.'),
);

final appSettingsProvider = Provider<AppSettings>(
  (ref) => ref.watch(localSettingsServiceProvider).readSettings(),
);

class LocalSettingsService {
  const LocalSettingsService(this._preferences);

  static const _localeCodeKey = 'localeCode';
  static const allowedKeys = {_localeCodeKey};

  final SharedPreferencesWithCache _preferences;

  AppSettings readSettings() {
    return AppSettings(localeCode: _preferences.getString(_localeCodeKey));
  }

  Future<void> saveLocaleCode(String localeCode) {
    return _preferences.setString(_localeCodeKey, localeCode);
  }
}
