import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/screens/veggie_details.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

class ZoomClipAssetImage extends StatelessWidget {
  final double zoom, height, width;
  final String imageAsset;

  const ZoomClipAssetImage(
      {super.key,
      required this.zoom,
      required this.height,
      required this.width,
      required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: OverflowBox(
          maxHeight: height * zoom,
          maxWidth: width * zoom,
          child: Image.asset(imageAsset, fit: BoxFit.fill),
        ),
      ),
    );
  }
}

class VeggieHeadline extends StatelessWidget {
  final Veggie veggie;

  const VeggieHeadline({super.key, required this.veggie});

  List<Widget> _buildSeasonDots(List<Season> seasons) {
    var widgets = <Widget>[];

    for (var season in seasons) {
      widgets.add(const SizedBox(
        width: 4,
      ));
      widgets.add(
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: VeggieStyles.seasonColors[season],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => VeggieDetails(
                  id: veggie.id,
                )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: '${veggie.name}_${veggie.id}_tag',
            child: ZoomClipAssetImage(
              imageAsset: veggie.imageAssetPath,
              zoom: 2.4,
              height: 72,
              width: 72,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(veggie.name, style: VeggieStyles.headlineName),
                    ..._buildSeasonDots(veggie.seasons),
                  ],
                ),
                Text(veggie.shortDescription,
                    style: VeggieStyles.headlineDescription)
              ],
            ),
          )
        ],
      ),
    );
  }
}
