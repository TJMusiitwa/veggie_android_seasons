import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

/// Partially overlays and then blurs its child's background.
class FrostedBox extends StatelessWidget {
  const FrostedBox({
    this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: VeggieStyles.frostedBackground,
        ),
        child: child,
      ),
    );
  }
}

/// An Icon that implicitly animates changes to its color.
class ColorChangingIcon extends ImplicitlyAnimatedWidget {
  final Color color;
  final IconData icon;
  final double size;

  ColorChangingIcon(
      {this.color = Colors.black, this.icon, this.size, Duration duration});

  @override
  _ColorChangingIconState createState() => _ColorChangingIconState();
}

class _ColorChangingIconState
    extends AnimatedWidgetBaseState<ColorChangingIcon> {
  ColorTween _colorTween;
  @override
  Widget build(BuildContext context) {
    return Icon(widget.icon,
        size: widget.size, color: _colorTween?.evaluate(animation));
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;
  }
}

/// A simple "close this modal" button that invokes a callback when pressed.
class CloseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CloseButton({Key key, this.onPressed}) : super(key: key);
  @override
  _CloseButtonState createState() => _CloseButtonState();
}

class _CloseButtonState extends State<CloseButton> {
  bool tapInProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          tapInProgress = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          tapInProgress = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          tapInProgress = false;
        });
      },
      child: ClipOval(
        child: FrostedBox(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: ColorChangingIcon(
                icon: Icons.close,
                duration: Duration(milliseconds: 300),
                color: tapInProgress
                    ? VeggieStyles.closeButtonPressed
                    : VeggieStyles.closeButtonUnpressed,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
