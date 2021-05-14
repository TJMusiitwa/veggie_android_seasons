import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';
import 'package:veggie_android_seasons/widgets/settings_item.dart';

class SettingsGroupHeader extends StatelessWidget {
  final String title;

  const SettingsGroupHeader({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey,
          fontSize: 13.5,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class SettingsGroupFooter extends StatelessWidget {
  final String title;

  const SettingsGroupFooter({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 7.5,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: VeggieStyles.settingsGroupSubtitle,
          fontSize: 13,
          letterSpacing: -0.08,
        ),
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final Widget? header, footer;
  final List<SettingsItem> items;

  const SettingsGroup({Key? key, this.header, this.footer, required this.items})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dividedItems = <Widget>[items[0]];

    for (var i = 0; i < items.length; i++) {
      dividedItems.add(Container(
        color: VeggieStyles.settingsLineation,
        height: 0.3,
      ));
      dividedItems.add(items[i]);
    }
    return Padding(
      padding: EdgeInsets.only(
        // ignore: unnecessary_null_comparison
        top: header == null ? 35 : 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ignore: unnecessary_null_comparison
          if (header != null) header!,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: const BorderSide(
                  color: VeggieStyles.settingsLineation,
                  width: 0,
                ),
                bottom: const BorderSide(
                  color: VeggieStyles.settingsLineation,
                  width: 0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: dividedItems,
            ),
          ),
          // ignore: unnecessary_null_comparison
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
