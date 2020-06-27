import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie_preferences.dart';
import 'package:veggie_android_seasons/screens/home_screen.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppState>(
      model: AppState(),
      child: ScopedModel<VeggiePrefs>(
        model: VeggiePrefs()..load(),
        child: MaterialApp(
          title: 'Veggie Android Seasons',
          theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: VeggieStyles.scaffoldBackground,
            brightness: Brightness.light,
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
