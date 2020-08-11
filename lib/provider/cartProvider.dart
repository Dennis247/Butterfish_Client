import 'package:flutter/material.dart';
import 'package:provider_pattern/models/cartItem.dart';
import 'package:provider_pattern/models/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1,
              productId: productId,
              imgUrl: existingCartItem.imgUrl));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              productId: existingCartItem.productId,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imgUrl: existingCartItem.imgUrl,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            productId: product.id,
            title: product.title,
            price: product.price,
            imgUrl: product.imageUrl,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void addDetailCartItem(Product product, int quantity) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              productId: existingCartItem.productId,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: quantity,
              imgUrl: existingCartItem.imgUrl));
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            productId: product.id,
            title: product.title,
            price: product.price,
            quantity: quantity,
            imgUrl: product.imageUrl),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
