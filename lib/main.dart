import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/MainPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainPizzaOrderApp());
}

class MainPizzaOrderApp extends StatelessWidget {
  const MainPizzaOrderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      theme: ThemeData.light(),
      home: MainPage()
    );
  }

  /*
  TODO: add circular loading if Pizza is not ready 
  Connect details PizzaDetails to Firebase
  Solve problem with positioned indgredients
  show error in LoginPage if incoreclty pass
  add regex for registerPage


//  COURSE FIREBASE https://www.youtube.com/watch?v=idJDAdn_jKk&list=PLlvRDpXh1Se4wZWOWs8yapI8AS_fwDHzf&index=6&ab_channel=MitchKoko video 7
// CRUD FIREBASE https://www.youtube.com/watch?v=ErP_xomHKTw
   */
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

