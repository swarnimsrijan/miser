// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BankCWProxy {
  Bank id(int? id);

  Bank name(String? name);

  Bank logo(String? logo);

  Bank country(String? country);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Bank(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Bank(...).copyWith(id: 12, name: "My name")
  /// ```
  Bank call({int? id, String? name, String? logo, String? country});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfBank.copyWith(...)` or call `instanceOfBank.copyWith.fieldName(value)` for a single field.
class _$BankCWProxyImpl implements _$BankCWProxy {
  const _$BankCWProxyImpl(this._value);

  final Bank _value;

  @override
  Bank id(int? id) => call(id: id);

  @override
  Bank name(String? name) => call(name: name);

  @override
  Bank logo(String? logo) => call(logo: logo);

  @override
  Bank country(String? country) => call(country: country);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Bank(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Bank(...).copyWith(id: 12, name: "My name")
  /// ```
  Bank call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? logo = const $CopyWithPlaceholder(),
    Object? country = const $CopyWithPlaceholder(),
  }) {
    return Bank(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      logo: logo == const $CopyWithPlaceholder()
          ? _value.logo
          // ignore: cast_nullable_to_non_nullable
          : logo as String?,
      country: country == const $CopyWithPlaceholder()
          ? _value.country
          // ignore: cast_nullable_to_non_nullable
          : country as String?,
    );
  }
}

extension $BankCopyWith on Bank {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfBank.copyWith(...)` or `instanceOfBank.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BankCWProxy get copyWith => _$BankCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bank _$BankFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Bank', json, ($checkedConvert) {
      final val = Bank(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        name: $checkedConvert('name', (v) => v as String?),
        logo: $checkedConvert('logo', (v) => v as String?),
        country: $checkedConvert('country', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'logo': ?instance.logo,
  'country': ?instance.country,
};
