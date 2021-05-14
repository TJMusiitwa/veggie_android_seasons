import 'package:flutter/material.dart' show Color;

enum VeggieCategory {
  allium,
  berry,
  citrus,
  cruciferous,
  fern,
  flower,
  fruit,
  fungus,
  gourd,
  leafy,
  legume,
  melon,
  root,
  stealthFruit,
  stoneFruit,
  tropical,
  tuber,
  vegetable,
}

enum Season {
  winter,
  spring,
  summer,
  autumn,
}

class Trivia {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  Trivia(this.question, this.answers, this.correctAnswerIndex);
}

const Map<VeggieCategory, String> veggieCategoryNames = {
  VeggieCategory.allium: 'Allium',
  VeggieCategory.berry: 'Berry',
  VeggieCategory.citrus: 'Citrus',
  VeggieCategory.cruciferous: 'Cruciferous',
  VeggieCategory.fern: 'Technically a fern',
  VeggieCategory.flower: 'Flower',
  VeggieCategory.fruit: 'Fruit',
  VeggieCategory.fungus: 'Fungus',
  VeggieCategory.gourd: 'Gourd',
  VeggieCategory.leafy: 'Leafy',
  VeggieCategory.legume: 'Legume',
  VeggieCategory.melon: 'Melon',
  VeggieCategory.root: 'Root vegetable',
  VeggieCategory.stealthFruit: 'Stealth fruit',
  VeggieCategory.stoneFruit: 'Stone fruit',
  VeggieCategory.tropical: 'Tropical',
  VeggieCategory.tuber: 'Tuber',
  VeggieCategory.vegetable: 'Vegetable',
};

const Map<Season, String> seasonNames = {
  Season.winter: 'Winter',
  Season.spring: 'Spring',
  Season.summer: 'Summer',
  Season.autumn: 'Autumn',
};

class Veggie {
  final int id;
  final String name;
  final String imageAssetPath;
  final VeggieCategory category;
  final String shortDescription;
  final Color accentColor;
  final List<Season> seasons;
  final int vitaminAPercentage;
  final int vitaminCPercentage;
  final String servingSize;
  final int caloriesPerServing;
  bool isFavorite;
  final List<Trivia> trivia;

  Veggie(
      {required this.id,
      required this.name,
      required this.imageAssetPath,
      required this.category,
      required this.shortDescription,
      required this.accentColor,
      required this.seasons,
      required this.vitaminAPercentage,
      required this.vitaminCPercentage,
      required this.servingSize,
      required this.caloriesPerServing,
      required this.trivia,
      this.isFavorite = false});
  String? get categoryName => veggieCategoryNames[category];
}
