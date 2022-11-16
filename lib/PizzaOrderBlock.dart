import 'package:flutter/material.dart';
import 'package:pizza_order/Ingredient.dart';

class PizzaOrderBlock extends ChangeNotifier{
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(15);
  late final notifierDeletedIngredient = ValueNotifier<Ingredient?>(null) ;

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

}