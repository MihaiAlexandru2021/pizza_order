import 'package:flutter/material.dart';

import '../page/ProfileSettings.dart';
import 'PizzaCartIcon.dart';

class MyAppBar extends StatelessWidget {
  final String? title;

  const MyAppBar({required this.title});

  void navigateToSettingsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileSettings(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!, style: Theme.of(context).textTheme.headline6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                    ),
                    Text('Romania, Bucharest',
                        style: Theme.of(context).textTheme.headline6)
                  ],
                ),
              ],
            ),
            const PizzaCartIcon(),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  navigateToSettingsPage(context);
                }
            )
          ],
        ),
      ),
    );
  }
}