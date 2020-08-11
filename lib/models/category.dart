import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String id;
  final String name;
  final String image;
  final String addedBy;

  Category(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.addedBy});
}
