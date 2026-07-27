// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogData {

 BusinessConfig get business; List<Category> get categories; List<Product> get products;
/// Create a copy of CatalogData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogDataCopyWith<CatalogData> get copyWith => _$CatalogDataCopyWithImpl<CatalogData>(this as CatalogData, _$identity);

  /// Serializes this CatalogData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogData&&(identical(other.business, business) || other.business == business)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.products, products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,business,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'CatalogData(business: $business, categories: $categories, products: $products)';
}


}

/// @nodoc
abstract mixin class $CatalogDataCopyWith<$Res>  {
  factory $CatalogDataCopyWith(CatalogData value, $Res Function(CatalogData) _then) = _$CatalogDataCopyWithImpl;
@useResult
$Res call({
 BusinessConfig business, List<Category> categories, List<Product> products
});


$BusinessConfigCopyWith<$Res> get business;

}
/// @nodoc
class _$CatalogDataCopyWithImpl<$Res>
    implements $CatalogDataCopyWith<$Res> {
  _$CatalogDataCopyWithImpl(this._self, this._then);

  final CatalogData _self;
  final $Res Function(CatalogData) _then;

/// Create a copy of CatalogData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? business = null,Object? categories = null,Object? products = null,}) {
  return _then(_self.copyWith(
business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as BusinessConfig,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}
/// Create a copy of CatalogData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessConfigCopyWith<$Res> get business {
  
  return $BusinessConfigCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}


/// Adds pattern-matching-related methods to [CatalogData].
extension CatalogDataPatterns on CatalogData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogData value)  $default,){
final _that = this;
switch (_that) {
case _CatalogData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogData value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BusinessConfig business,  List<Category> categories,  List<Product> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogData() when $default != null:
return $default(_that.business,_that.categories,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BusinessConfig business,  List<Category> categories,  List<Product> products)  $default,) {final _that = this;
switch (_that) {
case _CatalogData():
return $default(_that.business,_that.categories,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BusinessConfig business,  List<Category> categories,  List<Product> products)?  $default,) {final _that = this;
switch (_that) {
case _CatalogData() when $default != null:
return $default(_that.business,_that.categories,_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogData implements CatalogData {
  const _CatalogData({required this.business, required final  List<Category> categories, required final  List<Product> products}): _categories = categories,_products = products;
  factory _CatalogData.fromJson(Map<String, dynamic> json) => _$CatalogDataFromJson(json);

@override final  BusinessConfig business;
 final  List<Category> _categories;
@override List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of CatalogData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogDataCopyWith<_CatalogData> get copyWith => __$CatalogDataCopyWithImpl<_CatalogData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogData&&(identical(other.business, business) || other.business == business)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,business,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'CatalogData(business: $business, categories: $categories, products: $products)';
}


}

/// @nodoc
abstract mixin class _$CatalogDataCopyWith<$Res> implements $CatalogDataCopyWith<$Res> {
  factory _$CatalogDataCopyWith(_CatalogData value, $Res Function(_CatalogData) _then) = __$CatalogDataCopyWithImpl;
@override @useResult
$Res call({
 BusinessConfig business, List<Category> categories, List<Product> products
});


@override $BusinessConfigCopyWith<$Res> get business;

}
/// @nodoc
class __$CatalogDataCopyWithImpl<$Res>
    implements _$CatalogDataCopyWith<$Res> {
  __$CatalogDataCopyWithImpl(this._self, this._then);

  final _CatalogData _self;
  final $Res Function(_CatalogData) _then;

/// Create a copy of CatalogData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? business = null,Object? categories = null,Object? products = null,}) {
  return _then(_CatalogData(
business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as BusinessConfig,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}

/// Create a copy of CatalogData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessConfigCopyWith<$Res> get business {
  
  return $BusinessConfigCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}

// dart format on
