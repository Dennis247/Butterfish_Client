import 'package:flutter/material.dart';
import 'package:provider_pattern/models/cartItem.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final String amount;
  final List<CartItem> products;
  final String status;
  final String userId;
  final DateTime dateTime;
  //new added fields
  final String name;
  final String phoneNumber;
  final String email;
  final String referenceNo;
  final String oderNo;
  final String narration;
  final String totalAmount;
  final String paymentMethod;
  final String deliveryAddress;
  // final List<CartItem> cartItems;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.status,
    @required this.userId,
    @required this.dateTime,
    //new added fields
    @required this.name,
    @required this.phoneNumber,
    @required this.email,
    @required this.referenceNo,
    @required this.oderNo,
    @required this.narration,
    @required this.totalAmount,
    @required this.deliveryAddress,
    @required this.paymentMethod,
  });
}
