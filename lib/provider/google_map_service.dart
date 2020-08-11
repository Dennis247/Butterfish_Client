import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/map.dart';
import 'package:provider_pattern/provider/authProvider.dart';

class GoogleMapServices {
  final String sessionToken;

  GoogleMapServices({this.sessionToken});

  Future<List> getSuggestions(String query) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=${Constants.apiKey}&type=$type&language=en&components=country:${loggedInUser.countryAbbv}&sessiontoken=$sessionToken';

    print('Autocomplete(sessionToken): $sessionToken');

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=${Constants.apiKey}&place_id=$placeId&language=en&sessiontoken=$token';

    print('Place Detail(sessionToken): $sessionToken');
    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    print(placeDetail.toMap());

    return placeDetail;
  }

  Future<PlaceDistanceTime> getPlaceDistanceTime(
      LatLng origin, LatLng destination) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&';
    String url =
        '${baseUrl}origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=${Constants.apiKey}&sessiontoken=$sessionToken';

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    // final result = responseData['result'];
    final PlaceDistanceTime placeDistanceTime =
        PlaceDistanceTime.fromJson(responseData);
    return placeDistanceTime;
  }

  static PlaceDetail getuserReturantDetaila(String userCountryCode) {
    if (userCountryCode == "+1") {
      //return USA
      return PlaceDetail(
          lat: Constants.unitedStatesLatitude,
          lng: Constants.unitedStatesLongitude,
          formattedAddress: Constants.unitedStateformattedAddress,
          formattedPhoneNumber: Constants.unitedStatesPhoneNumber,
          website: Constants.appWebsite,
          name: Constants.resturantName);
    }
    if (userCountryCode == "+254") {
      //return KENYA
      return PlaceDetail(
          lat: Constants.kenyaLatitude,
          lng: Constants.kenyaLongitude,
          formattedAddress: Constants.kenyaformattedAddress,
          formattedPhoneNumber: Constants.kenyaPhoneNumber,
          website: Constants.appWebsite,
          name: Constants.resturantName);
    }
    if (userCountryCode == "+592") {
      return PlaceDetail(
          lat: Constants.kenyaLatitude,
          lng: Constants.kenyaLongitude,
          formattedAddress: Constants.guyayanaformattedAddress,
          formattedPhoneNumber: Constants.guyaynaPhoneNumber,
          website: Constants.appWebsite,
          name: Constants.resturantName);
    }
    return null;
  }

  static double caCulateDeliveryFees(String miles) {
    final mileParsed = miles.replaceAll(" mi", "");
    final calculatedMiles = double.parse(mileParsed) * 100;
    return calculatedMiles;
  }
}
