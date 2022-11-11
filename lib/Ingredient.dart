import 'package:flutter/cupertino.dart';

class Ingredient {
  const Ingredient(
      this.image,
      this.imageUnit,
      this.position);

  final String image;
  final String imageUnit;
  final List<Offset> position;
  bool compare(Ingredient ingredient) => ingredient.image == image;
}

const ingredients = <Ingredient> [
  Ingredient(
    'assets/images/chili.png',
    'assets/images/chili_unit',
    <Offset>[
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.22),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'assets/images/mushroom.png',
    'assets/images/mushroom_unit',
    <Offset>[
      Offset(0.2, 0.35),
      Offset(0.65, 0.35),
      Offset(0.3, 0.23),
      Offset(0.5, 0.2),
      Offset(0.3, 0.5),
    ],
  ),
  Ingredient(
    'assets/images/olive.png',
    'assets/images/olive_unit',
    <Offset>[
      Offset(0.25, 0.5),
      Offset(0.65, 0.6),
      Offset(0.2, 0.3),
      Offset(0.4, 0.2),
      Offset(0.2, 0.6),
    ],
  ),
  Ingredient(
    'assets/images/onion.png',
    'assets/images/onion.png',
    <Offset>[
      Offset(0.2, 0.65),
      Offset(0.65, 0.3),
      Offset(0.25, 0.25),
      Offset(0.45, 0.35),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'assets/images/pea.png',
    'assets/images/pea_unit.png',
    <Offset>[
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.22),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'assets/images/pickle.png',
    'assets/images/pickle_unit.png',
    <Offset>[
      Offset(0.2, 0.65),
      Offset(0.65, 0.3),
      Offset(0.25, 0.25),
      Offset(0.45, 0.35),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'assets/images/potato.png',
    'assets/images/potato_unit.png',
    <Offset>[
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.25),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
];