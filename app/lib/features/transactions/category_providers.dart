import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miser_api/miser_api.dart' as api;

import '../../core/api/api_providers.dart';

// `Category` clashes with Flutter's foundation annotation, hence the prefix.
typedef MiserCategory = api.Category;
typedef MiserSubCategory = api.SubCategory;

final categoriesProvider = FutureProvider.autoDispose<List<MiserCategory>>((ref) async {
  final res = await ref.watch(miserApiProvider).getCategoryControllerApi().getAll3();
  return [...?res.data]..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
});

final subCategoriesProvider =
    FutureProvider.autoDispose.family<List<MiserSubCategory>, int>((ref, categoryId) async {
  final res =
      await ref.watch(miserApiProvider).getCategoryControllerApi().getSubCategories(id: categoryId);
  return [...?res.data]..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
});
