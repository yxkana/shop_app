import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  String id;
  String title;
  int quantity;
  double price;
  String imgUrl;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.imgUrl});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  //Items in save In shopping Cart
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    //Diky tomuto můžem zobrazit koliž položek se zrovna bude nacházet v košíku
    return _items.length;
  }

  int get itemQuantity {
    var quant = 0;
    _items.forEach((key, value) {
      value.quantity == quant;
    });
    return quant;
  }

  String get id {
    String getId = "";
    _items.forEach((key, value) {
      value.id == getId;
    });
    return getId;
  }

  String get title {
    String getTitle = "";
    _items.forEach((key, value) {
      value.title = getTitle;
    });
    return getTitle;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  get widget => null;

  void addItem(String productId, double price, String title, String imgUrl) {
    if (_items.containsKey(productId)) {
      //checking if item witch same id isnt there
      _items.update(
          //If true, we update map
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imgUrl: existingCartItem.imgUrl,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
        //adding new Entry to map if product Id is missing putIfAbsent desire uniqe syntax we can se here
        productId, //
        (() => CartItem(
            //For putIfAbsent we can create anonym func. which return Cart Item
            id: productId,
            title: title,
            price: price,
            imgUrl: imgUrl,
            quantity:
                1)), //Becouse we creating new CartItem we set quantity to 1
      );
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    if (_items.containsKey(productId)) {
      //checking if item witch same id isnt there
      _items.update(
          //If true, we update map
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imgUrl: existingCartItem.imgUrl,
              quantity: existingCartItem.quantity - 1));
    }
    notifyListeners();
  }

  void deleteSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      //checking if item witch same id isnt there
      _items.update(
          //If true, we update map
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imgUrl: existingCartItem.imgUrl,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void plusItem(String productId, double price, String title, int quantity) {
    if (_items.containsKey(productId)) {
      //checking if item witch same id isnt there
      _items.update(
          //If true, we update map
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imgUrl: existingCartItem.imgUrl,
              quantity: existingCartItem.quantity + 1));
    }
    notifyListeners();
  }

  void removeItem(String mapKey) {
    _items.remove(mapKey);
    notifyListeners();
  }

  void clearCartList() {
    _items = {};
    notifyListeners();
  }
}
