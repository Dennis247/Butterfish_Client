// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_pattern/helpers/constants.dart';
// import 'package:provider_pattern/providers/events.dart';
// import 'package:provider_pattern/screens/events/edit_events_screen.dart';
// import 'package:provider_pattern/widgets/event_item.dart';

// class UserEvent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var eventData =
//         Provider.of<EventProvider>(context, listen: true).getUserEvents();
//     return Scaffold(
//       body: Container(
//         child: eventData.length > 0
//             ? ListView.builder(
//                 itemCount: eventData.length,
//                 itemBuilder: (context, index) => Column(
//                   children: <Widget>[EventItem(eventData[index]), Divider()],
//                 ),
//               )
//             : Center(
//                 child: Text("There are no available User Events"),
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Constants.primaryColor,
//         onPressed: () {
//           Navigator.of(context).pushNamed(EditEventScreen.routeName);
//         },
//         child: Icon(FontAwesomeIcons.book),
//       ),
//     );
//   }
// }
