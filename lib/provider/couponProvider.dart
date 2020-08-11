import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/coupon.dart';
import 'authProvider.dart';

List<Coupon> loggedUserCoupons;

class CouponProvider with ChangeNotifier {
  Future<void> getCoupons() async {
    List<Coupon> loadedCoupons = [];

    try {
      final response = await http
          .get(Constants.firebaseUrl + "/coupons.json?auth=$authToken");
      final extractedCoupons =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedCoupons != null) {
        extractedCoupons.forEach((couponId, couponData) {
          loadedCoupons.add(Coupon(
            id: couponId,
            coupon: couponData['coupon'],
            dateGenerated: DateTime.parse(couponData['dateGenerated']),
            expiryDate: DateTime.parse(couponData['expiryDate']),
            percentageDiscount: couponData['percentageDiscount'],
            durationDays: couponData['durationDays'],
            description: couponData['description'],
            noOfTimesUsed: couponData['noOfTimesUsed'],
          ));
        });
      }
      loggedUserCoupons = loadedCoupons.toList();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addCoupons(Coupon coupon) async {
    try {
      final response = await http.post(
          Constants.firebaseUrl + "/coupons.json?auth=$authToken",
          body: json.encode({
            'id': coupon.id,
            'coupon': coupon.coupon,
            'dateGenerated': DateTime.now().toIso8601String(),
            'percentageDiscount': coupon.percentageDiscount,
            'expiryDate': DateTime.now()
                .add(Duration(days: coupon.durationDays))
                .toIso8601String(),
            'durationDays': coupon.durationDays,
            'description': coupon.description,
            'noOfTimesUsed': 0,
          }));

      final newCoupon = Coupon(
          id: json.decode(response.body)['name'],
          coupon: coupon.coupon,
          dateGenerated: DateTime.now(),
          expiryDate: DateTime.now().add(Duration(days: coupon.durationDays)),
          percentageDiscount: coupon.percentageDiscount,
          durationDays: coupon.durationDays,
          description: coupon.description,
          noOfTimesUsed: 0);
      loggedUserCoupons.add(newCoupon);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCoupon(String couponsId, Coupon newCoupon) async {
    final _updatebaseUrl =
        Constants.firebaseUrl + "/coupons/$couponsId.json?auth=$authToken";

    final int couponIndex =
        loggedUserCoupons.indexWhere((off) => off.id == couponsId);
    if (couponIndex >= 0) {
      try {
        await http.patch(_updatebaseUrl,
            body: json.encode({
              'coupon': newCoupon.coupon,
              'expiryDate': DateTime.now()
                  .add(Duration(days: newCoupon.durationDays))
                  .toIso8601String(),
              'percentageDiscount': newCoupon.percentageDiscount,
              'durationDays': newCoupon.durationDays,
              'description': newCoupon.description,
            }));
      } catch (error) {
        print(error);
      }
      loggedUserCoupons[couponIndex] = newCoupon;
      notifyListeners();
    } else {
      print('newCoupon update for $couponsId failed');
    }
  }

  Future<void> deleteCoupons(String couponId) async {
    final url =
        Constants.firebaseUrl + "/coupons/$couponId.json?auth=$authToken";
    Coupon existingCoupon;
    int existingCouponIndex =
        loggedUserCoupons.indexWhere((cat) => cat.id == couponId);
    if (existingCouponIndex >= 0) {
      existingCoupon = loggedUserCoupons[existingCouponIndex];
      loggedUserCoupons.removeAt(existingCouponIndex);
      notifyListeners();

      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        loggedUserCoupons.insert(existingCouponIndex, existingCoupon);
        notifyListeners();
        throw HttpException('coupon could not be deleted');
      } else {
        existingCoupon = null;
      }
    }
  }
}
