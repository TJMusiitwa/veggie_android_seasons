import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences_notifier.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/settings_group.dart';
import 'package:veggie_android_seasons/widgets/settings_item.dart';

class CalorieSettingsScreen extends ConsumerWidget {
  static const max = 1000;
  static const min = 2600;
  static const step = 200;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Settings')),
      body: SettingsGroup(
        items: [
          for (var cals = max; cals < min; cals += step) ...{
            SettingsItem(
                label: cals.toString(),
                icon: SettingsIcon(
                  icon: Icons.check,
                  foregroundColor: ref.watch(caloriesProvider) == cals
                      ? Colors.blueAccent
                      : VeggieStyles.transparentColor,
                  backgroundColor: VeggieStyles.transparentColor,
                ),
                onPress: () {
                  ref
                      .read(veggiePrefProvider.notifier)
                      .setDesiredCalories(cals);
                })
          }
        ],
        header: const SettingsGroupHeader(title: 'Available calorie levels'),
        footer: const SettingsGroupFooter(
            title: 'These are used for serving calculations'),
      ),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: VeggieStyles.scaffoldBackground,
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                SettingsGroup(items: [
                  _buildCaloriesItem(context, ref.watch(caloriesProvider)),
                  _buildCategoriesItem(context)
                ])
              ]),
            ),
          )
        ],
      ),
    );
  }

  SettingsItem _buildCaloriesItem(BuildContext context, int desiredCalories) {
    return SettingsItem(
      label: 'Calorie Target',
      icon: const SettingsIcon(
        backgroundColor: VeggieStyles.iconBlue,
        icon: Icons.whatshot_outlined,
      ),
      content: Row(
        children: [
          Text(desiredCalories.toString()),
          const SizedBox(width: 8),
          SettingsNavigationIndicator(),
        ],
      ),
      onPress: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => CalorieSettingsScreen(),
          ),
        );
      },
    );
  }

  SettingsItem _buildCategoriesItem(BuildContext context) {
    return SettingsItem(
      label: 'Preferred Categories',
      subtitle: 'What types of veggies you prefer!',
      icon: const SettingsIcon(
        backgroundColor: VeggieStyles.iconGold,
        icon: Icons.thumb_up_outlined,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => VeggieCategorySettingsScreen(),
          ),
        );
      },
    );
  }
}

class VeggieCategorySettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrefs = ref.watch(preferredCategoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Preferred Categories')),
      body: ListView(
        children: [
          SettingsGroup(items: [
            for (var category in VeggieCategory.values)
              SettingsItem(
                label: category.name,
                content: currentPrefs.isNotEmpty
                    ? Switch.adaptive(
                        value: currentPrefs.contains(category),
                        onChanged: (value) {
                          if (value) {
                            ref
                                .read(veggiePrefProvider.notifier)
                                .addPreferredCategory(category);
                          } else {
                            ref
                                .read(veggiePrefProvider.notifier)
                                .removePreferredCategory(category);
                          }
                        })
                    : const Switch.adaptive(value: false, onChanged: null),
              ),
          ])
        ],
      ),
    );
  }
}
