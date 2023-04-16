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
          centerTitle: true, title: const Text('Veggie Android Seasons')),
      body: SizedBox(child: _pages.elementAt(_currentPage)),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.book), label: 'My Garden'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: _currentPage,
        onDestinationSelected: (int index) =>
            setState(() => _currentPage = index),
      ),
    );
  }
}
