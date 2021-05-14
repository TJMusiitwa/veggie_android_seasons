import 'package:flutter/foundation.dart';
import 'package:veggie_android_seasons/data/local_veggie_data.dart';
import 'package:veggie_android_seasons/data/veggie.dart';

class AppState extends ChangeNotifier {
  final List<Veggie> _veggies;

  AppState() : _veggies = LocalVeggieProvider.veggies;

  List<Veggie> get allVeggies => List<Veggie>.from(_veggies);

  Veggie getVeggie(int id) => _veggies.singleWhere((v) => v.id == id);

//List all available vegetables for the current season
  List<Veggie> get availableVeggies {
    var currentSeason = _getSeasonForDate(DateTime.now());
    return _veggies.where((v) => v.seasons.contains(currentSeason)).toList();
  }

//List vegetables that are out of season
  List<Veggie> get unavailableVeggies {
    var currentSeason = _getSeasonForDate(DateTime.now());
    return _veggies.where((v) => !v.seasons.contains(currentSeason)).toList();
  }

  //Get the favourite Vegetables
  List<Veggie> get favouriteVeggies =>
      _veggies.where((v) => v.isFavorite).toList();

  //Search vegetables
  List<Veggie> searchVeggies(String terms) {
    return _veggies
        .where((v) => v.name.toLowerCase().contains(terms.toLowerCase()))
        .toList();
  }

  //Set a favourite vegetable
  void setFavourite(int id, bool isFavourite) {
    var veggie = getVeggie(id);
    veggie.isFavorite = isFavourite;
    notifyListeners();
  }

  static Season _getSeasonForDate(DateTime date) {
    // Technically the start and end dates of seasons can vary by a day or so,
    // but this is close enough for produce.
    switch (date.month) {
      case 1:
        return Season.winter;
      case 2:
        return Season.winter;
      case 3:
        return date.day < 21 ? Season.winter : Season.spring;
      case 4:
        return Season.spring;
      case 5:
        return Season.spring;
      case 6:
        return date.day < 21 ? Season.spring : Season.summer;
      case 7:
        return Season.summer;
      case 8:
        return Season.summer;
      case 9:
        return date.day < 22 ? Season.autumn : Season.winter;
      case 10:
        return Season.autumn;
      case 11:
        return Season.autumn;
      case 12:
        return date.day < 22 ? Season.autumn : Season.winter;
      default:
        throw ArgumentError('Can\'t return a season for month #${date.month}.');
    }
  }
}
