import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_order/auth/MainPage.dart';


class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final user = FirebaseAuth.instance.currentUser!;

  void navigateToMainPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => MainPage(),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                navigateToMainPage(context);
              },
              color: Colors.deepPurple[200],
              child: Text('Sing out'),
            )
          ],
        ),
      ),
    );
  }
}
