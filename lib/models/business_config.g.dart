// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessConfig _$BusinessConfigFromJson(Map<String, dynamic> json) =>
    _BusinessConfig(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      shortDescription: json['shortDescription'] as String,
      logoAsset: json['logoAsset'] as String,
      phoneNumber: json['phoneNumber'] as String,
      whatsappNumber: json['whatsappNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      currencyCode: json['currencyCode'] as String,
      defaultLocale: json['defaultLocale'] as String,
      primaryColorHex: json['primaryColorHex'] as String,
      secondaryColorHex: json['secondaryColorHex'] as String,
      instagramUrl: json['instagramUrl'] as String,
      facebookUrl: json['facebookUrl'] as String,
      openingHours: Map<String, String>.from(json['openingHours'] as Map),
    );

Map<String, dynamic> _$BusinessConfigToJson(_BusinessConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'shortDescription': instance.shortDescription,
      'logoAsset': instance.logoAsset,
      'phoneNumber': instance.phoneNumber,
      'whatsappNumber': instance.whatsappNumber,
      'email': instance.email,
      'address': instance.address,
      'currencyCode': instance.currencyCode,
      'defaultLocale': instance.defaultLocale,
      'primaryColorHex': instance.primaryColorHex,
      'secondaryColorHex': instance.secondaryColorHex,
      'instagramUrl': instance.instagramUrl,
      'facebookUrl': instance.facebookUrl,
      'openingHours': instance.openingHours,
    };
