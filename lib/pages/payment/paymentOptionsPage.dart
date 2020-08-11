import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/cartItem.dart';
import 'package:provider_pattern/models/orders.dart';
import 'package:provider_pattern/models/response.dart';
import 'package:provider_pattern/models/userProfile.dart';
import 'package:provider_pattern/pages/auth/auth_screen.dart';
import 'package:provider_pattern/pages/orders/orderPage.dart';
import 'package:provider_pattern/pages/payment/couponPayment.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:provider_pattern/provider/orderProvider.dart';
import 'package:provider_pattern/provider/paymentProvider.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:toast/toast.dart';
import 'package:provider_pattern/provider/NotificationProvider.dart';
import 'package:uuid/uuid.dart';

class PaymentOptions extends StatefulWidget {
  static final String routeName = "payment-gateway";
  final String email;
  final double amount;
  final String token;
  final String description;
  final List<CartItem> cartItems;
  final String deliveryAddress;

  const PaymentOptions(
      {Key key,
      this.email,
      this.amount,
      this.token,
      this.cartItems,
      this.deliveryAddress,
      this.description})
      : super(key: key);
  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _anonymousFullNmae = TextEditingController();
  final _anonymousPhoneNumber = TextEditingController();
  bool anonymousResult = false;

  Future<void> _showAnonymousDialogue() {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("DELIVERY DETAILS"),
              content: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: <Widget>[
                      _buildInputWidget(
                          textEditingController: _anonymousFullNmae,
                          hintText: "Full Name",
                          errorMessage: "Name cannot be empty",
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInputWidget(
                          textEditingController: _anonymousPhoneNumber,
                          hintText: "Phone number",
                          errorMessage: "Phone Number Cannot be empty",
                          textInputType: TextInputType.number),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                    color: Colors.red,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      anonymousResult = false;
                      Navigator.of(ctx).pop();
                    }),
                MaterialButton(
                    color: Constants.primaryColor,
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        // Invalid!
                        return;
                      }
                      loggedInUser = new UserProfile(
                          userId: loggedInUser.userId,
                          phoneNumber: _anonymousPhoneNumber.text,
                          email: loggedInUser.email,
                          address: loggedInUser.address,
                          firstName: _anonymousFullNmae.text,
                          lastName: loggedInUser.lastName,
                          country: loggedInUser.country,
                          countryCode: loggedInUser.countryCode,
                          countryAbbv: loggedInUser.countryAbbv);
                      Navigator.of(ctx).pop();
                      anonymousResult = true;
                    }),
              ],
            ));
  }

  _buildInputWidget(
      {@required String hintText,
      @required String errorMessage,
      @required TextEditingController textEditingController,
      @required TextInputType textInputType}) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      controller: textEditingController,
      keyboardType: textInputType,
      validator: (value) {
        if (value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: hintText,
          hintStyle: TextStyle(color: Constants.primaryColor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Constants.primaryColor))),
    );
  }

  Future<void> validateUserAuthentication() {
    anonymousResult = true;
    if (loggedInUser.lastName == "") {
      //show pop up asking user to logoin
      anonymousResult = false;
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("YOU MUST BE AUTHNETICATED"),
                content: Container(
                  height: 0,
                ),
                actions: <Widget>[
                  MaterialButton(
                      color: Colors.red,
                      child: Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      }),
                  MaterialButton(
                      color: Constants.primaryColor,
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushNamed(AuthScreen.routeName);
                      })
                ],
              ));
    }
  }

  bool _isUserUnitEnough(double unitToPay) {
    if (loggedInUser.units == null) return false;
    if (loggedInUser.units >= unitToPay) {
      return true;
    }
    return false;
  }

  void _showUnitNotEnoughNotification() async {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("NOT ENOUGH UNIT"),
              content:
                  Text("You do not have enough unit to complete the order"),
              actions: <Widget>[
                MaterialButton(
                    color: Constants.primaryColor,
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
              ],
            ));
  }

  void _showWalletNotification(OrderItem orderedItem) async {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("WALLET PAYMENT"),
              content: Text(
                  "${widget.amount * 0.25} UNIT will be deducted from your wallet"),
              actions: <Widget>[
                MaterialButton(
                    color: Colors.red,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
                MaterialButton(
                    color: Constants.primaryColor,
                    child: Text(
                      "PROCEED",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      //payment sucessfull
                      Navigator.of(context).pop();
                      //cehck if user has enough unit
                      try {
                        if (_isUserUnitEnough(widget.amount * 0.25)) {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .removeUserUnit(widget.amount * 0.25);
                          Toast.show("Order processed Sucessfull", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.CENTER);
                          _processCompletePaymentProcess(orderedItem);
                        } else {
                          //show pop up  unit not
                          _showUnitNotEnoughNotification();
                        }
                      } catch (e) {}
                    }),
              ],
            ));
  }

  Padding _buildPaymentWidget(
      {String title, Color color, Function function, IconData iconData}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: InkWell(
        onTap: function,
        child: Card(
          color: color,
          elevation: 15,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    iconData,
                    color: Colors.black,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _processCompletePaymentProcess(OrderItem orderedItem) async {
    //get email template
    String body = Constants.adminNotificationTemplate(orderedItem);
    await Provider.of<OrderProvider>(context, listen: false)
        .addOrder(orderItem: orderedItem)
        .whenComplete(() =>
            Provider.of<CartProvider>(context, listen: false).clearCart());
    Provider.of<NotificationProvider>(context, listen: false)
        .sendOrderNotification(
            date: DateTime.now(), subject: "Customer Order", body: body);
    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  }

  _porcessOnlinePaymentRespone(
      OrderItem orderedItem, PaymentResponseModel response) async {
    orderedItem = new OrderItem(
        id: Uuid().v4(),
        name: loggedInUser.lastName != ""
            ? loggedInUser.firstName + " " + loggedInUser.lastName
            : loggedInUser.firstName,
        phoneNumber: loggedInUser.phoneNumber,
        email: loggedInUser.email != null ? loggedInUser.email : "",
        referenceNo:
            "Butterfish & Bread-new Order-${DateTime.now().toString()}",
        oderNo: Uuid().v1().substring(0, 5),
        narration: widget.description,
        totalAmount: widget.amount.toString() + " Ksh",
        paymentMethod: "Online",
        amount: widget.amount.toString() + " Ksh",
        dateTime: DateTime.now(),
        deliveryAddress: widget.deliveryAddress,
        products: widget.cartItems,
        status: Constants.pendingStatus,
        userId: loggedInUser.userId);
    response = await Provider.of<PaymentProvider>(context, listen: false)
        .startPayment(
            amount: widget.amount,
            context: context,
            narration: widget.description,
            orderRef: orderedItem.oderNo,
            txRef: orderedItem.referenceNo);
  }

  @override
  Widget build(BuildContext context) {
    //generate order instace here
    PaymentResponseModel response = new PaymentResponseModel(
        responseModel: new ResponseModel(false, "Payment Cancelled"),
        raveStatus: RaveStatus.cancelled);
    return Scaffold(
      appBar: AppBar(
        title: Text("MAKE PAYMENT"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPaymentWidget(
                    title: "ONLINE PAYMENT",
                    color: Colors.orangeAccent,
                    function: () async {
                      OrderItem orderedItem;
                      if (loggedInUser.lastName == "") {
                        await _showAnonymousDialogue();
                        if (anonymousResult) {
                          await _porcessOnlinePaymentRespone(
                              orderedItem, response);
                          if (response.responseModel.isSUcessfull) {
                            Constants.showSuccessDialogue(
                                response.responseModel.responseMessage,
                                context);
                            if (response.raveStatus == RaveStatus.success) {
                              //add item to order list and send mail
                              _processCompletePaymentProcess(orderedItem);
                            }
                          } else {
                            Constants.showErrorDialog(
                                response.responseModel.responseMessage,
                                context);
                          }
                        }
                      } else {
                        orderedItem = new OrderItem(
                            id: Uuid().v4(),
                            name: loggedInUser.lastName != ""
                                ? loggedInUser.firstName +
                                    " " +
                                    loggedInUser.lastName
                                : loggedInUser.firstName,
                            phoneNumber: loggedInUser.phoneNumber,
                            email: loggedInUser.email != null
                                ? loggedInUser.email
                                : "",
                            referenceNo:
                                "Butterfish & Bread-new Order-${DateTime.now().toString()}",
                            oderNo: Uuid().v1().substring(0, 5),
                            narration: widget.description,
                            totalAmount: widget.amount.toString() + " Ksh",
                            paymentMethod: "Online",
                            amount: widget.amount.toString() + " Ksh",
                            dateTime: DateTime.now(),
                            deliveryAddress: widget.deliveryAddress,
                            products: widget.cartItems,
                            status: Constants.pendingStatus,
                            userId: loggedInUser.userId);
                        response = await Provider.of<PaymentProvider>(context,
                                listen: false)
                            .startPayment(
                                amount: widget.amount,
                                context: context,
                                narration: widget.description,
                                orderRef: orderedItem.oderNo,
                                txRef: orderedItem.referenceNo);
                        if (response.responseModel.isSUcessfull) {
                          Constants.showSuccessDialogue(
                              response.responseModel.responseMessage, context);
                          if (response.raveStatus == RaveStatus.success) {
                            //add item to order list and send mail
                            _processCompletePaymentProcess(orderedItem);
                          }
                        } else {
                          Constants.showErrorDialog(
                              response.responseModel.responseMessage, context);
                        }
                      }
                    },
                    iconData: Icons.payment),
                _buildPaymentWidget(
                    title: "PAY WITH COUPON",
                    color: Constants.primaryColor,
                    function: () async {
                      await validateUserAuthentication();
                      if (anonymousResult) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CouponPayment(
                                  amount: widget.amount,
                                  cartItems: widget.cartItems,
                                  description: widget.description,
                                )));
                      }
                    },
                    iconData: Icons.payment),
                _buildPaymentWidget(
                    title: "PAY WITH WALLET",
                    color: Colors.pink,
                    function: () async {
                      await validateUserAuthentication();
                      if (anonymousResult) {
                        OrderItem orderedItem = new OrderItem(
                            id: Uuid().v4(),
                            name:
                                "${loggedInUser.firstName} ${loggedInUser.lastName}",
                            phoneNumber: loggedInUser.phoneNumber,
                            email: loggedInUser.email,
                            referenceNo:
                                "Butterfish & Bread-new Order-${DateTime.now().toString()}",
                            oderNo: Uuid().v1().substring(0, 5),
                            narration: widget.description,
                            totalAmount: widget.amount.toString() + " Ksh",
                            paymentMethod: "Wallet",
                            amount: widget.amount.toString() + "ksh",
                            dateTime: DateTime.now(),
                            deliveryAddress: widget.deliveryAddress,
                            products: widget.cartItems,
                            status: Constants.pendingStatus,
                            userId: loggedInUser.userId);
                        _showWalletNotification(orderedItem);
                      }
                    },
                    iconData: Icons.payment),
                _buildPaymentWidget(
                    title: "PICK UP AT RESTURANT",
                    color: Colors.green,
                    function: () async {
                      if (loggedInUser.lastName == "") {
                        await _showAnonymousDialogue();
                        if (anonymousResult) {
                          OrderItem orderedItem = new OrderItem(
                              id: Uuid().v4(),
                              name: loggedInUser.lastName != ""
                                  ? loggedInUser.firstName +
                                      " " +
                                      loggedInUser.lastName
                                  : loggedInUser.firstName,
                              phoneNumber: loggedInUser.phoneNumber,
                              email: loggedInUser.email != ""
                                  ? loggedInUser.email
                                  : "",
                              referenceNo:
                                  "Butterfish & Bread-new Order-${DateTime.now().toString()}",
                              oderNo: Uuid().v1().substring(0, 5),
                              narration: widget.description,
                              totalAmount: widget.amount.toString() + " Ksh",
                              paymentMethod: "Pick Up & Pay",
                              amount: widget.amount.toString() + "ksh",
                              dateTime: DateTime.now(),
                              deliveryAddress: widget.deliveryAddress,
                              products: widget.cartItems,
                              status: Constants.pendingStatus,
                              userId: loggedInUser.userId);
                          //  _showWalletNotification(orderedItem);
                          _processCompletePaymentProcess(orderedItem);
                        }
                      } else {
                        OrderItem orderedItem = new OrderItem(
                            id: Uuid().v4(),
                            name: loggedInUser.lastName != ""
                                ? loggedInUser.firstName +
                                    " " +
                                    loggedInUser.lastName
                                : loggedInUser.firstName,
                            phoneNumber: loggedInUser.phoneNumber,
                            email: loggedInUser.email != ""
                                ? loggedInUser.email
                                : "",
                            referenceNo:
                                "Butterfish & Bread-new Order-${DateTime.now().toString()}",
                            oderNo: Uuid().v1().substring(0, 5),
                            narration: widget.description,
                            totalAmount: widget.amount.toString() + " Ksh",
                            paymentMethod: "Pick Up & Pay",
                            amount: widget.amount.toString() + "ksh",
                            dateTime: DateTime.now(),
                            deliveryAddress: widget.deliveryAddress,
                            products: widget.cartItems,
                            status: Constants.pendingStatus,
                            userId: loggedInUser.userId);
                        //  _showWalletNotification(orderedItem);
                        _processCompletePaymentProcess(orderedItem);
                      }
                    },
                    iconData: Icons.payment),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
