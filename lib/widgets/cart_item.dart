import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import "../providers/cart.dart";
import './cart_item.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  late final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int localQuantity = 0;
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);

    return Container(
      padding: EdgeInsets.only(bottom: 8, top: 8),
      child: Slidable(

          //Slideable Start
          startActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  cartData.removeItem(widget.productId);
                },
                backgroundColor: Colors.redAccent,
                icon: Icons.delete,
              ),
              SlidableAction(
                onPressed: ((context) {
                  setState(() {
                    if (widget.quantity > 1) {
                      cartData.deleteItem(
                        widget.productId,
                      );
                      print(widget.quantity);
                    } else {
                      cartData.removeItem(widget.productId);
                    }
                  });
                }),
                icon: Icons.remove,
                backgroundColor: Colors.yellowAccent,
              ),
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    cartData.plusItem(widget.productId, widget.price,
                        widget.title, widget.quantity);
                  });
                },
                icon: Icons.add,
                backgroundColor: Colors.greenAccent,
              )
            ],
          ),
          child: CartItemWidget(
            price: widget.price,
            title: widget.title,
            quantity: widget.quantity,
          )),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    Key? key,
    required this.price,
    required this.title,
    required this.quantity,
  }) : super(key: key);

  final double price;
  final String title;
  final int quantity;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      color: Color.fromARGB(255, 250, 248, 245),
      child: ListTile(
        leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: FittedBox(
                child: Text(
              "\$${widget.price}",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ))),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Total: \$${((widget.price * widget.quantity).toStringAsFixed(2))}",
        ),
        trailing: Consumer(
          builder: (context, value, child) => Text(
            "${widget.quantity.toString()} x",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
