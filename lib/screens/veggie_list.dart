import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/veggie_card.dart';

class VeggieListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dateString = DateFormat('MMMM y').format(DateTime.now());
    final appState = Provider.of<AppState>(context);
    final prefs = Provider.of<VeggiePrefs>(context);
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xffffffff)),
      child: ListView.builder(
        itemCount: appState.allVeggies.length + 2,
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
          } else if (index <= appState.availableVeggies.length) {
            return _generateVeggieRow(
                appState.availableVeggies[index - 1], prefs);
          } else if (index <= appState.availableVeggies.length + 1) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text('Not in Season', style: VeggieStyles.headlineText),
            );
          } else {
            var relativeIndex = index - (appState.availableVeggies.length + 2);
            return _generateVeggieRow(
                appState.unavailableVeggies[relativeIndex], prefs,
                inSeason: false);
          }
        },
      ),
    );
  }

  Widget _generateVeggieRow(Veggie veggie, VeggiePrefs veggiePrefs,
      {bool inSeason = true}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: FutureBuilder<Set<VeggieCategory>>(
        future: veggiePrefs.preferredCategories,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final data = snapshot.data ?? <VeggieCategory>{};
          return VeggieCard(
              veggie: veggie,
              isInSeason: inSeason,
              isPreferredCategory: data.contains(veggie.category));
        },
      ),
    );
  }
}
