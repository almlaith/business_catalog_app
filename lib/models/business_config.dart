import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_config.freezed.dart';
part 'business_config.g.dart';

@freezed
abstract class BusinessConfig with _$BusinessConfig {
  const factory BusinessConfig({
    required String id,
    required String businessName,
    required String shortDescription,
    required String logoAsset,
    required String phoneNumber,
    required String whatsappNumber,
    required String email,
    required String address,
    required String currencyCode,
    required String defaultLocale,
    required String primaryColorHex,
    required String secondaryColorHex,
    required String instagramUrl,
    required String facebookUrl,
    required Map<String, String> openingHours,
  }) = _BusinessConfig;

  factory BusinessConfig.fromJson(Map<String, Object?> json) =>
      _$BusinessConfigFromJson(json);
}
