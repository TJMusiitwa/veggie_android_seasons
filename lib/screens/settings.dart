import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/settings_group.dart';
import 'package:veggie_android_seasons/widgets/settings_item.dart';

class CalorieSettingsScreen extends StatelessWidget {
  static const max = 1000;
  static const min = 2600;
  static const step = 200;
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<VeggiePrefs>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Settings'),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: model.desiredCalories,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final steps = <SettingsItem>[];

              for (int cals = max; cals < min; cals += step) {
                steps.add(
                  SettingsItem(
                    label: cals.toString(),
                    icon: SettingsIcon(
                      icon: Icons.check,
                      foregroundColor: snapshot.hasData && snapshot.data == cals
                          ? Colors.blueAccent
                          : VeggieStyles.transparentColor,
                      backgroundColor: VeggieStyles.transparentColor,
                    ),
                    onPress: snapshot.hasData
                        ? () => model.setDesiredCalories(cals)
                        : null,
                  ),
                );
              }
              return SettingsGroup(
                items: steps,
                header: SettingsGroupHeader(title: 'Available calorie levels'),
                footer: SettingsGroupFooter(
                    title: 'These are used for serving calculations'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<VeggiePrefs>(context, rebuildOnChange: true);
    return Container(
      color: VeggieStyles.scaffoldBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverSafeArea(
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                SettingsGroup(items: [
                  _buildCaloriesItem(context, prefs),
                  _buildCategoriesItem(context, prefs)
                ])
              ]),
            ),
          )
        ],
      ),
    );
  }

  SettingsItem _buildCaloriesItem(BuildContext context, VeggiePrefs prefs) {
    return SettingsItem(
      label: 'Calorie Target',
      icon: SettingsIcon(
        backgroundColor: VeggieStyles.iconBlue,
        icon: FontAwesomeIcons.fire,
      ),
      content: FutureBuilder<int>(
        future: prefs.desiredCalories,
        builder: (context, snapshot) {
          return Row(
            children: [
              Text(snapshot.data?.toString() ?? ''),
              SizedBox(width: 8),
              SettingsNavigationIndicator(),
            ],
          );
        },
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

  SettingsItem _buildCategoriesItem(BuildContext context, VeggiePrefs prefs) {
    return SettingsItem(
      label: 'Preferred Categories',
      subtitle: 'What types of veggies you prefer!',
      icon: SettingsIcon(
        backgroundColor: VeggieStyles.iconGold,
        icon: FontAwesomeIcons.thumbsUp,
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

class VeggieCategorySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<VeggiePrefs>(context, rebuildOnChange: true);
    final currentPrefs = model.preferredCategories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferred Categories'),
      ),
      body: FutureBuilder<Set<VeggieCategory>>(
        future: currentPrefs,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final items = <SettingsItem>[];
          for (final category in VeggieCategory.values) {
            Switch toggle;
            // It's possible that category data hasn't loaded from shared prefs
            // yet, so display it if possible and fall back to disabled switches
            // otherwise.
            if (snapshot.hasData) {
              toggle = Switch(
                value: snapshot.data.contains(category),
                onChanged: (value) {
                  if (value) {
                    model.addPreferredCategory(category);
                  } else {
                    model.removePreferredCategory(category);
                  }
                },
              );
            } else {
              toggle = Switch(
                value: false,
                onChanged: null,
              );
            }

            items.add(SettingsItem(
              label: veggieCategoryNames[category],
              content: toggle,
            ));
          }
          return ListView(
            children: <Widget>[SettingsGroup(items: items)],
          );
        },
      ),
    );
  }
}
