import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List<Offer> offerlist;
final offersRef = FirebaseDatabase.instance.reference().child('offers');

class OfferProvider with ChangeNotifier {
  Future<void> fetchOffers() async {
    offerlist = offerlist == null ? [] : offerlist;
    offerlist.clear();
    List<Offer> loadedOffers = [];
    try {
      await offersRef.once().then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> extractedOrders = dataSnapshot.value;
        if (extractedOrders != null) {
          extractedOrders.forEach((key, value) {
            extractedOrders.forEach((offerId, offerData) {
              loadedOffers.add(Offer(
                id: offerId,
                description: offerData['description'],
                imageUrl: offerData['imageUrl'],
                title: offerData['title'],
                price: offerData['price'],
              ));
            });
            offerlist = loadedOffers.reversed.toList();

            //  notifyListeners();
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> getOffers() async {
  //   List<Offer> loadedOffers = [];

  //   try {
  //     final response = await http
  //         .get(Constants.firebaseUrl + "/offers.json?auth=$authToken");
  //     final extractedOffers =
  //         json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedOffers != null) {
  //       extractedOffers.forEach((offerId, offerData) {
  //         loadedOffers.add(Offer(
  //           id: offerId,
  //           description: offerData['description'],
  //           imageUrl: offerData['imageUrl'],
  //           title: offerData['title'],
  //           price: offerData['price'],
  //         ));
  //       });
  //     }
  //     _offers = loadedOffers.toList();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> addOffers(Offer offer) async {
  //   try {
  //     final response = await http.post(
  //         Constants.firebaseUrl + "/offers.json?auth=$authToken",
  //         body: json.encode({
  //           'id': offer.id,
  //           'title': offer.title,
  //           'imageUrl': offer.imageUrl,
  //           'description': offer.description,
  //           'price': offer.price
  //         }));

  //     final newOffer = Offer(
  //       id: json.decode(response.body)['name'],
  //       description: offer.description,
  //       imageUrl: offer.imageUrl,
  //       title: offer.title,
  //       price: offer.price,
  //     );

  //     _offers.add(newOffer);
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> updateOffer(String offersId, Offer newOffer) async {
  //   final _updatebaseUrl =
  //       Constants.firebaseUrl + "/offers/$offersId.json?auth=$authToken";

  //   final int offerIndex = _offers.indexWhere((off) => off.id == offersId);
  //   if (offerIndex >= 0) {
  //     try {
  //       await http.patch(_updatebaseUrl,
  //           body: json.encode({
  //             'title': newOffer.title,
  //             'imageUrl': newOffer.imageUrl,
  //             'id': newOffer.id,
  //             'price': newOffer.price
  //           }));
  //     } catch (error) {
  //       print(error);
  //     }
  //     _offers[offerIndex] = newOffer;
  //     notifyListeners();
  //   } else {
  //     print('newOffer update for $offersId failed');
  //   }
  // }

  // Future<void> deleteOffers(String offerId) async {
  //   final url =
  //       Constants.firebaseUrl + "/categories/$offerId.json?auth=$authToken";

  //   Offer existingOffer;
  //   int existingOfferIndex = _offers.indexWhere((cat) => cat.id == offerId);
  //   if (existingOfferIndex >= 0) {
  //     existingOffer = _offers[existingOfferIndex];
  //     _offers.removeAt(existingOfferIndex);
  //     notifyListeners();

  //     final response = await http.delete(url);
  //     if (response.statusCode >= 400) {
  //       _offers.insert(existingOfferIndex, existingOffer);
  //       notifyListeners();
  //       throw HttpException('offer could not be deleted');
  //     } else {
  //       existingOffer = null;
  //     }
  //   }
  // }
}

class Offer {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;

  Offer({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.price,
  });
}
