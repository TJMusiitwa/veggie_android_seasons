import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/data/veggie_preferences.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/trivia.dart';

class ServingInfoChart extends StatelessWidget {
  final Veggie veggie;
  final VeggiePrefs veggiePrefs;

  const ServingInfoChart({Key key, this.veggie, this.veggiePrefs})
      : super(key: key);

  Widget _buildVitaminText(int standardPercentage, Future<int> targetCalories) {
    return FutureBuilder<int>(
      future: targetCalories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final target = snapshot?.data ?? 2000;
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
      SizedBox(
        height: 16,
      ),
      Align(
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
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
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
                    TableCell(
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
                    TableCell(
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
                    TableCell(
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
              padding: EdgeInsets.only(top: 16),
              child: FutureBuilder(
                future: veggiePrefs.desiredCalories,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    'Percent daily values based on a diet of ' +
                        '${snapshot?.data ?? '2,000'} calories.',
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

  const InfoView({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    final prefs = ScopedModel.of<VeggiePrefs>(context, rebuildOnChange: true);
    final veggie = appState.getVeggie(id);
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder(
                future: prefs.preferredCategories,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(veggie.categoryName.toUpperCase(),
                      style: (snapshot.hasData &&
                              snapshot.data.contains(veggie.category))
                          ? VeggieStyles.detailsPreferredCategoryText
                          : VeggieStyles.detailsCategoryText);
                },
              ),
              Spacer(),
              for (Season season in veggie.seasons) ...[
                SizedBox(
                  width: 12,
                ),
                Padding(
                  padding: VeggieStyles.seasonIconPadding[season],
                  child: Icon(
                    VeggieStyles.seasonIconData[season],
                    color: VeggieStyles.seasonColors[season],
                  ),
                )
              ]
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            veggie.name,
            style: VeggieStyles.detailsTitleText,
          ),
          SizedBox(height: 8),
          Text(
            veggie.shortDescription,
            style: VeggieStyles.detailsDescriptionText,
          ),
          ServingInfoChart(
            veggie: veggie,
            veggiePrefs: prefs,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: veggie.isFavorite,
                onChanged: (value) {
                  appState.setFavourite(id, value);
                },
              ),
              SizedBox(width: 8),
              Text('Save to Garden'),
            ],
          ),
        ],
      ),
    );
  }
}

class VeggieDetails extends StatefulWidget {
  final int id;

  const VeggieDetails({Key key, this.id}) : super(key: key);
  @override
  _VeggieDetailsState createState() => _VeggieDetailsState();
}

class _VeggieDetailsState extends State<VeggieDetails> {
  int _selectedViewIndex = 0;
  List<bool> isSelected;
  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
  }

  Widget _buildHeader(BuildContext context, AppState model) {
    final veggie = model.getVeggie(widget.id);

    return SizedBox(
      height: 200,
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
          Positioned(
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
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeader(context, appState),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ToggleButtons(
                      children: <Widget>[
                        Text('Facts & Info'),
                        Text('Trivia'),
                      ],
                      isSelected: isSelected,
                      onPressed: (value) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == value;
                          }
                          _selectedViewIndex = value;
                        });
                      },
                    ),
                  ),
                  _selectedViewIndex == 0
                      ? InfoView(id: widget.id)
                      : TriviaView(widget.id)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
