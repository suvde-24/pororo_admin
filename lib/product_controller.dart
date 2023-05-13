import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';
import 'product.dart';

class ProductController {
  // Өгөгдлийн сангийн products table хандаж байгаа
  CollectionReference products = Database.firestore.collection('products');

  Future<Product> getProduct(String productId) async {
    final result = await products.doc(productId).get();
    Product product = Product.fromSnapshot(result);

    return product;
  }
}
