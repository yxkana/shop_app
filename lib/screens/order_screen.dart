import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as org;
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/order-screen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetProduct();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Orders>(builder: ((context, orderData, child) {
                if (orderData.orders.isEmpty) {
                  return const Center(
                    child: Text("No orders"),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      org.OrderItem(orderData.orders[index]),
                  itemCount: orderData.orders.length,
                );
              }));
            }
          },
        ));
  }
}
