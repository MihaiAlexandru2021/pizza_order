class CartData{
  final List<Map<String,dynamic>>? pizza;
  final String? userId;

  CartData({
    this.pizza,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
    'pizza': pizza,
    'userId': userId
  };

  static CartData fromJson(Map<String, dynamic> json) => CartData(
    pizza: json['pizza'],
    userId: json['userId']
  );

}