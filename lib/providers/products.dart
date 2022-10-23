import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exceptions.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  var _showFavoriteOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items1 {
    return [..._items]; //return copy of _items
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString");

    final response = await http.get(url);
    if (json.decode(response.body) == null) {
      return;
    }

    url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/userFavorie/$userId.json?auth=$authToken");
    final favoriteResponse = await http.get(url);

    final favoriteData = json.decode(favoriteResponse.body);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProduct = [];
    extractedData.forEach((prodId, prodData) {
      loadedProduct.add(Product(
        id: prodId,
        title: prodData["title"],
        description: prodData["description"],
        price: prodData["price"],
        imageUrl: prodData["imageUrl"],
        isFavorite:
            favoriteData == null ? false : favoriteData[prodId] ?? false,
      ));
    });
    _items = loadedProduct;
    notifyListeners();
  }

  Future<void> addProduct(
    Product product,
  ) async {
    final url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken");

    try {
      final response = await http.post(url,
          body: json.encode({
            "creatorId": userId,
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
          }));
      final newProduct = Product(
          id: json.decode(response.body)["name"].toString(),
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      print(newProduct.id);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //execute this code below after we get response from server

  //http.post needs url and what type of data are we postig

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    try {
      if (prodIndex >= 0) {
        final url = Uri.parse(
            "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken");
        await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "imageUrl": newProduct.imageUrl,
              "price": newProduct.price,
            }));
        _items[prodIndex] =
            newProduct; //Nahrazení stavajícího produktu novým upraveným
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken");
    final deletedItemIndex = _items.indexWhere((element) => element.id == id);
    Product? deletedItem =
        _items[deletedItemIndex]; //Item schovaný v paměti aplikace

    _items.removeAt(deletedItemIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(deletedItemIndex, deletedItem);
      notifyListeners();
      throw HttpExceptions("Could not delete message");
    }
    deletedItem = null;
  }

  Product findID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
