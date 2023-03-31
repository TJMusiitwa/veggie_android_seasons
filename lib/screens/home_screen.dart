import 'package:flutter/material.dart';
import 'package:veggie_android_seasons/screens/favourites_screen.dart';
import 'package:veggie_android_seasons/screens/search_screen.dart';
import 'package:veggie_android_seasons/screens/settings.dart';
import 'package:veggie_android_seasons/screens/veggie_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentPage = 0;

  final _pages = [
    VeggieListScreen(),
    FavouritesScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Veggie Android Seasons'),
        elevation: 0,
      ),
      body: Container(
        child: _pages.elementAt(_currentPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Garden'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _currentPage,
        useLegacyColorScheme: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).disabledColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) => setState(() => _currentPage = index),
      ),
    );
  }
}
