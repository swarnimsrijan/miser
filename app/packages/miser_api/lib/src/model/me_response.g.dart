// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MeResponseCWProxy {
  MeResponse id(int? id);

  MeResponse email(String? email);

  MeResponse name(String? name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MeResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MeResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  MeResponse call({int? id, String? email, String? name});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMeResponse.copyWith(...)` or call `instanceOfMeResponse.copyWith.fieldName(value)` for a single field.
class _$MeResponseCWProxyImpl implements _$MeResponseCWProxy {
  const _$MeResponseCWProxyImpl(this._value);

  final MeResponse _value;

  @override
  MeResponse id(int? id) => call(id: id);

  @override
  MeResponse email(String? email) => call(email: email);

  @override
  MeResponse name(String? name) => call(name: name);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MeResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MeResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  MeResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return MeResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $MeResponseCopyWith on MeResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMeResponse.copyWith(...)` or `instanceOfMeResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MeResponseCWProxy get copyWith => _$MeResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MeResponse', json, ($checkedConvert) {
      final val = MeResponse(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        email: $checkedConvert('email', (v) => v as String?),
        name: $checkedConvert('name', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MeResponseToJson(MeResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'email': ?instance.email,
      'name': ?instance.name,
    };
