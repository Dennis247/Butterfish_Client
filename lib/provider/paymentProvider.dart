import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/response.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:tuple/tuple.dart';
import 'authProvider.dart';

class PaymentResponseModel {
  final ResponseModel responseModel;
  final RaveStatus raveStatus;

  PaymentResponseModel(
      {@required this.responseModel, @required this.raveStatus});
}

class PaymentProvider with ChangeNotifier {
  Dio dio = new Dio();
  Future<Tuple2<ResponseModel, String>> initiatePayment(
      {@required String narration,
      @required double amount,
      @required BuildContext context,
      @required txRef,
      @required orderRef}) async {
    Tuple2<ResponseModel, String> responseModel;
    String paymentLink = "";

    try {
      String url = Constants.initaitePaymentUrl;
      final response = await dio.post(url,
          data: {
            "tx_ref": txRef,
            "amount": amount,
            "currency": "KES",
            "redirect_url":
                "https://webhook.site/74acf48c-e485-4f77-90b9-806fd1bf2f50",
            "payment_options": "card,mpesa,qr,banktransfer,account",
            "meta": {
              "consumer_id": loggedInUser.userId != null
                  ? loggedInUser.userId
                  : Random().nextInt(10000).toString(),
              "consumer_mac": Random().nextInt(10000).toString()
            },
            "customer": {
              "email": loggedInUser.email,
              "phonenumber": loggedInUser.phoneNumber,
              "name": loggedInUser.firstName + " " + loggedInUser.lastName != ""
                  ? loggedInUser.lastName
                  : ""
            },
            "customizations": {
              "title": "Butterfish & Bread",
              "description": "Awesome meals at all times",
              "logo":
                  "https://res.cloudinary.com/mustang247/image/upload/v1582412217/food_ordering_app/demo_mj8sgk.png"
            }
          },
          options: Options(headers: {
            "content-type": "application/json",
            "Authorization": "Bearer ${Constants.secretKey}",
          }));
      if (response.statusCode == 200) {
        if (response.data['status'].toString() == "success") {
          paymentLink = response.data['data']['link'];
          responseModel = Tuple2(
              ResponseModel(true, "payment link sucessfull"), paymentLink);
        }
      } else {
        responseModel =
            Tuple2(ResponseModel(true, "payment link failed"), paymentLink);
      }
    } catch (e) {
      responseModel = Tuple2(ResponseModel(true, e.toString()), paymentLink);
    }
    return responseModel;
  }

  // Future<PaymentResponseModel> startPayment(
  //     {@required String narration,
  //     @required double amount,
  //     @required BuildContext context,
  //     @required txRef,
  //     @required orderRef}) async {
  //   try {
  //     var initializer = RavePayInitializer(
  //         amount: amount,
  //         publicKey: Constants.publicKey,
  //         encryptionKey: Constants.encryptionKey,
  //         subAccounts: null)
  //       ..country = "KE"
  //       ..currency = "KES"
  //       ..email = loggedInUser.email != ""
  //           ? loggedInUser.email
  //           : "butterfishandbread@gmail.com"
  //       ..fName = loggedInUser.firstName
  //       ..lName = loggedInUser.lastName != "" ? loggedInUser.lastName : ""
  //       ..narration = narration
  //       ..txRef = "butterfish_bread-${DateTime.now().toString()}"
  //       ..orderRef = orderRef
  //       ..acceptMpesaPayments = true
  //       ..acceptAccountPayments = true
  //       ..acceptCardPayments = true
  //       ..acceptAchPayments = true
  //       ..acceptGHMobileMoneyPayments = true
  //       ..acceptUgMobileMoneyPayments = true
  //       ..acceptMobileMoneyFrancophoneAfricaPayments = true
  //       ..displayEmail = true
  //       ..displayAmount = true
  //       ..staging = false
  //       ..isPreAuth = false
  //       ..displayFee = true;
  //     RaveResult response = await RavePayManager()
  //         .prompt(context: context, initializer: initializer);
  //     return PaymentResponseModel(
  //         responseModel: ResponseModel(true, response.message),
  //         raveStatus: response.status);
  //   } catch (e) {
  //     return PaymentResponseModel(
  //         responseModel: ResponseModel(true, e.toString()),
  //         raveStatus: RaveStatus.error);
  //   }
  // }
}
