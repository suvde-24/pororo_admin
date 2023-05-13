import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String title;
  String? description;
  String storeId;
  List<String> image;
  double price;
  double? discount;
  int? quantity;
  double? rate;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.storeId,
    required this.image,
    required this.price,
    this.discount,
    this.quantity,
    this.rate,
  });

  double get discountedTotalPrice => price - (discount ?? 0);

  factory Product.fromSnapshot(DocumentSnapshot data) {
    dynamic json = data.data();
    return Product(
      id: data.id,
      title: json['product_name'],
      storeId: json['seller_id'],
      image: (json['product_images'] as List).map((e) => '$e').toList(),
      price: (json['product_price'] as int).toDouble(),
      quantity: json['product_quantity'],
      discount: ((json['discount'] as int?) ?? 0).toDouble(),
      description: json['product_description'],
    );
  }
}
