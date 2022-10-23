// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProduct() async {
    print(userId);
    final filteringString = 'orderBy="creatorId"&equalTo="$userId"';
    final url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken&$filteringString");

    final response = await http.get(url);
    if (json.decode(response.body) == null) {
      return;
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrder = [];

    extractedData.forEach((prodID, prodData) {
      loadedOrder.add(OrderItem(
          id: prodID,
          amount: prodData["amount"],
          products: (prodData["cartProduct"] as List<dynamic>)
              .map((item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"],
                  imgUrl: ""))
              .toList(),
          dateTime: DateTime.parse(prodData["dateTime"])));
    });
    _orders = loadedOrder.reversed.toList();

    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken");
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            "creatorId": userId,
            "amount": total,
            "dateTime": timestamp.toIso8601String(),
            "cartProduct": cartProduct
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "price": e.price,
                      "quantity": e.quantity
                    })
                .toList()
          }));
      final newOrder = OrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        products: cartProduct,
        dateTime: timestamp,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      print("error happened");
      throw error;
    }
  }
}
