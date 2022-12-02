import 'package:flutter/material.dart';

import 'PizzaOrderBlock.dart';

class PizzaOrderProvider extends InheritedWidget {

  final PizzaOrderBlock block;
  final Widget child;

  PizzaOrderProvider({required this.block, required this.child}): super(child: child);


  static PizzaOrderBlock? of(BuildContext context) => context.findAncestorWidgetOfExactType<PizzaOrderProvider>()?.block;


  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

}