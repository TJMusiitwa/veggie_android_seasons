import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:veggie_android_seasons/data/app_notifier.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences_notifier.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/veggie_card.dart';

class VeggieListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dateString = DateFormat('MMMM y').format(DateTime.now());
    final appState = ref.watch(appNotifierProvider);

    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xffffffff)),
      child: ListView.builder(
        itemCount: appState.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(dateString.toUpperCase(), style: VeggieStyles.minorText),
                  const Text('In Season today',
                      style: VeggieStyles.headlineText)
                ],
              ),
            );
          } else if (index <= appState.length) {
            return _generateVeggieRow(appState[index - 1], ref);
          } else if (index <= appState.length + 1) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text('Not in Season', style: VeggieStyles.headlineText),
            );
          } else {
            final relativeIndex = index - (appState.length + 2);
            return _generateVeggieRow(
                ref
                    .watch(appNotifierProvider.notifier)
                    .unavailableVeggies[relativeIndex],
                ref,
                inSeason: false);
          }
        },
      ),
    );
  }

  Widget _generateVeggieRow(Veggie veggie, WidgetRef ref,
      {bool inSeason = true}) {
    final preferredCategories = ref.watch(preferredCategoriesProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: VeggieCard(
          veggie: veggie,
          isInSeason: inSeason,
          isPreferredCategory: preferredCategories.contains(veggie.category)),
    );
  }
}
