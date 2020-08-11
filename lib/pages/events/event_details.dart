// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_pattern/helpers/constants.dart';
// import 'package:provider_pattern/providers/auth.dart';
// import 'package:provider_pattern/providers/events.dart';
// import 'package:provider_pattern/screens/events/event_payments.dart';
// import 'package:toast/toast.dart';

// class EventDetails extends StatelessWidget {
//   final Event event;

//   const EventDetails({Key key, this.event}) : super(key: key);

//   Widget buildEventItem(Event event, context) {
//     return Container(
//       child: Card(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//         elevation: 3.0,
//         child: Column(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                   height: MediaQuery.of(context).size.height / 3.0,
//                   width: MediaQuery.of(context).size.width,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight: Radius.circular(5),
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5),
//                     ),
//                     child: CachedNetworkImage(
//                       imageUrl: "${event.imageUrl}",
//                       placeholder: (context, url) =>
//                           Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                     bottom: 6.0,
//                     left: 6.0,
//                     child: Card(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(3.0)),
//                         child: Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: Text(
//                               "Ksh ${event.totalPrice}",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )))),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildDescription(Event event, Auth authuser) {
//     // return ListTile(
//     //     title: Text(
//     //       "${event.title}",
//     //       style: TextStyle(
//     //         fontSize: 18,
//     //         fontWeight: FontWeight.w800,
//     //       ),
//     //       textAlign: TextAlign.center,
//     //     ),
//     //     subtitle: Text(
//     //       event.description,
//     //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//     //       textAlign: TextAlign.center,
//     //     ));

//     return Column(
//       children: <Widget>[
//         ListTile(
//           leading: Icon(
//             FontAwesomeIcons.lightbulb,
//             color: Colors.purple,
//           ),
//           title: Text(event.title),
//           subtitle: Text(
//             "event type",
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(
//             FontAwesomeIcons.running,
//             color: Colors.blue,
//           ),
//           title: Text(
//             event.description,
//           ),
//           subtitle: Text(
//             "event description",
//             maxLines: 5,
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(
//             FontAwesomeIcons.smile,
//             color: Colors.orange,
//           ),
//           title: Text(
//             event.noOFPersons.toString(),
//           ),
//           subtitle: Text(
//             "No of Persons",
//             maxLines: 5,
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(
//             FontAwesomeIcons.houseDamage,
//             color: Colors.pink,
//           ),
//           title: Text(
//             event.makeHallAvailable,
//           ),
//           subtitle: Text(
//             "Hall Available",
//             maxLines: 5,
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(
//             FontAwesomeIcons.moneyBill,
//             color: Colors.green,
//           ),
//           title: Text(
//             "Ksh " + event.totalPrice,
//           ),
//           subtitle: Text(
//             event.eventType == "ADMIN" ? "Total Cost" : "Estimated Cost",
//             maxLines: 5,
//             style: TextStyle(fontSize: 12),
//           ),
//         )
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var authUser = Provider.of<Auth>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(event.title),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: <Widget>[
//             Container(
//               child: buildEventItem(event, context),
//             ),
//             Container(child: buildDescription(event, authUser)),
//           ],
//         ),
//       ),
//       bottomNavigationBar: event.eventType == "ADMIN"
//           ? Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: MaterialButton(
//                 height: 45,
//                 color: Constants.primaryColor,
//                 onPressed: () {
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(builder: (context) {
//                     return EventPayment(event: event, token: authUser.token);
//                   }));
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "BOOK EVENT",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Icon(
//                       FontAwesomeIcons.book,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : Container(
//               height: 5,
//             ),
//     );
//   }
// }
