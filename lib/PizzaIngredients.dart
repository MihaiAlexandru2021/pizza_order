import 'package:flutter/material.dart';
import 'package:pizza_order/PizzaOrderProvider.dart';

import 'Ingredient.dart';

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final block = PizzaOrderProvider.of(context);
    return ValueListenableBuilder(
        valueListenable: block!.notifierTotal,
        builder: (context, value, _) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return PizzaIngredientItem(
                  ingredient: ingredient,
                  exist: block.containsIngredient(ingredient),
                  onTap: () {
                    block.removeIngredient(ingredient);
                  },
                );
              });
        });
  }
}

class PizzaIngredientItem extends StatelessWidget {
  const PizzaIngredientItem(
      {Key? key,
        required this.ingredient,
        required this.exist,
        required this.onTap})
      : super(key: key);
  final Ingredient ingredient;
  final bool exist;
  final VoidCallback onTap;

  Widget _buildChild({bool withImage = true}) {
    return GestureDetector(
      onTap: exist ? onTap: null,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Color(0xFFF5EED3),
                shape: BoxShape.circle,
                border: exist ? Border.all(color: Colors.red, width: 2) : null),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(ingredient.image, fit: BoxFit.contain),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: exist
            ? _buildChild()
            : Draggable(
                feedback: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.black26,
                          offset: Offset(0.0, 5.0),
                          spreadRadius: 5.0)
                    ],
                  ),
                  child: _buildChild(),
                ),
                data: ingredient,
                child: _buildChild()));
  }
}
