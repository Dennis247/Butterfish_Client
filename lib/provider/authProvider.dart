import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider_pattern/models/map.dart';
import 'package:provider_pattern/models/response.dart';

import 'package:provider_pattern/models/userProfile.dart';
import 'package:provider_pattern/provider/google_map_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

UserProfile loggedInUser;
PlaceDetail userPlaceDetail;
String authToken;
final userRef = FirebaseDatabase.instance.reference().child('userprofiles');

class AuthProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _apiKey = "AIzaSyBaSy0NPJ63AzVrji8aIqYx0Ilwm1acUZw";
  bool isLoggedIn = false;
  static const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

  Future<ResponseModel> authenticateUser(
      UserProfile userProfile, String urlSegment,
      {String referalCode}) async {
    try {
      //update refred user referal COde by adding 10 more unit
      if (referalCode != null) {
        updateReferedUserUnit(referalCode);
      }

      if (urlSegment == Constants.signInWithPassword) {
        final authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: userProfile.email, password: userProfile.password);
        authResult.user.getIdToken().then((value) {
          authToken = value.token;
        });
        final dataSnapShot = await userRef.child(authResult.user.uid).once();
        loggedInUser = UserProfile(
            userId: dataSnapShot.value['userId'],
            phoneNumber: dataSnapShot.value['phoneNumber'],
            email: dataSnapShot.value['email'],
            address: dataSnapShot.value['address'],
            firstName: dataSnapShot.value['firstName'],
            lastName: dataSnapShot.value['lastName'],
            country: dataSnapShot.value['country'],
            countryAbbv: dataSnapShot.value['countryAbbv'],
            countryCode: dataSnapShot.value['countryCode'],
            units: double.parse(dataSnapShot.value['units'].toString()),
            usedCoupons: dataSnapShot.value['usedCoupons'],
            referalCode: dataSnapShot.value['referalCode']);
      } else {
        final authResult = await firebaseAuth.createUserWithEmailAndPassword(
            email: userProfile.email, password: userProfile.password);
        authResult.user.getIdToken().then((value) {
          authToken = value.token;
        });
        //generate user referal code
        String referalCode = await generataeAssignRefrealCode();
        await userRef.child(authResult.user.uid).set({
          "userId": authResult.user.uid,
          "phoneNumber": userProfile.phoneNumber,
          "email": userProfile.email,
          "address": userProfile.address,
          "country": userProfile.country,
          "countryAbbv": userProfile.countryAbbv,
          "countryCode": userProfile.countryCode,
          "lastName": userProfile.lastName,
          "firstName": userProfile.firstName,
          "units": userProfile.units,
          "usedCoupons": userProfile.usedCoupons,
          "referalCode": referalCode
        });
        loggedInUser = UserProfile(
            userId: authResult.user.uid,
            phoneNumber: userProfile.phoneNumber,
            email: userProfile.email,
            address: userProfile.address,
            country: userProfile.country,
            countryAbbv: userProfile.countryAbbv,
            countryCode: userProfile.countryCode,
            lastName: userProfile.lastName,
            firstName: userProfile.firstName,
            units: userProfile.units,
            usedCoupons: userProfile.usedCoupons,
            referalCode: referalCode);
      }
      storeAutoData(loggedInUser);
      userPlaceDetail =
          GoogleMapServices.getuserReturantDetaila(loggedInUser.countryCode);
      return ResponseModel(true, "User SignIn Sucessfull");
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

  void getAnonymousUserProfile() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey('userData')) {
      //create profile if it does not exist
      final userId = Uuid().v4();
      final String countryAbbv = "ke";
      final String countryCode = "+254";
      final String country = "kenya";

      final sharedPrefs = await SharedPreferences.getInstance();
      final logOnData = json.encode({
        "userId": userId,
        "phoneNumber": "",
        "email": "",
        "address": "",
        "country": country,
        "countryAbbv": countryAbbv,
        "countryCode": countryCode,
        "lastName": "",
        "firstName": "",
        "usedCoupons": "",
        "units": "0",
        "referalCode": "",
        "authToken": ""
      });
      sharedPrefs.setString('userData', logOnData);
      loggedInUser = new UserProfile(
          userId: userId,
          phoneNumber: "",
          email: "",
          address: "",
          firstName: "",
          lastName: "",
          country: country,
          countryCode: countryCode,
          countryAbbv: countryAbbv,
          password: "",
          referalCode: "",
          units: 0.0,
          usedCoupons: "");
    } else {
      final sharedData = sharedPref.getString('userData');
      final extractedUserData = json.decode(sharedData) as Map<String, Object>;
      authToken = extractedUserData['authToken'];
      loggedInUser = new UserProfile(
        userId: extractedUserData['userId'],
        phoneNumber: extractedUserData['phoneNumber'],
        email: extractedUserData['email'],
        address: extractedUserData['address'],
        country: extractedUserData['address'],
        countryAbbv: extractedUserData['countryAbbv'],
        firstName: extractedUserData['firstName'],
        countryCode: extractedUserData['countryCode'],
        lastName: extractedUserData['lastName'],
        units: double.parse(extractedUserData['units'].toString()),
        usedCoupons: extractedUserData['usedCoupons'],
        referalCode: extractedUserData['referalCode'],
      );
    }

    //get user placeDetail
    userPlaceDetail = GoogleMapServices.getuserReturantDetaila("+254");
  }

  void storeAutoData(UserProfile userProfile) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final logOnData = json.encode({
      "userId": userProfile.userId,
      "phoneNumber": userProfile.phoneNumber,
      "email": userProfile.email,
      "address": userProfile.address,
      "country": userProfile.country,
      "countryAbbv": userProfile.countryAbbv,
      "countryCode": userProfile.countryCode,
      "lastName": userProfile.lastName,
      "firstName": userProfile.firstName,
      "usedCoupons": userProfile.usedCoupons,
      "units": userProfile.units,
      "referalCode": userProfile.referalCode,
      "authToken": authToken
    });
    sharedPrefs.setString('userData', logOnData);
    userPlaceDetail =
        GoogleMapServices.getuserReturantDetaila(loggedInUser.countryCode);
  }

  Future<bool> tryAutoLogin() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey('userData')) {
      return false;
    }
    final sharedData = sharedPref.getString('userData');
    final extractedUserData = json.decode(sharedData) as Map<String, Object>;
    authToken = extractedUserData['authToken'];
    loggedInUser = new UserProfile(
      userId: extractedUserData['userId'],
      phoneNumber: extractedUserData['phoneNumber'],
      email: extractedUserData['email'],
      address: extractedUserData['address'],
      country: extractedUserData['address'],
      countryAbbv: extractedUserData['countryAbbv'],
      firstName: extractedUserData['firstName'],
      countryCode: extractedUserData['countryCode'],
      lastName: extractedUserData['lastName'],
      units: extractedUserData['units'],
      usedCoupons: extractedUserData['usedCoupons'],
      referalCode: extractedUserData['referalCode'],
    );

    //get user placeDetail
    userPlaceDetail =
        GoogleMapServices.getuserReturantDetaila(loggedInUser.countryCode);
    isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_apiKey",
          body: json.encode({'requestType': 'PASSWORD_RESET', 'email': email}));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        // throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<ResponseModel> updateUserProfile(UserProfile userProfile) async {
    try {
      userRef.child(userProfile.userId).update({
        'phoneNumber': userProfile.phoneNumber,
        'email': userProfile.email,
        'address': userProfile.address,
        'userId': userProfile.userId,
        'units': userProfile.units,
        'usedCoupons': userProfile.usedCoupons,
        'firstName': userProfile.firstName,
        "lastName": userProfile.lastName
      });

      loggedInUser = new UserProfile(
          userId: userProfile.userId,
          phoneNumber: userProfile.phoneNumber,
          email: userProfile.email,
          address: userProfile.address,
          units: userProfile.units,
          usedCoupons: userProfile.usedCoupons,
          country: userProfile.country,
          countryAbbv: userProfile.countryAbbv,
          countryCode: userProfile.countryCode,
          firstName: userProfile.firstName,
          lastName: userProfile.lastName,
          referalCode: userProfile.referalCode);
      return ResponseModel(true, "user profile updated sucessfully");
    } catch (error) {
      return ResponseModel(false, "user profile updated failed");
    }
  }

  Future<void> logout() async {
    loggedInUser = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  getUserUnitConversion(double unit) {
    //10 unit is equal to 0.25 shillings
    final double userValue = unit * 0.25;
    return userValue;
  }

  Future<ResponseModel> addUserUnit(int userMealCount) async {
    try {
      final addedUnit = userMealCount * 10;
      final totalUnit = addedUnit + loggedInUser.units;
      userRef.child(loggedInUser.userId).update({
        'units': totalUnit,
      });
      loggedInUser = new UserProfile(
          userId: loggedInUser.userId,
          phoneNumber: loggedInUser.phoneNumber,
          email: loggedInUser.email,
          address: loggedInUser.address,
          units: totalUnit,
          usedCoupons: loggedInUser.usedCoupons,
          country: loggedInUser.country,
          countryAbbv: loggedInUser.countryAbbv,
          countryCode: loggedInUser.countryCode,
          firstName: loggedInUser.firstName,
          referalCode: loggedInUser.referalCode,
          lastName: loggedInUser.lastName);
      return ResponseModel(true, "user profile updated sucessfully");
    } catch (e) {
      return ResponseModel(false, "user profile updated failed");
    }
  }

  Future<void> addReferalUnit({String userId, double newUnit}) async {
    try {
      userRef.child(userId).update({
        'units': newUnit,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ResponseModel> removeUserUnit(double unitCount) async {
    try {
      final deductedUnit = loggedInUser.units - unitCount;
      userRef.child(loggedInUser.userId).update({
        'units': deductedUnit,
      });
      loggedInUser = new UserProfile(
          userId: loggedInUser.userId,
          phoneNumber: loggedInUser.phoneNumber,
          email: loggedInUser.email,
          address: loggedInUser.address,
          units: deductedUnit,
          usedCoupons: loggedInUser.usedCoupons,
          country: loggedInUser.country,
          countryAbbv: loggedInUser.countryAbbv,
          countryCode: loggedInUser.countryCode,
          firstName: loggedInUser.firstName,
          lastName: loggedInUser.lastName);
      return ResponseModel(true, "user profile updated sucessfully");
    } catch (e) {
      return ResponseModel(false, "user profile updated failed");
    }
  }

  Future<String> generataeAssignRefrealCode() async {
    try {
      String getCode = randomCode(4);
      await userRef
          .orderByChild("userId")
          .equalTo(getCode)
          .once()
          .then((dataSnapshot) {
        Map<dynamic, dynamic> codeValues = dataSnapshot.value;
        while (codeValues != null) {
          generataeAssignRefrealCode();
        }
      });
      return getCode;
    } catch (e) {
      print(e.toString());
      return "";
    }

    //check if code exist in db before returning it
  }

  updateReferedUserUnit(String code) {
    try {
      userRef
          .orderByChild("referalCode")
          .equalTo(code)
          .once()
          .then((dataSnapshot) {
        Map<dynamic, dynamic> codeValues = dataSnapshot.value;
        if (codeValues != null) {
          Map<dynamic, dynamic> userList = dataSnapshot.value;
          userList.forEach((key, value) {
            String userId = value['userId'];
            double updatedUnit = double.parse(value['units'].toString()) + 10.0;
            addReferalUnit(newUnit: updatedUnit, userId: userId);
          });
        }
      });
    } catch (e) {}
  }

  String randomCode(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result.toUpperCase();
  }
}
