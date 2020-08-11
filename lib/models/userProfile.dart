import 'package:flutter/material.dart';

class UserProfile {
  final String userId;
  final String phoneNumber;
  final String email;
  final String address;
  final String usedCoupons;
  final String firstName;
  final String lastName;
  final double units;
  final String country;
  final String countryCode;
  final String countryAbbv;
  final String password;
  final String referalCode;

  UserProfile(
      {@required this.userId,
      @required this.phoneNumber,
      @required this.email,
      @required this.address,
      @required this.firstName,
      @required this.lastName,
      @required this.country,
      @required this.countryCode,
      @required this.countryAbbv,
      this.usedCoupons,
      this.units,
      this.password,
      this.referalCode});
}
