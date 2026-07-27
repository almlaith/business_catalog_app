// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessConfig {

 String get id; String get businessName; String get shortDescription; String get logoAsset; String get phoneNumber; String get whatsappNumber; String get email; String get address; String get currencyCode; String get defaultLocale; String get primaryColorHex; String get secondaryColorHex; String get instagramUrl; String get facebookUrl; Map<String, String> get openingHours;
/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessConfigCopyWith<BusinessConfig> get copyWith => _$BusinessConfigCopyWithImpl<BusinessConfig>(this as BusinessConfig, _$identity);

  /// Serializes this BusinessConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.logoAsset, logoAsset) || other.logoAsset == logoAsset)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.defaultLocale, defaultLocale) || other.defaultLocale == defaultLocale)&&(identical(other.primaryColorHex, primaryColorHex) || other.primaryColorHex == primaryColorHex)&&(identical(other.secondaryColorHex, secondaryColorHex) || other.secondaryColorHex == secondaryColorHex)&&(identical(other.instagramUrl, instagramUrl) || other.instagramUrl == instagramUrl)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&const DeepCollectionEquality().equals(other.openingHours, openingHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,shortDescription,logoAsset,phoneNumber,whatsappNumber,email,address,currencyCode,defaultLocale,primaryColorHex,secondaryColorHex,instagramUrl,facebookUrl,const DeepCollectionEquality().hash(openingHours));

@override
String toString() {
  return 'BusinessConfig(id: $id, businessName: $businessName, shortDescription: $shortDescription, logoAsset: $logoAsset, phoneNumber: $phoneNumber, whatsappNumber: $whatsappNumber, email: $email, address: $address, currencyCode: $currencyCode, defaultLocale: $defaultLocale, primaryColorHex: $primaryColorHex, secondaryColorHex: $secondaryColorHex, instagramUrl: $instagramUrl, facebookUrl: $facebookUrl, openingHours: $openingHours)';
}


}

/// @nodoc
abstract mixin class $BusinessConfigCopyWith<$Res>  {
  factory $BusinessConfigCopyWith(BusinessConfig value, $Res Function(BusinessConfig) _then) = _$BusinessConfigCopyWithImpl;
@useResult
$Res call({
 String id, String businessName, String shortDescription, String logoAsset, String phoneNumber, String whatsappNumber, String email, String address, String currencyCode, String defaultLocale, String primaryColorHex, String secondaryColorHex, String instagramUrl, String facebookUrl, Map<String, String> openingHours
});




}
/// @nodoc
class _$BusinessConfigCopyWithImpl<$Res>
    implements $BusinessConfigCopyWith<$Res> {
  _$BusinessConfigCopyWithImpl(this._self, this._then);

  final BusinessConfig _self;
  final $Res Function(BusinessConfig) _then;

/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessName = null,Object? shortDescription = null,Object? logoAsset = null,Object? phoneNumber = null,Object? whatsappNumber = null,Object? email = null,Object? address = null,Object? currencyCode = null,Object? defaultLocale = null,Object? primaryColorHex = null,Object? secondaryColorHex = null,Object? instagramUrl = null,Object? facebookUrl = null,Object? openingHours = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,logoAsset: null == logoAsset ? _self.logoAsset : logoAsset // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,defaultLocale: null == defaultLocale ? _self.defaultLocale : defaultLocale // ignore: cast_nullable_to_non_nullable
as String,primaryColorHex: null == primaryColorHex ? _self.primaryColorHex : primaryColorHex // ignore: cast_nullable_to_non_nullable
as String,secondaryColorHex: null == secondaryColorHex ? _self.secondaryColorHex : secondaryColorHex // ignore: cast_nullable_to_non_nullable
as String,instagramUrl: null == instagramUrl ? _self.instagramUrl : instagramUrl // ignore: cast_nullable_to_non_nullable
as String,facebookUrl: null == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String,openingHours: null == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessConfig].
extension BusinessConfigPatterns on BusinessConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessConfig value)  $default,){
final _that = this;
switch (_that) {
case _BusinessConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessName,  String shortDescription,  String logoAsset,  String phoneNumber,  String whatsappNumber,  String email,  String address,  String currencyCode,  String defaultLocale,  String primaryColorHex,  String secondaryColorHex,  String instagramUrl,  String facebookUrl,  Map<String, String> openingHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
return $default(_that.id,_that.businessName,_that.shortDescription,_that.logoAsset,_that.phoneNumber,_that.whatsappNumber,_that.email,_that.address,_that.currencyCode,_that.defaultLocale,_that.primaryColorHex,_that.secondaryColorHex,_that.instagramUrl,_that.facebookUrl,_that.openingHours);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessName,  String shortDescription,  String logoAsset,  String phoneNumber,  String whatsappNumber,  String email,  String address,  String currencyCode,  String defaultLocale,  String primaryColorHex,  String secondaryColorHex,  String instagramUrl,  String facebookUrl,  Map<String, String> openingHours)  $default,) {final _that = this;
switch (_that) {
case _BusinessConfig():
return $default(_that.id,_that.businessName,_that.shortDescription,_that.logoAsset,_that.phoneNumber,_that.whatsappNumber,_that.email,_that.address,_that.currencyCode,_that.defaultLocale,_that.primaryColorHex,_that.secondaryColorHex,_that.instagramUrl,_that.facebookUrl,_that.openingHours);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessName,  String shortDescription,  String logoAsset,  String phoneNumber,  String whatsappNumber,  String email,  String address,  String currencyCode,  String defaultLocale,  String primaryColorHex,  String secondaryColorHex,  String instagramUrl,  String facebookUrl,  Map<String, String> openingHours)?  $default,) {final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
return $default(_that.id,_that.businessName,_that.shortDescription,_that.logoAsset,_that.phoneNumber,_that.whatsappNumber,_that.email,_that.address,_that.currencyCode,_that.defaultLocale,_that.primaryColorHex,_that.secondaryColorHex,_that.instagramUrl,_that.facebookUrl,_that.openingHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessConfig implements BusinessConfig {
  const _BusinessConfig({required this.id, required this.businessName, this.shortDescription = '', this.logoAsset = '', this.phoneNumber = '', this.whatsappNumber = '', this.email = '', this.address = '', this.currencyCode = 'USD', this.defaultLocale = 'en', this.primaryColorHex = '', this.secondaryColorHex = '', this.instagramUrl = '', this.facebookUrl = '', final  Map<String, String> openingHours = const <String, String>{}}): _openingHours = openingHours;
  factory _BusinessConfig.fromJson(Map<String, dynamic> json) => _$BusinessConfigFromJson(json);

@override final  String id;
@override final  String businessName;
@override@JsonKey() final  String shortDescription;
@override@JsonKey() final  String logoAsset;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String whatsappNumber;
@override@JsonKey() final  String email;
@override@JsonKey() final  String address;
@override@JsonKey() final  String currencyCode;
@override@JsonKey() final  String defaultLocale;
@override@JsonKey() final  String primaryColorHex;
@override@JsonKey() final  String secondaryColorHex;
@override@JsonKey() final  String instagramUrl;
@override@JsonKey() final  String facebookUrl;
 final  Map<String, String> _openingHours;
@override@JsonKey() Map<String, String> get openingHours {
  if (_openingHours is EqualUnmodifiableMapView) return _openingHours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_openingHours);
}


/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessConfigCopyWith<_BusinessConfig> get copyWith => __$BusinessConfigCopyWithImpl<_BusinessConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.logoAsset, logoAsset) || other.logoAsset == logoAsset)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.defaultLocale, defaultLocale) || other.defaultLocale == defaultLocale)&&(identical(other.primaryColorHex, primaryColorHex) || other.primaryColorHex == primaryColorHex)&&(identical(other.secondaryColorHex, secondaryColorHex) || other.secondaryColorHex == secondaryColorHex)&&(identical(other.instagramUrl, instagramUrl) || other.instagramUrl == instagramUrl)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&const DeepCollectionEquality().equals(other._openingHours, _openingHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,shortDescription,logoAsset,phoneNumber,whatsappNumber,email,address,currencyCode,defaultLocale,primaryColorHex,secondaryColorHex,instagramUrl,facebookUrl,const DeepCollectionEquality().hash(_openingHours));

