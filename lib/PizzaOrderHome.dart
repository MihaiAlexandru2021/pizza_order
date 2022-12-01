import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pizza_order/Pizza.dart';
import 'package:pizza_order/PizzaCartIcon.dart';
import 'package:pizza_order/PizzaOrderDetails.dart';

import 'Pizza.dart';

final cardColor = Color(0xFFF5EED3);
final backColor = Colors.white;
final random = Random();

class PizzaOrderHome extends StatefulWidget {
  @override
  State<PizzaOrderHome> createState() => _PizzaOrderHomeState();
}

class _PizzaOrderHomeState extends State<PizzaOrderHome> {
  final List<Pizza> items = [];
  late PageController pageController;
  double scrollOfSet = 0.0;
  late Pizza pizzaSelected;

  void navigateToDetailsPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => PizzaOrderDetails(pizza: pizzaSelected,),
    ));
  }

  void populatePizzas() {
    if (items.isNotEmpty) {
      return;
    }
    for (int i = 0; i < pizzaAssets.length; i++) {
      items.add(Pizza(
        pizzaAssets.keys.elementAt(i),
        pizzaAssets.values.elementAt(i),
        random.nextInt(5),
        114 * random.nextDouble(),
      ));
    }
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: .6);
    pageController.addListener(() {
      setState(() => scrollOfSet = pageController.page!);
    });

    populatePizzas();
    pizzaSelected = items.first;
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
                      stops: [.33, 1])),
            ),
          ),
          PageView.builder(
              itemCount: items.length,
              controller: pageController,
              onPageChanged: (index) {
                setState(() => pizzaSelected = items[index]);
              },
              itemBuilder: (context, index) {
                double alignment =
                    math.exp(-math.pow(scrollOfSet - index, -4) / items.length);
                bool fromLeft = scrollOfSet.round() > index;

                final item = items.elementAt(index);

                return Align(
                  alignment: Alignment(0, alignment),
                  child: Transform.rotate(
                    angle: fromLeft ? (alignment * .6) : -(alignment * .6),
                    child: GestureDetector(
                      onTap: () => navigateToDetailsPage(context),
                      child: Container(
                        width: 160 - alignment * 5,
                        height: 160 - alignment * 5,
                        decoration: BoxDecoration(
                            image:
                                DecorationImage(image: AssetImage(item.image))),
                      ),
                    ),
                  ),
                );
              }),
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: size.height * .67),
            child: PizzaListItemInfo(
              pizza: pizzaSelected,
            ),
          )),
          MyAppBar(title: 'Order Normally')
        ],
      ),
    )
    );
  }
}

class PizzaListItemInfo extends StatelessWidget {
  const PizzaListItemInfo({Key? key, required this.pizza}) : super(key: key);

  final Pizza pizza;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          pizza.name,
          style: Theme.of(context)
              .textTheme
              .headline4,
        ),
        TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: pizza.price),
            duration: Duration(milliseconds: 500),
            builder: (context, price, child) {
              return Text(
                '${price.toInt()}\$',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,),
              );
            })
      ],
    );
  }
}

class MyAppBar extends StatelessWidget {
  final String title;

  const MyAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          16, 16, 16, 0
      ),
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headline6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18,),
                    Text('Romania, Bucharest', style: Theme.of(context).textTheme.headline6)
                  ],
                )
              ],
            ),
            PizzaCartIcon()
          ],
        ),
      ),
    );
  }
}
