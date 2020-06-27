import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/data/veggie.dart';
import 'package:veggie_android_seasons/screens/veggie_details.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

class FrostyBackground extends StatelessWidget {
  final Color color;
  final double intensity;
  final Widget child;

  const FrostyBackground({Key key, this.color, this.intensity = 25, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
          child: child,
        ),
      ),
    );
  }
}

class PressableCard extends StatefulWidget {
  final VoidCallback onPressed;

  final Widget child;

  final BorderRadius borderRadius;

  final double upElevation;

  final double downElevation;

  final Color shadowColor;

  final Duration duration;

  const PressableCard(
      {Key key,
      this.onPressed,
      this.borderRadius = const BorderRadius.all(Radius.circular(5)),
      this.upElevation = 2,
      this.downElevation = 0,
      this.shadowColor = Colors.black,
      this.duration = const Duration(milliseconds: 100),
      this.child})
      : assert(child != null),
        assert(borderRadius != null),
        assert(upElevation != null),
        assert(downElevation != null),
        assert(shadowColor != null),
        assert(duration != null),
        super(key: key);
  @override
  _PressableCardState createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool cardIsDown = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          cardIsDown = false;
        });
        if (widget.onPressed != null) {
          widget.onPressed();
        }
      },
      onTapDown: (details) => setState(() => cardIsDown = true),
      onTapCancel: () => setState(() => cardIsDown = false),
      child: AnimatedPhysicalModel(
        elevation: cardIsDown ? widget.downElevation : widget.upElevation,
        borderRadius: widget.borderRadius,
        shape: BoxShape.rectangle,
        shadowColor: widget.shadowColor,
        duration: widget.duration,
        color: Colors.grey,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

class VeggieCard extends StatelessWidget {
  final Veggie veggie;

  /// If the veggie is in season, it's displayed more prominently and the
  /// image is fully saturated. Otherwise, it's reduced and de-saturated.
  final bool isInSeason;

  /// Whether [veggie] falls into one of user's preferred [VeggieCategory]s

  final bool isPreferredCategory;

  const VeggieCard(
      {Key key, this.veggie, this.isInSeason, this.isPreferredCategory})
      : super(key: key);

  Widget _buildDetails() {
    return FrostyBackground(
      color: Color(0x90ffffff),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              veggie.name,
              style: VeggieStyles.cardTitleText,
            ),
            Text(
              veggie.shortDescription,
              style: VeggieStyles.cardDescriptionText,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: () {
        Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (context) => VeggieDetails(id: veggie.id),
            fullscreenDialog: true));
      },
      child: Stack(
        children: <Widget>[
          Semantics(
            label: 'A card background featuring ${veggie.name}',
            child: Hero(
              tag: '${veggie.name}_${veggie.id}_tag',
              child: Container(
                height: isInSeason ? 300 : 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      isInSeason ? null : VeggieStyles.desaturatedColorFilter,
                  image: AssetImage(veggie.imageAssetPath),
                )),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDetails(),
          )
        ],
      ),
    );
  }
}
