import 'package:flutter/material.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/response.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'authProvider.dart';

class PaymentResponseModel {
  final ResponseModel responseModel;
  final RaveStatus raveStatus;

  PaymentResponseModel(
      {@required this.responseModel, @required this.raveStatus});
}

class PaymentProvider with ChangeNotifier {
  Future<PaymentResponseModel> startPayment(
      {@required String narration,
      @required double amount,
      @required BuildContext context,
      @required txRef,
      @required orderRef}) async {
    try {
      var initializer = RavePayInitializer(
          amount: amount,
          publicKey: Constants.publicKey,
          encryptionKey: Constants.encryptionKey,
          subAccounts: null)
        ..country = "KE"
        ..currency = "KES"
        ..email = loggedInUser.email != ""
            ? loggedInUser.email
            : "butterfishandbread@gmail.com"
        ..fName = loggedInUser.firstName
        ..lName = loggedInUser.lastName != "" ? loggedInUser.lastName : ""
        ..narration = narration
        ..txRef = txRef
        ..orderRef = orderRef
        ..acceptMpesaPayments = true
        ..acceptAccountPayments = true
        ..acceptCardPayments = true
        ..acceptAchPayments = true
        ..acceptGHMobileMoneyPayments = true
        ..acceptUgMobileMoneyPayments = true
        ..acceptMobileMoneyFrancophoneAfricaPayments = true
        ..displayEmail = true
        ..displayAmount = true
        ..staging = false
        ..isPreAuth = false
        ..displayFee = true;
      RaveResult response = await RavePayManager()
          .prompt(context: context, initializer: initializer);
      return PaymentResponseModel(
          responseModel: ResponseModel(true, response.message),
          raveStatus: response.status);
    } catch (e) {
      return PaymentResponseModel(
          responseModel: ResponseModel(true, e.toString()),
          raveStatus: RaveStatus.error);
    }
  }
}
