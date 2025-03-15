import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veggie_android_seasons/screens/home_screen.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veggie Android Seasons',
      theme: ThemeData(
        //colorSchemeSeed: Colors.red,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
        //primarySwatch: Colors.red,
        scaffoldBackgroundColor: VeggieStyles.scaffoldBackground,
        brightness: Brightness.light,
      ),
      home: HomeScreen(),
    );
  }
}
