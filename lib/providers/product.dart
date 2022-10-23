import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> saveFavorite(String id, String userId, String token) async {
    final url = Uri.parse(
        "https://flutter-test-shopapp-d2a6a-default-rtdb.europe-west1.firebasedatabase.app/userFavorie/$userId/$id.json?auth=$token");
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        print(json.decode(response.body));
      }

      notifyListeners();
    } catch (error) {
      print("setFavorite error accure");
      print(error);
      throw error;
    }
  }

  void toggleFavoriteStatus() {
    //Invert value of isFavorite, pokažde když se metoda vyvola změní se bool hodnota
    isFavorite = !isFavorite;
    print(isFavorite);
    notifyListeners();
  }
}
