import 'package:flutter/material.dart';

class Offer {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;

  Offer({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.price,
  });
}
