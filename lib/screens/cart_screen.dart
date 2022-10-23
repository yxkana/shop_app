import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../providers/cart.dart" show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class Cart_Screen extends StatelessWidget {
  const Cart_Screen({Key? key}) : super(key: key);
  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final orderData = Provider.of<Orders>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: Text("Cart List")),
        body: Column(
          children: [
            Card(
              elevation: 10,
              color: Color.fromARGB(217, 255, 255, 255),
              margin: EdgeInsets.all(15),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        "\$${cartData.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: ClipOval(
                        child: TextButton(
                          onPressed: () {
                            if (cartData.items.length == 0) {
                              null;
                            } else {
                              orderData.addOrder(cartData.items.values.toList(),
                                  cartData.totalAmount);
                              cartData.clearCartList();
                            }
                          },
                          child: Text(
                            "Order Now",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text("Are you sure ?"),
                                    content: Text(
                                        "Do you want remove items from a cart"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            cartData.clearCartList();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Yes")),
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ));
                        },
                        child: Text("Delete Order"))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5),
              itemBuilder: ((context, i) => CartItem(
                  cartData.items.values.toList()[i].id,
                  cartData.items.keys.toList()[i],
                  cartData.items.values.toList()[i].price,
                  cartData.items.values.toList()[i].quantity,
                  cartData.items.values.toList()[i].title)),
              itemCount: cartData.itemCount,
            ))
          ],
        ));
  }
}
