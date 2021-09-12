import 'dart:io';

import 'package:flutter/cupertino.dart'
    show CupertinoSegmentedControl, CupertinoSlidingSegmentedControl;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/trivia.dart';

class ServingInfoChart extends StatelessWidget {
  final Veggie veggie;
  final VeggiePrefs veggiePrefs;

  const ServingInfoChart(
      {Key? key, required this.veggie, required this.veggiePrefs})
      : super(key: key);

  Widget _buildVitaminText(int standardPercentage, Future<int> targetCalories) {
    return FutureBuilder<int>(
      future: targetCalories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final target = snapshot.data ?? 2000;
        final percent = standardPercentage * 2000 ~/ target;
        return Text(
          '$percent% DV',
          textAlign: TextAlign.end,
          style: VeggieStyles.detailsServingValueText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      child: _buildVitaminText(
                        veggie.vitaminAPercentage,
                        veggiePrefs.desiredCalories,
                      ),
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
                      child: _buildVitaminText(
                        veggie.vitaminCPercentage,
                        veggiePrefs.desiredCalories,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FutureBuilder(
                future: veggiePrefs.desiredCalories,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    'Percent daily values based on a diet of '
                    '${snapshot.data ?? '2,000'} calories.',
                    style: VeggieStyles.detailsServingNoteText,
                  );
                },
              ),
            )
          ],
        ),
      )
    ]);
  }
}

class InfoView extends StatelessWidget {
  final int id;

  const InfoView({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final prefs = Provider.of<VeggiePrefs>(context);
    final veggie = appState.getVeggie(id);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder(
                future: prefs.preferredCategories,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(veggie.categoryName!.toUpperCase(),
                      style: (snapshot.hasData &&
                              snapshot.data.contains(veggie.category))
                          ? VeggieStyles.detailsPreferredCategoryText
                          : VeggieStyles.detailsCategoryText);
                },
              ),
              const Spacer(),
              for (Season season in veggie.seasons) ...[
                const SizedBox(
                  width: 12,
                ),
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
          const SizedBox(
            height: 8,
          ),
          Text(
            veggie.name,
            style: VeggieStyles.detailsTitleText,
          ),
          const SizedBox(height: 8),
          Text(
            veggie.shortDescription,
            style: VeggieStyles.detailsDescriptionText,
          ),
          ServingInfoChart(
            veggie: veggie,
            veggiePrefs: prefs,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: veggie.isFavorite,
                onChanged: (value) {
                  appState.setFavourite(id, value);
                },
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

class VeggieDetails extends StatefulWidget {
  final int id;

  const VeggieDetails({Key? key, required this.id}) : super(key: key);
  @override
  _VeggieDetailsState createState() => _VeggieDetailsState();
}

class _VeggieDetailsState extends State<VeggieDetails> {
  int _selectedViewIndex = 0;
  late List<bool> isSelected;
  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
  }

  Widget _buildHeader(BuildContext context, AppState model) {
    final veggie = model.getVeggie(widget.id);

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            left: 0,
            child: Hero(
              tag: '${veggie.name}_${veggie.id}_tag',
              child: Image.asset(
                veggie.imageAssetPath,
                fit: BoxFit.cover,
              ),
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
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(context, appState),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20),
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Platform.isIOS
                    ? CupertinoSlidingSegmentedControl(
                        children: const {
                          0: Text('Facts & Info'),
                          1: Text('Trivia'),
                        },
                        thumbColor: Theme.of(context).primaryColorLight,
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
                            setState(() => _selectedViewIndex = value as int),
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
