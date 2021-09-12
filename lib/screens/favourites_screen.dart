import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/veggie_headline.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppState>(context);
    return Center(
        child: model.favouriteVeggies.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'You haven\'t added any favorite veggies to your garden yet.',
                  style: VeggieStyles.headlineDescription,
                  textAlign: TextAlign.center,
                ),
              )
            : ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  for (Veggie veggie in model.favouriteVeggies)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: VeggieHeadline(
                        veggie: veggie,
                      ),
                    )
                ],
              ));
  }
}
