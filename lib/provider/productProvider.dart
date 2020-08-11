import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider_pattern/models/product.dart';

final productRef = FirebaseDatabase.instance.reference().child('products');
List<Product> currentProductList = [];

class ProductProvider with ChangeNotifier {
  int productCount = 0;
  bool showFavouritesOnly = false;

  List<Product> getProductStreaList(DataSnapshot dataSnapshot) {
    List<Product> allProdutcs = [];
    Map<dynamic, dynamic> dbNotificationLIst = dataSnapshot.value;
    if (dataSnapshot.value != null) {
      dbNotificationLIst.forEach((key, value) {
        final prouctItem = Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            categoryId: value['categoryId'],
            isFavourite: false,
            imageUrl: value['imageUrl']);
        allProdutcs.add(prouctItem);
      });
      currentProductList = allProdutcs;
      productCount = currentProductList.length;
      return allProdutcs;
    }
    return List<Product>();
  }

  // Future<void> getProducts() async {
  //   try {
  //     final String url =
  //         Constants.firebaseUrl + '/products.json?auth=$authToken';
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }

  //     final List<Product> loadedProducts = [];
  //     extractedData.forEach((prodId, product) {
  //       loadedProducts.add(Product(
  //           id: prodId,
  //           description: product['description'],
  //           imageUrl: product['imageUrl'],
  //           price: product['price'],
  //           title: product['title'],
  //           categoryId: product['categoryId'],
  //           isFavourite: true
  //           //  isFavourite: product['isFavourite']
  //           ));
  //     });
  //     _items = loadedProducts;
  //     notifyListeners();
  //     //   print(json.decode(response.body));
  //   } catch (error) {
  //     print(error.toString());
  //   }
  // }

  Product getProduct(String id) {
    return currentProductList.firstWhere((prod) => prod.id == id);
  }

  void showFavourites() {
    showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    showFavouritesOnly = false;
    notifyListeners();
  }
}
