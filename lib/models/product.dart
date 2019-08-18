import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  String description;
  num price;
  Map<String, dynamic> picture;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    this.picture,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'picture': picture
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      picture: json['picture'],
    );
  }
}