@override
String toString() {
  return 'BusinessConfig(id: $id, businessName: $businessName, shortDescription: $shortDescription, logoAsset: $logoAsset, phoneNumber: $phoneNumber, whatsappNumber: $whatsappNumber, email: $email, address: $address, currencyCode: $currencyCode, defaultLocale: $defaultLocale, primaryColorHex: $primaryColorHex, secondaryColorHex: $secondaryColorHex, instagramUrl: $instagramUrl, facebookUrl: $facebookUrl, openingHours: $openingHours)';
}


}

/// @nodoc
abstract mixin class _$BusinessConfigCopyWith<$Res> implements $BusinessConfigCopyWith<$Res> {
  factory _$BusinessConfigCopyWith(_BusinessConfig value, $Res Function(_BusinessConfig) _then) = __$BusinessConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessName, String shortDescription, String logoAsset, String phoneNumber, String whatsappNumber, String email, String address, String currencyCode, String defaultLocale, String primaryColorHex, String secondaryColorHex, String instagramUrl, String facebookUrl, Map<String, String> openingHours
});




}
/// @nodoc
class __$BusinessConfigCopyWithImpl<$Res>
    implements _$BusinessConfigCopyWith<$Res> {
  __$BusinessConfigCopyWithImpl(this._self, this._then);

  final _BusinessConfig _self;
  final $Res Function(_BusinessConfig) _then;

/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessName = null,Object? shortDescription = null,Object? logoAsset = null,Object? phoneNumber = null,Object? whatsappNumber = null,Object? email = null,Object? address = null,Object? currencyCode = null,Object? defaultLocale = null,Object? primaryColorHex = null,Object? secondaryColorHex = null,Object? instagramUrl = null,Object? facebookUrl = null,Object? openingHours = null,}) {
  return _then(_BusinessConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,logoAsset: null == logoAsset ? _self.logoAsset : logoAsset // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,defaultLocale: null == defaultLocale ? _self.defaultLocale : defaultLocale // ignore: cast_nullable_to_non_nullable
as String,primaryColorHex: null == primaryColorHex ? _self.primaryColorHex : primaryColorHex // ignore: cast_nullable_to_non_nullable
as String,secondaryColorHex: null == secondaryColorHex ? _self.secondaryColorHex : secondaryColorHex // ignore: cast_nullable_to_non_nullable
as String,instagramUrl: null == instagramUrl ? _self.instagramUrl : instagramUrl // ignore: cast_nullable_to_non_nullable
as String,facebookUrl: null == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String,openingHours: null == openingHours ? _self._openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
