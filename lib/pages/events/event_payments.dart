// import 'package:flutter/material.dart';
// import 'package:flutter_rave/flutter_rave.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_pattern/providers/events.dart';
// import 'package:provider_pattern/screens/events/events_screen.dart';
// import 'package:toast/toast.dart';

// class EventPayment extends StatefulWidget {
//   static final String routeName = "event-payment-gateway";
//   final String email;
//   final String token;
//   final Event event;

//   const EventPayment({
//     Key key,
//     this.email,
//     this.token,
//     this.event,
//   }) : super(key: key);
//   @override
//   _EventPaymentState createState() => _EventPaymentState();
// }

// class _EventPaymentState extends State<EventPayment> {
//   @override
//   Widget build(BuildContext context) {
//     var eventData = Provider.of<EventProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("EVENT PAYMENT"),
//       ),
//       body: Container(
//         child: Center(
//           child: Builder(
//             builder: (context) => Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0, right: 10),
//                   child: InkWell(
//                     onTap: () => _pay(context, eventData),
//                     child: Card(
//                       color: Colors.orangeAccent,
//                       elevation: 15,
//                       child: Container(
//                         height: 100,
//                         width: MediaQuery.of(context).size.width,
//                         child: Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "CARD PAYMENT",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 Icons.payment,
//                                 color: Colors.black,
//                                 size: 30,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0, right: 10),
//                   child: InkWell(
//                     onTap: () => _showMpasaNotification(eventData),
//                     child: Card(
//                       color: Colors.green,
//                       elevation: 15,
//                       child: Container(
//                         height: 100,
//                         width: MediaQuery.of(context).size.width,
//                         child: Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 "PAY WITH M-PESA",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 Icons.payment,
//                                 color: Colors.black,
//                                 size: 30,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _pay(BuildContext context, EventProvider eventProvider) {
//     final snackBar_onFailure = SnackBar(content: Text('Transaction failed'));
//     final snackBar_onClosed = SnackBar(content: Text('Transaction closed'));
//     final _rave = RaveCardPayment(
//       isDemo: false,
//       encKey: "36a47583762c7e7156f37e81",
//       publicKey: "FLWPUBK-2c812e3e3e969401ee697274882d176c-X",
//       transactionRef: "SCH${DateTime.now()}---${widget.event.title}",
//       amount: double.parse(widget.event.totalPrice + ".00"),
//       email: widget.email,
//       onSuccess: (response) async {
//         print("$response");

//         if (mounted) {
//           Scaffold.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Event Booked Sucessful!"),
//               backgroundColor: Colors.green,
//               duration: Duration(
//                 seconds: 5,
//               ),
//             ),
//           );
//         }
//         // var orderContainer = Provider.of<Orders>(context, listen: false);
//         // //makepayment
//         // await orderContainer.addOrder(
//         //     widget.cartItems, widget.amount, widget.token);

//         //   widget.cartContainer.clearCart();

//         eventProvider.addEvents(widget.event);
//         Toast.show("Event Booked Sucessfully", context,
//             duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//         Navigator.of(context).pushReplacementNamed(EventsScreen.routeName);
//       },
//       onFailure: (err) {
//         print("$err");
//         print("Transaction failed, try again");
//         Scaffold.of(context).showSnackBar(snackBar_onFailure);
//         Navigator.of(context).pop();
//       },
//       onClosed: () {
//         print("Transaction closed");
//         Scaffold.of(context).showSnackBar(snackBar_onClosed);
//       },
//       context: context,
//     );
//     _rave.process();
//   }

//   void _showMpasaNotification(EventProvider eventProvider) {
//     showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//               title: Text("M-PESA-PAYMENT"),
//               content: Text(
//                   "SEND Ksh ${widget.event.totalPrice} PAYMENT TO +254757461411"),
//               actions: <Widget>[
//                 FlatButton(
//                     child: Text(
//                       "CANCEL",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     onPressed: () {
//                       Navigator.of(ctx).pop();
//                     }),
//                 FlatButton(
//                     child: Text("MAKE PAYMENT"),
//                     onPressed: () {
//                       //payment sucessfull

//                       eventProvider.addEvents(
//                         widget.event,
//                       );
//                       Toast.show("Event Booked Sucessfully", context,
//                           duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//                       Navigator.of(context)
//                           .pushReplacementNamed(EventsScreen.routeName);
//                     }),
//               ],
//             ));
//   }
// }
