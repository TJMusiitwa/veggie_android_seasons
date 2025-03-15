import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggie_android_seasons/data/veggie.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferencesAsync>(
  (ref) async => SharedPreferencesAsync(),
);

final caloriesProvider = StateProvider<int>((ref) => 2000);

final preferredCategoriesProvider = StateProvider<Set<VeggieCategory>>(
  (ref) => {},
);

final veggiePrefProvider = AsyncNotifierProvider<VeggiePrefNotifier, void>(
  VeggiePrefNotifier.new,
);

class VeggiePrefNotifier extends AsyncNotifier<void> {
  static const _caloriesKey = 'calories';
  static const _preferredCategoriesKey = 'preferredCategories';

  @override
  FutureOr<void> build() async {
    _loadFromSharedPrefs();
    const AsyncLoading();
  }

  Future<void> addPreferredCategory(VeggieCategory category) async {
    state = const AsyncLoading();
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final preferredCategories =
        ref.read(preferredCategoriesProvider.notifier).state;
    preferredCategories.add(category);
    await prefs.setString(
      _preferredCategoriesKey,
      preferredCategories.map((c) => c.index.toString()).join(','),
    );
    state = const AsyncData(null);
  }

  Future<void> removePreferredCategory(VeggieCategory category) async {
    state = const AsyncLoading();
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final preferredCategories =
        ref.read(preferredCategoriesProvider.notifier).state;
    preferredCategories.remove(category);
    await prefs.setString(
      _preferredCategoriesKey,
      preferredCategories.map((c) => c.index.toString()).join(','),
    );
    state = const AsyncData(null);
  }

  Future<void> setDesiredCalories(int desiredCalories) async {
    state = const AsyncLoading();
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(_caloriesKey, desiredCalories);
    ref.read(caloriesProvider.notifier).state = desiredCalories;
    state = const AsyncData(null);
  }

  Future<void> _loadFromSharedPrefs() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    ref.read(caloriesProvider.notifier).state =
        await prefs.getInt(_caloriesKey) ?? 2000;
    var newVariable = await prefs.getString(_preferredCategoriesKey);
    ref.read(preferredCategoriesProvider.notifier).state =
        newVariable!
            .split(',')
            .map((index) => VeggieCategory.values[int.parse(index)])
            .toSet();
  }
}
