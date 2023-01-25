import 'package:flutter/material.dart';

import '../data/PizzaFirebase.dart';

class PizzaListItemInfo extends StatelessWidget {
  const PizzaListItemInfo({Key? key, required this.pizza}) : super(key: key);

  final PizzaFirebase? pizza;

  @override
  Widget build(BuildContext context) {
    if (pizza != null) {
      return Column(
        children: [
          Text(
            pizza!.name!,
            style: Theme
                .of(context)
                .textTheme
                .headline4,
          ),
          TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: pizza!.price!.toDouble()),
              duration: const Duration(milliseconds: 500),
              builder: (context, price, child) {
                return Text(
                  '${price.toInt()}\$',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6!
                      .copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                );
              })
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}