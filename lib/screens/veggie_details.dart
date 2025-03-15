import 'dart:io';

import 'package:flutter/cupertino.dart'
    show CupertinoSegmentedControl, CupertinoSlidingSegmentedControl;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veggie_android_seasons/data/app_notifier.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences_notifier.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/trivia.dart';

class ServingInfoChart extends ConsumerWidget {
  final Veggie veggie;

  const ServingInfoChart({super.key, required this.veggie});

  Widget _buildVitaminText(int standardPercentage, WidgetRef ref) {
    final target = ref.watch(caloriesProvider);
    final percent = standardPercentage * 2000 ~/ target;
    return Text(
      '$percent% DV',
      textAlign: TextAlign.end,
      style: VeggieStyles.detailsServingValueText,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      const SizedBox(
        height: 16,
      ),
      const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 9, bottom: 4),
          child: Text('Serving Info',
              style: VeggieStyles.detailsServingHeaderText),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: VeggieStyles.servingInfoBorderColor),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Text(
                        'Serving size:',
                        style: VeggieStyles.detailsServingLabelText,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        veggie.servingSize,
                        textAlign: TextAlign.end,
                        style: VeggieStyles.detailsServingValueText,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Text(
                        'Calories:',
                        style: VeggieStyles.detailsServingLabelText,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '${veggie.caloriesPerServing} kCal',
                        textAlign: TextAlign.end,
                        style: VeggieStyles.detailsServingValueText,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Text(
                        'Vitamin A:',
                        style: VeggieStyles.detailsServingLabelText,
                      ),
                    ),
                    TableCell(
                      child: _buildVitaminText(veggie.vitaminAPercentage, ref),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCell(
                      child: Text(
                        'Vitamin C:',
                        style: VeggieStyles.detailsServingLabelText,
                      ),
                    ),
                    TableCell(
                      child: _buildVitaminText(veggie.vitaminCPercentage, ref),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Percent daily values based on a diet of '
                '${ref.watch(caloriesProvider)} calories.',
                style: VeggieStyles.detailsServingNoteText,
              ),
            )
          ],
        ),
      )
    ]);
  }
}

class InfoView extends ConsumerWidget {
  final int id;

  const InfoView({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final veggie = ref.watch(appNotifierProvider.notifier).getVeggie(id);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(veggie.category.name.toUpperCase(),
                  style: (ref
                          .watch(preferredCategoriesProvider)
                          .contains(veggie.category))
                      ? VeggieStyles.detailsPreferredCategoryText
                      : VeggieStyles.detailsCategoryText),
              const Spacer(),
              for (Season season in veggie.seasons) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: VeggieStyles.seasonIconPadding[season]!,
                  child: Icon(
                    VeggieStyles.seasonIconData[season],
                    color: VeggieStyles.seasonColors[season],
                  ),
                )
              ]
            ],
          ),
          const SizedBox(height: 8),
          Text(veggie.name, style: VeggieStyles.detailsTitleText),
          const SizedBox(height: 8),
          Text(
            veggie.shortDescription,
            style: VeggieStyles.detailsDescriptionText,
          ),
          ServingInfoChart(veggie: veggie),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch.adaptive(
                value: veggie.isFavorite,
                onChanged: (value) => ref
                    .read(appNotifierProvider.notifier)
                    .setFavourite(id, value),
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Save to Garden'),
            ],
          ),
        ],
      ),
    );
  }
}

class VeggieDetails extends ConsumerStatefulWidget {
  final int id;

  const VeggieDetails({super.key, required this.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VeggieDetailsState();
}

class _VeggieDetailsState extends ConsumerState<VeggieDetails> {
  int _selectedViewIndex = 0;
  late List<bool> isSelected;
  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final veggie = ref.watch(appNotifierProvider.notifier).getVeggie(widget.id);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 3,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: Hero(
              tag: '${veggie.name}_${veggie.id}_tag',
              child: Image.asset(veggie.imageAssetPath, fit: BoxFit.cover),
            ),
          ),
          const Positioned(
            top: 16,
            left: 16,
            child: SafeArea(child: CloseButton()),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(context, ref),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20),
              children: [
                const SizedBox(height: 20),
                Platform.isIOS
                    ? CupertinoSlidingSegmentedControl(
                        children: const {
                          0: Text('Facts & Info'),
                          1: Text('Trivia'),
                        },
                        thumbColor: Theme.of(context).colorScheme.primary,
                        groupValue: _selectedViewIndex,
                        onValueChanged: (value) =>
                            setState(() => _selectedViewIndex = value as int),
                      )
                    : CupertinoSegmentedControl(
                        children: const {
                          0: Text('Facts & Info'),
                          1: Text('Trivia'),
                        },
                        groupValue: _selectedViewIndex,
                        onValueChanged: (value) =>
                            setState(() => _selectedViewIndex = value),
                      ),
                _selectedViewIndex == 0
                    ? InfoView(id: widget.id)
                    : TriviaView(widget.id)
              ],
            ),
          )
        ],
      ),
    );
  }
}
