// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AvailableEvent extends StatelessWidget {
//   @override
//   @override
//   Widget build(BuildContext context) {
//     var eventData =
//         Provider.of<EventProvider>(context, listen: false).getAdminEvents();
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
//                 child: Text("There are no available Events"),
//               ),
//       ),
//     );
//   }
// }
