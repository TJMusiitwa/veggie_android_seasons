import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:veggie_android_seasons/data/app_state.dart';
import 'package:veggie_android_seasons/data/veggie_preferences.dart';
import 'package:veggie_android_seasons/screens/home_screen.dart';
import 'package:veggie_android_seasons/veggie_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppState()),
        ChangeNotifierProvider(create: (_) => VeggiePrefs()..load())
      ],
      child: MaterialApp(
        title: 'Veggie Android Seasons',
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: VeggieStyles.scaffoldBackground,
          brightness: Brightness.light,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
