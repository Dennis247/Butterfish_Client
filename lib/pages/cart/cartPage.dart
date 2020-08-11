import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/cartItem.dart';
import 'package:provider_pattern/pages/delivery/deliveryPage.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/pages/widgets/cart_item.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "MY CART",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      //  drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      'Ksh${cartContainer.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OrderButton(cartContainer: cartContainer)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: cartContainer.items.values.toList().length > 0
                ? ListView.builder(
                    itemCount: cartContainer.items.length,
                    itemBuilder: (ctx, i) => CartItemWIdget(
                        cartContainer.items.values.toList()[i].id,
                        cartContainer.items.values.toList()[i].productId,
                        cartContainer.items.values.toList()[i].price,
                        cartContainer.items.values.toList()[i].quantity,
                        cartContainer.items.values.toList()[i].title,
                        cartContainer.items.values.toList()[i].imgUrl),
                  )
                : Center(
                    child: Text("No Items in Your Cart !"),
                  ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 45,
          child: Center(
            child: Text(
              "<< SWIPE LEFT TO REMOVE ITEM",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartContainer,
  }) : super(key: key);

  final CartProvider cartContainer;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green)),
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cartContainer.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              //  var orderContainer = Provider.of<Orders>(context, listen: false);
              //makepayment
              // await orderContainer.addOrder(
              //     widget.cartContainer.items.values.toList(),
              //     widget.cartContainer.totalAmount,
              //     authData.token);
              var allItems = widget.cartContainer.items.values.toList();
              var totalAmounts = widget.cartContainer.totalAmount;
              //  widget.cartContainer.clearCart();
              setState(() {
                _isLoading = false;
              });
              //sucessfull
              String description = getDescription(allItems);

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DeliveryScreen(
                  email: loggedInUser.email,
                  amount: totalAmounts,
                  description: description,
                  cartItems: allItems,
                );
              }));
            },
      textColor: Colors.green,
    );
  }

  String getDescription(List<CartItem> cartItems) {
    String description = "";
    cartItems.forEach((element) {
      description = description + " |" + element.title;
    });
    return description;
  }
}
