import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({@Default('en') String localeCode}) = _AppSettings;

  factory AppSettings.fromJson(Map<String, Object?> json) =>
      _$AppSettingsFromJson(json);
}
