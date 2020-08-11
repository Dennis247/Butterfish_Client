import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:share/share.dart';

class ReferalCode extends StatelessWidget {
  static final String routeName = "referal-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Referal Code"),
          centerTitle: true,
          actions: <Widget>[
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("REFERAL CODE"),
              Text(
                "${loggedInUser.referalCode}",
                style: TextStyle(color: Constants.primaryColor, fontSize: 75),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              FlatButton(
                onPressed: () {
                  Share.share(loggedInUser.referalCode);
                },
                child: Text(
                  "SHARE CODE",
                  style: TextStyle(color: Colors.white),
                ),
                color: Constants.primaryColor,
              )
            ],
          ),
        ));
  }
}
