import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
          subtitle: Text(
              DateFormat("dd MM yyyy hh:mm").format(widget.order.dateTime)),
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less)),
        ),
        if (_expanded)
          Container(
              height: min(widget.order.products.length * 20 + 50, 100),
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.only(right: 17, left: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.order.products[index].title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: Text(
                                "${widget.order.products[index].quantity}x    ${(widget.order.products[index].price * widget.order.products[index].quantity).toStringAsFixed(2)} \$",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ))))
      ]),
    );
  }
}
