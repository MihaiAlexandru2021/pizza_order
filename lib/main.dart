import 'package:flutter/material.dart';
import 'package:pizza_order/PizzaOrderDetails.dart';

void main() {
  runApp(MainPizzaOrderApp());
}

class MainPizzaOrderApp extends StatelessWidget {
  const MainPizzaOrderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: PizzaOrderDetails()
    );
  }
}

