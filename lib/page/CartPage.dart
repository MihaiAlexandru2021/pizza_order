import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_order/data/CartData.dart';
import 'package:pizza_order/data/PizzaFirebase.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<CartData>>(
        stream: readCart(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final pizzas = snapshot.data!;
            pizzas.length;
            return ListView(
              children: pizzas.map(buildCart).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildCart(CartData cart) => ListTile(
    title: Text(cart.userId!),
    subtitle: Text(cart.pizza.toString()),
  );

  Stream<List<CartData>> readCart() => FirebaseFirestore.instance
      .collection('cart')
      .where('user_id', isEqualTo: _auth.currentUser!.uid)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((e) => CartData.fromJson(e.data())).toList());
}
