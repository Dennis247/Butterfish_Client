import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider_pattern/helpers/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false,
      this.categoryId});

  void _setFavouriteStatus(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  void toogleFavouriteStatus(String authToken, String userId) async {
    var oldStatus = isFavourite;
    final url = Constants.firebaseUrl +
        "/userFavourites/$userId/$id.json?auth=$authToken";
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400) {
        _setFavouriteStatus(oldStatus);
      }
    } catch (error) {
      _setFavouriteStatus(oldStatus);
    }
  }
}
