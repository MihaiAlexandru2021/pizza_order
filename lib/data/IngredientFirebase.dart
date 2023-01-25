import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientFirebase{
  final String? name;
  final String? image;
  final String? imageUnit;
  final Array? position;


  IngredientFirebase({
    this.name,
    this.image,
    this.imageUnit,
    this.position
  });

  factory IngredientFirebase.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return IngredientFirebase(
        name: data?['name'],
        imageUnit: data?['image_unit'],
        image: data?['image'],
        position: data?['position']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (imageUnit != null) "image_unit": imageUnit,
      if (image != null) "image": image,
      if (position != null) "position": position
    };
  }
}