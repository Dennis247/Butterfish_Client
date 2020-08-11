import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/cartItem.dart';
import 'package:provider_pattern/models/coupon.dart';
import 'package:provider_pattern/models/response.dart';
import 'package:provider_pattern/models/userProfile.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/orders/orderPage.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:provider_pattern/provider/couponProvider.dart';
import 'package:provider_pattern/provider/orderProvider.dart';

import 'package:toast/toast.dart';

class CouponPayment extends StatefulWidget {
  final String email;
  final double amount;
  final String description;
  final List<CartItem> cartItems;

  const CouponPayment(
      {Key key, this.email, this.amount, this.description, this.cartItems})
      : super(key: key);
  @override
  _CouponPaymentState createState() => _CouponPaymentState();
}

class _CouponPaymentState extends State<CouponPayment> {
  final _fromKey = GlobalKey<FormState>();
  double _totalAmount = 0;
  String _couponNo;

  bool _isCouponExpired(Coupon coupon) {
    if ((DateTime.now().isAfter(coupon.expiryDate))) return true;
    return false;
  }

  Coupon _getCoupon(CouponProvider couponData, String couponNo) {
    final Coupon coupon = loggedUserCoupons.firstWhere(
        (element) => element.coupon == couponNo,
        orElse: () => null);
    return coupon;
  }

  double _amountToPay(int discount, double amount) {
    if (discount == 100) return 0.0;
    final amountToPay = discount / 100 * amount;
    return amountToPay;
  }

  Future<ResponseModel> _updateUserCoupon(String couponNo) async {
    loggedInUser = new UserProfile(
        userId: loggedInUser.userId,
        phoneNumber: loggedInUser.phoneNumber,
        email: loggedInUser.email,
        address: loggedInUser.address,
        units: loggedInUser.units,
        usedCoupons: loggedInUser.usedCoupons + "|" + couponNo,
        country: loggedInUser.country,
        countryAbbv: loggedInUser.countryAbbv,
        countryCode: loggedInUser.countryCode,
        firstName: loggedInUser.firstName,
        lastName: loggedInUser.lastName);
    final responseMOdel =
        await Provider.of<AuthProvider>(context, listen: false)
            .updateUserProfile(loggedInUser);
    return responseMOdel;
  }

  void _showCouponExpiredDetails(String couponNo) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("EXPIRED COUPON"),
              content:
                  Text("The Coupon No. $couponNo You have entered has expired"),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                )
              ],
            ));
  }

  bool _isCouponUsedByUser(String coupon) {
    if (loggedInUser.usedCoupons.contains(coupon)) return true;
    return false;
  }

  void _showCouponALreadyUsedDialogue(String couponNo) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("USED COUPON"),
              content: Text(
                  "The Coupon No. $couponNo You have entered has already been USED by YOU"),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                )
              ],
            ));
  }

  void _showCouponDoesNotExistDialogue(String couponNo) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("INVALID COUPON"),
              content: Text(
                  "The Coupon No. $couponNo You have entered does not exist"),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                )
              ],
            ));
  }

  void _showCouponDetails(Coupon coupon) async {
    _totalAmount = _amountToPay(coupon.percentageDiscount, widget.amount);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("COUPON DETAILS"),
              content: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      title: Text(
                        "COUPON",
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        coupon.coupon,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      dense: true,
                      title: Text(
                        "Discount",
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        "${coupon.percentageDiscount} %",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      dense: true,
                      title: Text(
                        "Original Amount",
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        widget.amount.toString() + " KSH",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      dense: true,
                      title: Text(
                        "AMOUNT TO PAY",
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        "$_totalAmount" + " KSH",
                        style: TextStyle(fontSize: 14),
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
                    //CHECK IF IT 100% AND PROCES THE ORDER
                    if (coupon.percentageDiscount == 100) {
                      //add ordrt and send message
                      var orderContainer =
                          Provider.of<OrderProvider>(context, listen: false);
                      //makepayment
                      // await orderContainer
                      //     .addOrder(widget.cartItems, widget.amount)
                      //     .whenComplete(() =>
                      //         Provider.of<CartProvider>(context, listen: false)
                      //             .clearCart());

                      ///send mail
                      // Provider.of<AdminNotiication>(context, listen: false)
                      //     .sendOrderNotification(
                      //         date: DateTime.now(),
                      //         subject: "Customer Order",
                      //         body: widget.description +
                      //             "from -- ${widget.email}");
                      Provider.of<CartProvider>(context, listen: false)
                          .clearCart();
                      Toast.show("Order processed Sucessfull", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);

                      _updateUserCoupon(coupon.coupon);

                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    } else {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return FlutterPayment(
                      //     amount: _totalAmount,
                      //     cartItems: widget.cartItems,
                      //     description: widget.description,
                      //     email: widget.email,
                      //     token: widget.token,
                      //   );
                      // }));
                    }
                  },
                  color: Constants.primaryColor,
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final coupnData = Provider.of<CouponProvider>(context, listen: false);
    coupnData.getCoupons();
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
        title: Text("COUPON PAYMENT"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Form(
              key: _fromKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: "",
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: "ENTER COUPON",
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (value) {
                      _couponNo = value;
                    },
                    onSaved: (value) {
                      _couponNo = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'COUPON cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    color: Constants.primaryColor,
                    onPressed: () {
                      bool isValid = _fromKey.currentState.validate();
                      if (!isValid) {
                        return;
                      }
                      _fromKey.currentState.save();
                      //GET COUPON
                      final userCoupon = _getCoupon(coupnData, _couponNo);
                      if (userCoupon == null) {
                        _showCouponDoesNotExistDialogue(_couponNo);
                      } else {
                        if (_isCouponExpired(userCoupon)) {
                          _showCouponExpiredDetails(_couponNo);
                        }
                        if (_isCouponUsedByUser(_couponNo)) {
                          _showCouponALreadyUsedDialogue(_couponNo);
                        } else {
                          _showCouponDetails(userCoupon);
                        }
                      }
                    },
                    child: Text(
                      "VALIDATE COUPON",
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
