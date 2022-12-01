import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizza_order/PizzaOrderHome.dart';

void main() {
  runApp(const MainPizzaOrderApp());
}

class MainPizzaOrderApp extends StatelessWidget {
  const MainPizzaOrderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      theme: ThemeData.light(),
      home: PizzaOrderHome()
    );
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

