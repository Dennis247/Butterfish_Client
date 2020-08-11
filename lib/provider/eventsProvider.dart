// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider_pattern/helpers/constants.dart';

// final productRef = FirebaseDatabase.instance.reference().child('products');

// class EventProvider with ChangeNotifier {
//   List<Event> _events = [];

//   List<Event> get events {
//     return [..._events];
//   }

//   List<Event> _adminEvents = [];
//   List<Event> get adminEvents {
//     return [..._adminEvents];
//   }

//   List<Event> _userEvents = [];
//   List<Event> get userEvents {
//     return [..._userEvents];
//   }

//   final String authToken;
//   final String userId;

//   EventProvider(this._events, {this.authToken, this.userId});

//   Future<void> getEvents() async {
//     List<Event> loadedEvents = [];

//     try {
//       final response = await http
//           .get(Constants.firebaseUrl + "/events.json?auth=$authToken");
//       final extractedEvents =
//           json.decode(response.body) as Map<String, dynamic>;
//       if (extractedEvents != null) {
//         extractedEvents.forEach((eventId, eventData) {
//           loadedEvents.add(Event(
//               id: eventId,
//               description: eventData['description'],
//               title: eventData['title'],
//               makeHallAvailable: eventData['makeHallAvailable'],
//               noOFPersons: eventData['noOFPersons'],
//               totalPrice: eventData['totalPrice'],
//               email: eventData['email'],
//               phoneNumber: eventData['phoneNumber'],
//               imageUrl: eventData['imageUrl'],
//               eventType: eventData['eventType'],
//               userId: userId,
//               bookingDate: eventData['bookingDate'] != null
//                   ? DateTime.parse(eventData['bookingDate'])
//                   : DateTime.now()));
//         });
//       }
//       _events = loadedEvents.toList();
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   List<Event> getAdminEvents() {
//     var eventx = _events.where((x) => x.eventType == "ADMIN").toList();
//     return eventx;
//   }

//   List<Event> getUserEvents() {
//     var eventx = _events
//         .where((x) => x.eventType == "USER" && x.userId == userId)
//         .toList();
//     return eventx;
//   }

//   Future<void> addEvents(Event event) async {
//     try {
//       final response = await http.post(
//           Constants.firebaseUrl + "/events.json?auth=$authToken",
//           body: json.encode({
//             'id': event.id,
//             'title': event.title,
//             'makeHallAvailable': event.makeHallAvailable,
//             'description': event.description,
//             'totalPrice': event.totalPrice,
//             'noOFPersons': event.noOFPersons,
//             'imageUrl': event.imageUrl,
//             'email': event.email,
//             'phoneNumber': event.phoneNumber,
//             'userId': userId,
//             'bookingDate': DateTime.now().toIso8601String(),
//             'eventType': "USER",
//           }));

//       final newEvent = Event(
//         id: json.decode(response.body)['name'],
//         description: event.description,
//         makeHallAvailable: event.makeHallAvailable,
//         noOFPersons: event.noOFPersons,
//         title: event.title,
//         totalPrice: event.totalPrice,
//         email: event.email,
//         phoneNumber: event.phoneNumber,
//         imageUrl: event.imageUrl,
//         eventType: "USER",
//         userId: userId,
//         bookingDate: event.bookingDate,
//       );

//       _events.add(newEvent);
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   }

//   Future<void> updateEvent(String eventsId, Event newEvent) async {
//     final _updatebaseUrl =
//         Constants.firebaseUrl + "/events/$eventsId.json?auth=$authToken";

//     final int eventIndex = _events.indexWhere((off) => off.id == eventsId);
//     if (eventIndex >= 0) {
//       try {
//         await http.patch(_updatebaseUrl,
//             body: json.encode({
//               'title': newEvent.title,
//               'description': newEvent.description,
//               'makeHallAvailable': newEvent.makeHallAvailable,
//               'totalPrice': newEvent.totalPrice,
//               'noOFPersons': newEvent.noOFPersons,
//               'totalPrice': newEvent.totalPrice,
//               'imageUrl': newEvent.imageUrl,
//               'eventType': newEvent.eventType,
//             }));
//       } catch (error) {
//         print(error);
//       }
//       _events[eventIndex] = newEvent;
//       notifyListeners();
//     } else {
//       print('newEvent update for $eventsId failed');
//     }
//   }

//   Future<void> deleteEvents(String eventId) async {
//     final url = Constants.firebaseUrl + "/events/$eventId.json?auth=$authToken";

//     Event existingEvent;
//     int existingEventIndex = _events.indexWhere((cat) => cat.id == eventId);
//     if (existingEventIndex >= 0) {
//       existingEvent = _events[existingEventIndex];
//       _events.removeAt(existingEventIndex);
//       notifyListeners();

//       final response = await http.delete(url);
//       if (response.statusCode >= 400) {
//         _events.insert(existingEventIndex, existingEvent);
//         notifyListeners();
//         throw HttpException('event could not be deleted');
//       } else {
//         existingEvent = null;
//       }
//     }
//   }
// }

// class Event {
//   final String id;
//   final String title;
//   final String description;
//   final String makeHallAvailable;
//   final int noOFPersons;
//   final String totalPrice;
//   final String phoneNumber;
//   final String email;
//   final String imageUrl;
//   final String eventType;
//   final String userId;
//   final DateTime bookingDate;

//   Event(
//       {@required this.id,
//       @required this.eventType,
//       @required this.title,
//       @required this.description,
//       @required this.makeHallAvailable,
//       @required this.noOFPersons,
//       @required this.totalPrice,
//       @required this.email,
//       @required this.imageUrl,
//       @required this.userId,
//       @required this.phoneNumber,
//       @required this.bookingDate});
// }
