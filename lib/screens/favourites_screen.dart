import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/veggie_headline.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    return Container(
      child: Center(
          child: model.favouriteVeggies.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'You haven\'t added any favorite veggies to your garden yet.',
                    style: VeggieStyles.headlineDescription,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                    ),
                    for (Veggie veggie in model.favouriteVeggies)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: VeggieHeadline(
                          veggie: veggie,
                        ),
                      )
                  ],
                )),
    );
  }
}
