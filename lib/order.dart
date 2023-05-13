import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product.dart';
import 'product_controller.dart';

enum OrderStatus {
  pending,
  paid,
  shipping,
  completed,
  canceled,
}

class Order {
  String id;
  Timestamp createdAt;
  Timestamp modifiedAt;
  String customerId;
  String? shippingId;
  OrderStatus status;
  double totalPayment;
  String? transactionId;

  late List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
    required this.customerId,
    required this.status,
    required this.totalPayment,
    this.shippingId,
    this.transactionId,
  });

  factory Order.fromSnapshot(DocumentSnapshot data) {
    dynamic json = data.data();
    OrderStatus orderStatus;
    switch (json['status']) {
      case 'paid':
        orderStatus = OrderStatus.paid;
        break;
      case 'shipping':
        orderStatus = OrderStatus.shipping;
        break;
      case 'completed':
        orderStatus = OrderStatus.completed;
        break;
      case 'canceled':
        orderStatus = OrderStatus.canceled;
        break;
      case 'pending':
      default:
        orderStatus = OrderStatus.pending;
        break;
    }
    return Order(
      id: data.id,
      createdAt: json['created_at'],
      modifiedAt: json['modified_at'],
      customerId: json['customer_id'],
      status: orderStatus,
      totalPayment: json['total_payment'],
      shippingId: json['shipping_id'],
      transactionId: json['transaction_id'],
    );
  }
}

class OrderItem {
  String id;
  Timestamp createdAt;
  String orderId;
  String productId;
  int count;

  ValueNotifier<Product?> product = ValueNotifier(null);

  OrderItem({
    required this.id,
    required this.createdAt,
    required this.orderId,
    required this.productId,
    required this.count,
    Product? product,
  }) {
    this.product.value = product;
    if (this.product.value == null) fetchProductData();
  }

  factory OrderItem.fromSnapshot(DocumentSnapshot data) {
    dynamic json = data.data();
    return OrderItem(
      id: data.id,
      createdAt: json['created_at'],
      orderId: json['order_id'],
      productId: json['product_id'],
      count: json['quantity'],
    );
  }

  void fetchProductData() async {
    if (product.value != null) return;

    product.value = await ProductController().getProduct(productId);
  }
}
