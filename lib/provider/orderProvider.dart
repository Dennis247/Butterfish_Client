import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:provider_pattern/models/cartItem.dart';
import 'package:provider_pattern/models/orders.dart';
import 'package:provider_pattern/models/response.dart';
import 'package:provider_pattern/provider/authProvider.dart';

List<OrderItem> orderList;
final orderRef = FirebaseDatabase.instance.reference().child('orders');

class OrderProvider with ChangeNotifier {
  Future<void> fetchOrders() async {
    orderList.clear();
    List<OrderItem> loadedOrders = [];
    try {
      await orderRef.once().then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> extractedOrders = dataSnapshot.value;
        if (extractedOrders != null) {
          extractedOrders.forEach((key, value) {
            extractedOrders.forEach((orderedId, orderData) {
              loadedOrders.add(OrderItem(
                  id: orderedId,
                  amount: orderData['amount'].toString(),
                  userId: loggedInUser.userId,
                  status: orderData['status'],
                  dateTime: DateTime.parse(orderData['dateTime']),
                  products: (orderData['products'] as List<dynamic>)
                      .map((item) => CartItem(
                          id: item['id'],
                          price: double.parse(item['price']),
                          quantity: int.parse(item['quantity']),
                          title: item['title'],
                          imgUrl: item['imgUrl'],
                          productId: item['title']))
                      .toList(),
                  name: loggedInUser.firstName,
                  deliveryAddress: orderData['deliveryAddress'],
                  email: orderData['email'],
                  narration: orderData['narration'],
                  oderNo: orderData['oderNo'],
                  paymentMethod: orderData['paymentMethod'],
                  phoneNumber: orderData['phoneNumber'],
                  referenceNo: orderData['referenceNo'],
                  totalAmount: orderData['totalAmount']));
            });
            loadedOrders = loadedOrders.reversed.toList();
            //  notifyListeners();
          });
        }
      });

    
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel> addOrder({@required OrderItem orderItem}) async {
    orderList = orderList == null ? [] : orderList;
    final timeStamp = DateTime.now();
    try {
      await orderRef.child("${loggedInUser.userId}/${orderItem.id}").set({
        'amount': orderItem.amount,
        'deliveryAddress': orderItem.deliveryAddress,
        'email': orderItem.email,
        'narration': orderItem.narration,
        'phoneNumber': orderItem.phoneNumber,
        'paymentMethod': orderItem.paymentMethod,
        'orderItem': orderItem.oderNo,
        'dateTime': timeStamp.toIso8601String(),
        'status': Constants.pendingStatus,
        'userId': loggedInUser.userId,
        'products': orderItem.products
            .map((ct) => {
                  'id': ct.id,
                  'productId': ct.productId,
                  'title': ct.title,
                  'quantity': ct.quantity.toString(),
                  'price': ct.price.toString()
                })
            .toList()
      });
      orderList.add(orderItem);
      return ResponseModel(true, "Order Created Sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  List<OrderItem> getStreamOrderList(DataSnapshot dataSnapshot) {
    List<OrderItem> allOrderItems = [];
    Map<dynamic, dynamic> extractedOrders = dataSnapshot.value;
    if (dataSnapshot.value != null) {
      extractedOrders.forEach((key, value) {
        extractedOrders.forEach((orderedId, orderData) {
          allOrderItems.add(OrderItem(
              id: orderedId,
              amount: orderData['amount'].toString(),
              userId: loggedInUser.userId,
              status: orderData['status'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                      id: item['id'],
                      price: double.parse(item['price']),
                      quantity: int.parse(item['quantity']),
                      title: item['title'],
                      imgUrl: item['imgUrl'],
                      productId: item['title']))
                  .toList(),
              name: loggedInUser.firstName,
              deliveryAddress: orderData['deliveryAddress'],
              email: orderData['email'],
              narration: orderData['narration'],
              oderNo: orderData['oderNo'],
              paymentMethod: orderData['paymentMethod'],
              phoneNumber: orderData['phoneNumber'],
              referenceNo: orderData['referenceNo'],
              totalAmount: orderData['totalAmount']));
        });
        allOrderItems = allOrderItems.reversed.toList();
      });
      orderList = allOrderItems;
      return allOrderItems;
    }
    return List<OrderItem>();
  }

  Future<ResponseModel> updateOrderStatus(
      String orderId, OrderItem orderItem) async {
    try {
      orderRef.child(orderId).update({
        'status': orderItem.status,
      });
      return ResponseModel(true, "Dispatch Staus Updated Sucessfully");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }


  Future<void> sendOrderNotification() async {
    String username = Constants.notificationMail;
    String password = Constants.notificationMailPassword;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Dennis')
      ..recipients.add('dennisosagiede247@gmail.com')
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('dosamuyimen@gmail.com'))
      ..subject = 'This is a test mail :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> sendPhoneOrderNotification() {}
}
