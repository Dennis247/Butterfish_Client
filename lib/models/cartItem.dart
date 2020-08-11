import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imgUrl;

  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.imgUrl});
}
