import 'package:flutter/material.dart' show Color;

enum VeggieCategory {
  allium('Allium'),
  berry('Berry'),
  citrus('Citrus'),
  cruciferous('Cruciferous'),
  fern('Technically a fern'),
  flower('Flower'),
  fruit('Fruit'),
  fungus('Fungus'),
  gourd('Gourd'),
  leafy('Leafy'),
  legume('Legume'),
  melon('Melon'),
  root('Root vegetable'),
  stealthFruit('Stealth fruit'),
  stoneFruit('Stone fruit'),
  tropical('Tropical'),
  tuber('Tuber'),
  vegetable('Vegetable');

  const VeggieCategory(this.name);
  final String name;
}

enum Season {
  winter('Winter'),
  spring('Spring'),
  summer('Summer'),
  autumn('Autumn');

  const Season(this.seasonName);
  final String seasonName;
}

class Trivia {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  Trivia(this.question, this.answers, this.correctAnswerIndex);
}

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
}
