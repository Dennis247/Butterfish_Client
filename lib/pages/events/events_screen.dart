// import 'package:flutter/material.dart';
// import 'package:provider_pattern/screens/events/available_events.dart';
// import 'package:provider_pattern/screens/events/user_events.dart';
// import 'package:provider_pattern/widgets/app_drawer.dart';

// class EventsScreen extends StatefulWidget {
//   static const routeName = "/events-screen";
//   @override
//   _EventsScreenState createState() => _EventsScreenState();
// }

// class _EventsScreenState extends State<EventsScreen>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;

//   @override
//   void initState() {
//     _tabController = new TabController(length: 2, vsync: this);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: AppDrawer(),
//       appBar: AppBar(
//         title: Text("Events"),
//         bottom: TabBar(
//           tabs: [
//             Tab(
//               text: "Available Events",
//             ),
//             Tab(
//               text: "My Events",
//             ),
//           ],
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           indicatorSize: TabBarIndicatorSize.tab,
//         ),
//         bottomOpacity: 1,
//       ),
//       body: TabBarView(
//         children: [AvailableEvent(), UserEvent()],
//         controller: _tabController,
//       ),
//     );
//   }
// }
