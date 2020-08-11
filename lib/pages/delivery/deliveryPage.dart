import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/cartItem.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/payment/paymentOptionsPage.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/provider/cartProvider.dart';

class DeliveryScreen extends StatefulWidget {
  final String email;
  final double amount;
  final String description;
  final List<CartItem> cartItems;

  const DeliveryScreen(
      {Key key, this.email, this.amount, this.description, this.cartItems})
      : super(key: key);
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final _fromKey = GlobalKey<FormState>();
  double _totalCost;
  double _deliveryfee;
  bool _isDonholm = false;
  bool _isNairobi = false;
  bool _isOUtSide = false;
  TextEditingController _deliveryAddressCOntroller =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _confirmDeliveryNotification() async {
    if (!_isDonholm && !_isOUtSide && !_isNairobi) {
      Constants.showErrorDialog("You Must Select a Delivery Regions", context);
      return;
    }
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Text(
                        "Delivery Address",
                        style: TextStyle(fontSize: 11),
                      ),
                      subtitle: Text(
                        _deliveryAddressCOntroller.text,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      dense: true,
                      title: Text(
                        "Delivery  Cost",
                        style: TextStyle(fontSize: 11),
                      ),
                      subtitle: Text(
                        _deliveryfee.toString() + "Ksh",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      dense: true,
                      title: Text(
                        "Total  Cost",
                        style: TextStyle(fontSize: 11),
                      ),
                      subtitle: Text(
                        (_deliveryfee + widget.amount).toString() + "Ksh",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    color: Colors.red,
                    child: Text(
                      "CANCEL",
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
                FlatButton(
                  child: Text("PAY"),
                  onPressed: () async {
                    _totalCost = _deliveryfee + widget.amount;
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PaymentOptions(
                        amount: _totalCost,
                        cartItems: widget.cartItems,
                        description: widget.description,
                        email: widget.email,
                      );
                    }));
                  },
                  color: Constants.primaryColor,
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
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
        title: Text("DELIVERY LOCATION"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _fromKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 3,
                    controller: _deliveryAddressCOntroller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: "Enter Delivery Address",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Delivery Address Cannot be Empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: appSize.height * 0.05,
                  ),
                  Text("Select Delivery Region"),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "donholm (cost 100Ksh) ",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Switch(
                          activeColor: Constants.primaryColor,
                          value: _isDonholm,
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                _isDonholm = value;
                                _deliveryfee = 100.00;
                              }
                              _isNairobi = false;
                              _isOUtSide = false;
                            });
                          })
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Nairobi (cost 300Ksh) ",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Switch(
                          activeColor: Constants.primaryColor,
                          value: _isNairobi,
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                _isNairobi = value;
                                _deliveryfee = 300.00;
                              }
                              _isDonholm = false;
                              _isOUtSide = false;
                            });
                          })
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "10 Km Outside  (cost 400Ksh) ",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Switch(
                          activeColor: Constants.primaryColor,
                          value: _isOUtSide,
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                _isOUtSide = value;
                                _deliveryfee = 400.00;
                              }
                              _isDonholm = false;
                              _isNairobi = false;
                            });
                          })
                    ],
                  ),
                  Divider(),
                  MaterialButton(
                    color: Constants.primaryColor,
                    onPressed: () {
                      bool isValid = _fromKey.currentState.validate();
                      if (!isValid) {
                        return;
                      }
                      _fromKey.currentState.save();
                      _confirmDeliveryNotification();
                      //GET COUPON
                    },
                    child: Text(
                      "PROCEED",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
