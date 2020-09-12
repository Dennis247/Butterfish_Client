import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/orders.dart';
import 'package:provider_pattern/pages/orders/orderPage.dart';
import 'package:provider_pattern/provider/NotificationProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:provider_pattern/provider/orderProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateWay extends StatefulWidget {
  static final routeName = "payment-gateway";
  final String paymentLink;
  final OrderItem orderedItem;

  const PaymentGateWay({Key key, this.paymentLink, this.orderedItem})
      : super(key: key);
  @override
  _PaymentGateWayState createState() => _PaymentGateWayState();
}

class _PaymentGateWayState extends State<PaymentGateWay> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool _isLoading = false;
  void _startLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    super.initState();
    //  _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "payment details",
        ),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Stack(
        children: <Widget>[
          Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: widget.paymentLink,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[].toSet(),
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.contains('successful')) {
                  // payment sucessfull go to orders page
                  //add ordder

                  String body =
                      Constants.adminNotificationTemplate(widget.orderedItem);
                  await Provider.of<OrderProvider>(context, listen: false)
                      .addOrder(orderItem: widget.orderedItem)
                      .whenComplete(() =>
                          Provider.of<CartProvider>(context, listen: false)
                              .clearCart());
                  Provider.of<NotificationProvider>(context, listen: false)
                      .sendOrderNotification(
                          date: DateTime.now(),
                          subject: "Customer Order",
                          body: body);
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                }
                if (request.url.contains('fail')) {
                  // payment sucessfull go to orders page
                  //add ordder
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                _startLoading(true);
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                _startLoading(false);
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            );
          }),
          Center(
            child: _isLoading ? CircularProgressIndicator() : Text(""),
          )
        ],
      ),
      // floatingActionButton: favoriteButton(),
    );
  }
}
