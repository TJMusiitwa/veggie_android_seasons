import 'dart:async';

import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

typedef SettingsItemCallback = FutureOr<void> Function();

class SettingsNavigationIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_forward,
      color: VeggieStyles.settingsMediumGray,
      size: 21,
    );
  }
}

class SettingsIcon extends StatelessWidget {
  final Color backgroundColor, foregroundColor;
  final IconData icon;

  const SettingsIcon(
      {Key? key,
      this.backgroundColor = Colors.black,
      this.foregroundColor = Colors.white,
      required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
      child: Center(
        child: Icon(icon, color: foregroundColor, size: 20),
      ),
    );
  }
}

class SettingsItem extends StatefulWidget {
  final String? label;
  final String? subtitle;
  final Widget? icon, content;
  final SettingsItemCallback? onPress;

  const SettingsItem(
      {Key? key,
      this.label,
      this.subtitle,
      this.icon,
      this.content,
      this.onPress})
      : super(key: key);
  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: pressed
          ? VeggieStyles.settingsItemPressed
          : VeggieStyles.transparentColor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (widget.onPress != null) {
            setState(() {
              pressed = true;
            });
            await widget.onPress!();
            Future.delayed(const Duration(milliseconds: 150), () {
              setState(() {
                pressed = false;
              });
            });
          }
        },
        child: SizedBox(
          // ignore: unnecessary_null_comparison
          height: widget.subtitle == null ? 44 : 57,
          child: Row(
            children: <Widget>[
              // ignore: unnecessary_null_comparison
              if (widget.icon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 2),
                  child: SizedBox(
                    height: 29,
                    width: 29,
                    child: widget.icon,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  // ignore: unnecessary_null_comparison
                  child: widget.subtitle != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 8.5,
                            ),
                            Text(widget.label!),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.subtitle!,
                              style: const TextStyle(
                                fontSize: 12,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 1.5),
                          child: Text(widget.label!),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 11),
                child: widget.content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
