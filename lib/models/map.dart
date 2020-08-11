import 'package:flutter/material.dart';

class Place {
  final String description;
  final String placeId;

  Place({this.description, this.placeId});

  Place.fromJson(Map<String, dynamic> json)
      : this.description = json['description'],
        this.placeId = json['place_id'];

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'placeId': this.placeId,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String name;
  final double rating;
  final String vicinity;
  final String website;
  final double lat;
  final double lng;

  PlaceDetail({
    this.placeId,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.name,
    this.rating,
    this.vicinity,
    this.website = '',
    this.lat,
    this.lng,
  });

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.formattedAddress = json['formatted_address'],
        this.formattedPhoneNumber = json['formatted_phone_number'],
        this.name = json['name'],
        this.rating = json['rating'] != null ? json['rating'].toDouble() : 0.00,
        this.vicinity = json['vicinity'],
        this.website = json['website'] ?? '',
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'];

  Map<String, dynamic> toMap() {
    return {
      'placeId': this.placeId,
      'formateedAddress': this.formattedAddress,
      'formateedPhoneNumber': this.formattedPhoneNumber,
      'name': this.name,
      'rating': this.rating,
      'vicinity': this.vicinity,
      'website': this.website,
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}

class PlaceDistanceTime {
  final String destinationAddress;
  final String originAddress;
  final String distance;
  final String duration;

  PlaceDistanceTime(
      {@required this.destinationAddress,
      @required this.originAddress,
      @required this.distance,
      @required this.duration});

  PlaceDistanceTime.fromJson(Map<String, dynamic> json)
      : this.destinationAddress = json['destination_addresses'][0],
        this.distance = json['rows'][0]['elements'][0]['distance']['text'],
        this.originAddress = json['origin_addresses'][0],
        this.duration = json['rows'][0]['elements'][0]['duration']['text'];
}
