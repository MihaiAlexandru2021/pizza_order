class PizzaFirebase{
  final String? name;
  final String? image;
  final int? price;

  PizzaFirebase({
    this.name,
    this.image,
    this.price,
});

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'price': price,
  };

  static PizzaFirebase fromJson(Map<String, dynamic> json) => PizzaFirebase(
    name: json['name'],
    image: json['image'],
    price: json['price'],
  );

}