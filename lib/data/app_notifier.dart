import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veggie_android_seasons/data/local_veggie_data.dart';
import 'package:veggie_android_seasons/data/veggie.dart';

final appNotifierProvider =
    NotifierProvider<AppNotifier, List<Veggie>>(AppNotifier.new);

class AppNotifier extends Notifier<List<Veggie>> {
  @override
  List<Veggie> build() => LocalVeggieProvider.veggies;

  Veggie getVeggie(int id) => state.singleWhere((v) => v.id == id);

  List<Veggie> availableVeggies() {
    var currentSeason = _getSeasonForDate(DateTime.now());
    return state.where((v) => v.seasons.contains(currentSeason)).toList();
  }

  List<Veggie> get unavailableVeggies {
    var currentSeason = _getSeasonForDate(DateTime.now());
    return state.where((v) => !v.seasons.contains(currentSeason)).toList();
  }

  List<Veggie> favouriteVeggies() => state.where((v) => v.isFavorite).toList();

  List<Veggie> searchVeggies(String terms) {
    return state
        .where((v) => v.name.toLowerCase().contains(terms.toLowerCase()))
        .toList();
  }

  void setFavourite(int id, bool isFavourite) {
    state = [
      for (final v in state)
        if (v.id == id) v.copyWith(isFavorite: isFavourite) else v
    ];
  }

  /// Technically the start and end dates of seasons can vary by a day or so, but this is close enough for produce.
  static Season _getSeasonForDate(DateTime date) {
    return switch (date.month) {
      1 => Season.winter,
      2 => Season.winter,
      3 => date.day < 21 ? Season.winter : Season.spring,
      4 => Season.spring,
      5 => Season.spring,
      6 => date.day < 21 ? Season.spring : Season.summer,
      7 => Season.summer,
      8 => Season.summer,
      9 => date.day < 21 ? Season.summer : Season.autumn,
      10 => Season.autumn,
      11 => Season.autumn,
      12 => date.day < 21 ? Season.autumn : Season.winter,
      _ =>
        throw ArgumentError('Can\'t return a season for month #${date.month}.')
    };
  }
}
