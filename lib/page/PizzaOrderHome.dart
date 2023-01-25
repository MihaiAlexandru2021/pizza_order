import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pizza_order/Pizza.dart';
import 'package:pizza_order/data/PizzaFirebase.dart';
import 'package:pizza_order/page/PizzaOrderDetails.dart';

import '../Pizza.dart';
import '../element/MyAppBar.dart';
import '../element/PizzaListItemInfo.dart';

const cardColor = Color(0xFFF5EED3);
const backColor = Colors.white;
final random = math.Random();
final storageRef = FirebaseStorage.instance.ref();

class PizzaOrderHome extends StatefulWidget {
  const PizzaOrderHome({Key? key}) : super(key: key);

  @override
  State<PizzaOrderHome> createState() => _PizzaOrderHomeState();
}

class _PizzaOrderHomeState extends State<PizzaOrderHome> {
  final user = FirebaseAuth.instance.currentUser!;
  late PageController pageController;
  double scrollOfSet = 0.0;
  PizzaFirebase? pizzaSelected;
  late String itemSelected;

  List<String> pizzaIds = [];

  void navigateToDetailsPage(BuildContext context, PizzaFirebase pizza) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PizzaOrderDetails(
            pizza: pizza,
          ),
        ));
  }

  Stream<List<PizzaFirebase>> readPizza() => FirebaseFirestore.instance
      .collection('pizza')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((e) => PizzaFirebase.fromJson(e.data())).toList());

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: .6);
    pageController.addListener(() {
      setState(() => scrollOfSet = pageController.page!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
        backgroundColor: backColor,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: size.width * .8,
                height: size.height * .85,
                decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(size.width / 2),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [backColor, cardColor.withOpacity(.8)],
                        stops: const [.33, 1])),
              ),
            ),
            StreamBuilder<List<PizzaFirebase>>(
              stream: readPizza(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final pizzas = snapshot.data!;

                  return PageView.builder(
                        itemCount: pizzas.length,
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() => pizzaSelected = pizzas[index]);
                        },
                        itemBuilder: (context, index) {
                          double alignment =
                          math.exp(-math.pow(scrollOfSet - index, -4) / pizzas.length);
                          bool fromLeft = scrollOfSet.round() > index;

                          final item = pizzas.elementAt(index);

                          return Align(
                            alignment: Alignment(0, alignment),
                            child: Transform.rotate(
                              angle: fromLeft ? (alignment * .6) : -(alignment * .6),
                              child: GestureDetector(
                                onTap: () => navigateToDetailsPage(context, item),
                                child: Container(
                                  width: 160 - alignment * 5,
                                  height: 160 - alignment * 5,
                                  decoration: BoxDecoration(
                                      image:
                                      DecorationImage(image: NetworkImage(item.image!))),
                                ),
                              ),
                            ),
                          );
                        });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            ),
            Center(
                child: Padding(
                padding: EdgeInsets.only(top: size.height * .67),
                child: PizzaListItemInfo(
                  pizza: pizzaSelected,
                ),
            )),
            MyAppBar(title: user.email)
          ],
        ),
    ));
  }

  Widget buildPizza( PizzaFirebase pizza) => ListTile(
    leading: CircleAvatar(child: Image.network(pizza.image!)),
    title: Text(pizza.name!),
    subtitle: Text(pizza.price.toString()),
  );
}

