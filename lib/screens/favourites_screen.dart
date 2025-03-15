import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veggie_android_seasons/data/app_notifier.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/veggie_headline.dart';

class FavouritesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteVeggies =
        ref.watch(appNotifierProvider.notifier).favouriteVeggies();
    return Center(
      child: favouriteVeggies.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'You haven\'t added any favorite veggies to your garden yet.',
                style: VeggieStyles.headlineDescription,
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              children: [
                const SizedBox(height: 24),
                for (Veggie veggie in favouriteVeggies)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: VeggieHeadline(veggie: veggie),
                  )
              ],
            ),
    );
  }
}
