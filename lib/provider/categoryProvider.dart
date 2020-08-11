import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider_pattern/models/category.dart';

List<Category> currentCategoryList;
final categoryRef = FirebaseDatabase.instance.reference().child('categories');

class CategoryProvider with ChangeNotifier {
  // Future<void> getCategories() async {
  //   List<Category> loadCategories = [];
  //   try {
  //     final response = await http
  //         .get(Constants.firebaseUrl + "/categories.json?auth=$authToken");
  //     final extractedCatgories =
  //         json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedCatgories != null) {
  //       extractedCatgories.forEach((categoryId, categoryData) {
  //         loadCategories.add(Category(
  //             id: categoryId,
  //             image: categoryData['image'],
  //             name: categoryData['name'],
  //             addedBy: categoryData['addedBy']));
  //       });
  //     }
  //     _categories = loadCategories.toList();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  List<Category> getCategoryStreamList(DataSnapshot dataSnapshot) {
    List<Category> allCategory = [];
    Map<dynamic, dynamic> dbNotificationLIst = dataSnapshot.value;
    if (dataSnapshot.value != null) {
      dbNotificationLIst.forEach((key, value) {
        final categoryItem = Category(
            id: key,
            name: value['name'],
            image: value['image'],
            addedBy: value['addedBy']);
        allCategory.add(categoryItem);
      });
      currentCategoryList = allCategory;
      return allCategory;
    }
    return List<Category>();
  }
}
