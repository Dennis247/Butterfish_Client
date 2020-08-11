import 'package:flutter/material.dart';

class Coupon {
  final String id;
  final DateTime dateGenerated;
  final DateTime expiryDate;
  final String coupon;
  final int percentageDiscount;
  final int durationDays;
  final int noOfTimesUsed;
  final String description;

  Coupon({
    @required this.dateGenerated,
    @required this.expiryDate,
    @required this.coupon,
    @required this.percentageDiscount,
    @required this.id,
    @required this.durationDays,
    @required this.description,
    @required this.noOfTimesUsed,
  });
}
