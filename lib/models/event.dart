import 'package:flutter/foundation.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String makeHallAvailable;
  final int noOFPersons;
  final String totalPrice;
  final String phoneNumber;
  final String email;
  final String imageUrl;
  final String eventType;
  final String userId;
  final DateTime bookingDate;

  Event(
      {@required this.id,
      @required this.eventType,
      @required this.title,
      @required this.description,
      @required this.makeHallAvailable,
      @required this.noOFPersons,
      @required this.totalPrice,
      @required this.email,
      @required this.imageUrl,
      @required this.userId,
      @required this.phoneNumber,
      @required this.bookingDate});
}
