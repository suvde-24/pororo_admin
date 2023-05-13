import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'database.dart';
import 'order.dart' as model;
import 'order_widget.dart';
import 'utils/b_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  CollectionReference orders = Database.firestore.collection('orders');
  CollectionReference orderItems = Database.firestore.collection('order_items');
  CollectionReference transactions = Database.firestore.collection('transactions');
  CollectionReference shipping = Database.firestore.collection('shipping');
  List<model.Order> allOrders = [];
  List<model.OrderStatus> filterStatus = model.OrderStatus.values;

  @override
  void initState() {
    getOrders();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  getOrders() async {
    final result = await orders.get();
    List<model.Order> data = result.docs.map((e) => model.Order.fromSnapshot(e)).toList();
    for (var item in data) {
      final result = await orderItems.where('order_id', isEqualTo: item.id).get();
      List<model.OrderItem> items = result.docs.map((e) => model.OrderItem.fromSnapshot(e)).toList();
      item.orderItems = items;
    }
    setState(() {
      allOrders = data;
    });
  }

  void updateOrder(Map<String, dynamic> options, {required model.Order order, required model.OrderStatus newStatus}) async {
    EasyLoading.show(status: 'Түр хүлээнэ үү...');
    await orders.doc(order.id).update(options);
    if (options['status'] == 'paid' || options['status'] == 'canceled') {
      await transactions.doc(order.transactionId).update(options);
      if (order.status == model.OrderStatus.canceled) {
        await shipping.doc(order.shippingId).update({'shipping_status': 'canceled', 'modified_at': Timestamp.now()});
      }
    }
    if (options['status'] == 'shipping') {
      await shipping.doc(order.shippingId).update({'shipping_status': 'shipping', 'modified_at': Timestamp.now()});
    }
    if (options['status'] == 'completed') {
      await shipping.doc(order.shippingId).update({'shipping_status': 'completed', 'modified_at': Timestamp.now()});
    }

    final canceledOrder = allOrders.firstWhere((e) => e.id == order.id);
    canceledOrder.status = newStatus;
    allOrders = [...allOrders.where((e) => e.id != order.id).toList(), canceledOrder];
    EasyLoading.dismiss();
    setState(() {});

    return;
  }

  @override
  Widget build(BuildContext context) {
    List<model.Order> filteredOrders = allOrders.where((e) => filterStatus.contains(e.status)).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Пороро админ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: BColors.primaryBlueOcean),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: model.OrderStatus.values.map((e) {
              Color color;
              switch (e) {
                case model.OrderStatus.pending:
                  color = BColors.primaryOrangeFresh;
                  break;
                case model.OrderStatus.canceled:
                  color = BColors.secondaryRedVelvet;
                  break;
                case model.OrderStatus.completed:
                  color = BColors.secondaryEarthGreen;
                  break;
                case model.OrderStatus.paid:
                  color = BColors.primaryBlueOcean;
                  break;
                case model.OrderStatus.shipping:
                  color = Colors.purple;
                  break;
              }
              return Expanded(
                child: IconButton(
                  onPressed: () {
                    if (filterStatus.contains(e)) {
                      filterStatus = filterStatus.where((el) => e != el).toList();
                    } else {
                      filterStatus = [...filterStatus, e];
                    }
                    setState(() {});
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                      color: filterStatus.contains(e) ? color : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                    ),
                    height: 20,
                    width: 20,
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredOrders.length,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              itemBuilder: (context, index) {
                return OrderWidget(
                  order: filteredOrders.elementAt(index),
                  updateOrder: (p0, newStatus) {
                    updateOrder(p0, order: filteredOrders.elementAt(index), newStatus: newStatus);
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(color: BColors.secondarySoftGrey, height: 30, thickness: 1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) getOrders();
    super.didChangeAppLifecycleState(state);
  }
}
