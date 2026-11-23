// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContributionRequestCWProxy {
  ContributionRequest amount(num? amount);

  ContributionRequest note(String? note);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContributionRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContributionRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  ContributionRequest call({num? amount, String? note});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfContributionRequest.copyWith(...)` or call `instanceOfContributionRequest.copyWith.fieldName(value)` for a single field.
class _$ContributionRequestCWProxyImpl implements _$ContributionRequestCWProxy {
  const _$ContributionRequestCWProxyImpl(this._value);

  final ContributionRequest _value;

  @override
  ContributionRequest amount(num? amount) => call(amount: amount);

  @override
  ContributionRequest note(String? note) => call(note: note);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ContributionRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ContributionRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  ContributionRequest call({
    Object? amount = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return ContributionRequest(
      amount: amount == const $CopyWithPlaceholder()
          ? _value.amount
          // ignore: cast_nullable_to_non_nullable
          : amount as num?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $ContributionRequestCopyWith on ContributionRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfContributionRequest.copyWith(...)` or `instanceOfContributionRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContributionRequestCWProxy get copyWith =>
      _$ContributionRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionRequest _$ContributionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ContributionRequest', json, ($checkedConvert) {
      final val = ContributionRequest(
        amount: $checkedConvert('amount', (v) => v as num?),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ContributionRequestToJson(
  ContributionRequest instance,
) => <String, dynamic>{'amount': ?instance.amount, 'note': ?instance.note};
