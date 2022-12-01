import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pizza_order/Ingredient.dart';


enum PizzaSizeValue { S, M, L }

class PizzaSizeState {
  PizzaSizeState(this.value) : factor = _getFactoryBySize(value);

  final PizzaSizeValue value;
  final double factor;

  static double _getFactoryBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.S:
        return 0.75;
      case PizzaSizeValue.M:
        return 0.85;
      case PizzaSizeValue.L:
        return 1.0;
    }
  }
}

class PizzaMetadata {

  const PizzaMetadata(this.imageBytes, this.position, this.size);

  final Uint8List imageBytes;
  final Offset position;
  final Size size;

}

class PizzaOrderBlock extends ChangeNotifier{
  final notifierPizzaPrice = ValueNotifier(0) as ValueNotifier<int?>;
  final listIngredients = <Ingredient>[];
  ValueNotifier<int> notifierTotal = ValueNotifier(0);
  late final notifierDeletedIngredient = ValueNotifier<Ingredient?>(null);
  final notifierFocused = ValueNotifier(false);
  final notifierPizzaSize = ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.M));
  final notifierPizzaBoxAnimation = ValueNotifier(false);
  final notifierPizzaImage = ValueNotifier<PizzaMetadata?>(null);
  final notifierCartIconAnimation = ValueNotifier(0);

  void addIngredient(Ingredient ingredient){
    listIngredients.add(ingredient);
    notifierTotal.value++;
  }

  void removeIngredient(Ingredient ingredient){
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeletedIngredient.value = ingredient ;
  }

  void refreshRemoveIngredient() {
    notifierDeletedIngredient.value = null;
  }

  bool containsIngredient(Ingredient ingredient){
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    notifierPizzaBoxAnimation.value = false;
    notifierPizzaImage.value = null;
    listIngredients.clear();
    notifierTotal.value = notifierPizzaPrice.value!;
    notifierCartIconAnimation.value++;
  }

  void startPizzaBoxAnimation() {
    notifierPizzaBoxAnimation.value = true;
  }

  Future<void> transformToImage(RenderRepaintBoundary boundary) async{
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    notifierPizzaImage.value = PizzaMetadata(byteData!.buffer.asUint8List(), position, size);
  }

}