import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pizza_order/PizzaOrderHome.dart';

import 'AuthPage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            print('MainPage');
            if (snapshot.hasData) {
              return PizzaOrderHome();
            } else {
              return AuthPage();
            }
          }
        )
    );
  }
}