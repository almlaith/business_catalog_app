import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_config.freezed.dart';
part 'business_config.g.dart';

@freezed
abstract class BusinessConfig with _$BusinessConfig {
  const factory BusinessConfig({
    required String id,
    required String businessName,
    @Default('') String shortDescription,
    @Default('') String logoAsset,
    @Default('') String phoneNumber,
    @Default('') String whatsappNumber,
    @Default('') String email,
    @Default('') String address,
    @Default('USD') String currencyCode,
    @Default('en') String defaultLocale,
    @Default('') String primaryColorHex,
    @Default('') String secondaryColorHex,
    @Default('') String instagramUrl,
    @Default('') String facebookUrl,
    @Default(<String, String>{}) Map<String, String> openingHours,
  }) = _BusinessConfig;

  factory BusinessConfig.fromJson(Map<String, Object?> json) =>
      _$BusinessConfigFromJson(json);
}
