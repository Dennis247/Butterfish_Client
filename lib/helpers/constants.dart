import 'package:flutter/material.dart';
import 'package:provider_pattern/models/orders.dart';

class Constants {
  static String appName = "Bread & Butter Fish";
  static String appWebsite = "http://teas-tarts-tings.com";
  static String resturantName = "ButterFish & Bread";
  static String publicKey = "FLWPUBK-03e61b2ad958b0c3391be19044654bda-X";
  static String encryptionKey = "667fd7b1273b2d4b0e1f853d";
  static String secretKey = "FLWSECK-667fd7b1273b7132f8213bf4d12f7f60-X";

  static String kenyaCode = "+254";
  static double kenyaLatitude = -1.288709;
  static double kenyaLongitude = 36.896640;
  static String kenyaformattedAddress =
      "Donholm-Harambee Sacco St, Nairobi, Kenya";
  static String kenyaPhoneNumber = "+254757461411";
  static double constantUnit = 10.0;

  static String unitedStatesCode = "+1";
  static double unitedStatesLatitude = 41.8928;
  static double unitedStatesLongitude = -87.6317;
  static String unitedStateformattedAddress = "Syokimart Shopping Mall";
  static String unitedStatesPhoneNumber = "+254757461411";

  static String guyanaCode = "+592";
  static double guyanaLatitude = 4.8604;
  static String guyayanaformattedAddress = "Syokimart Shopping Mall";
  static double guyanaLongitude = 58.9302;
  static String guyaynaPhoneNumber = "+254757461411";

  //static String apiKey = "AIzaSyCDJa_D_Ewcm8wE8OAH6uBQttSxALdoNUI";

  static String apiKey = "AIzaSyBaSy0NPJ63AzVrji8aIqYx0Ilwm1acUZw";

  static String firebaseUrl = "https://butterfishbread.firebaseio.com";
  static String notificationMail = "butterfishandbread@gmail.com";
  static String notificationMailPassword = "Butter12fish";

  //orders status
  static String pendingOrderStatus = "pending";
  static String cancelledOrderStatus = "Cancelled";
  static String deliveredOrderStatus = "delivered";

  static Color categoryColor = Color.fromARGB(100, 0, 0, 0);

  static String sucessfullStatus = "SUCESSFULL";
  static String failedStatus = "CANCELLED";
  static String pendingStatus = "PENDING";

  //logo
  static String logoUrl = "assets/images/logo.jpeg";

  //
  static String initaitePaymentUrl = "https://api.flutterwave.com/v3/payments";

  //Colors for theme
  static Color primaryColor = Color(0xff5563ff);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xff5563ff);
  static Color darkAccent = Color(0xff5563ff);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600];

  static double buttonFontSize = 15.0;
  static double buttonCurveSize = 5.0;
  static double amountSize = 16.0;
  static double ratingSize = 12.0;

  static String signUp = "signUp";
  static String signInWithPassword = "signInWithPassword";

  static void showErrorDialog(String errorMessage, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                "Something Went Wrong",
                style: TextStyle(color: Colors.red),
              ),
              content: Text(errorMessage),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    })
              ],
            ));
  }

  static void showSuccessDialogue(String sucessMessage, BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                "Operation Sucessfull",
                style: TextStyle(color: Colors.green),
              ),
              content: Text(sucessMessage),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    })
              ],
            ));
  }

  static Size getScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size;
  }

  static String adminNotificationTemplate(OrderItem orderNotification) {
    String updatedTemplate = '''
<p><img src="https://res.cloudinary.com/butterfish-bread/image/upload/v1594226183/logo_x8ayl8.jpg" height="150" width="150"></p>
<table style="width:100.0%;border-collapse: collapse;border:none;" title="Fax heading layout table">
    <tbody>
        <tr>
            <td style="width: 130.85pt;border-top: none;border-right: none;border-left: none;border-image: initial;border-bottom: 1pt dashed rgb(166, 166, 166);padding: 0cm 0cm 7.2pt;vertical-align: bottom;">
                <p style='margin:0cm;margin-bottom:.0001pt;font-size:64px;font-family:"Bookman Old Style",serif;color:#383842;'><span style="font-size:29px;">New Order</span></p>
            </td>
            <td style="width: 337.15pt;border-top: none;border-right: none;border-left: none;border-image: initial;border-bottom: 1pt dashed rgb(166, 166, 166);padding: 0cm 0cm 7.2pt;vertical-align: bottom;">
                <p style='margin:0cm;margin-bottom:.0001pt;text-align:right;line-height:115%;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:29px;line-height:115%;color:#00B0F0;">Butterfish &amp; Bread</span></p>
            </td>
        </tr>
    </tbody>
</table>
<p style='margin:0cm;margin-bottom:.0001pt;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'>&nbsp;</p>
<table style="float: left;width:100.0%;border-collapse: collapse;border:none;margin-left:6.75pt;margin-right:6.75pt;" title="Layout table">
    <tbody>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Name:</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.name}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Phone:</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.phoneNumber}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Email:</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.email}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 2.35pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Reference No:</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 2.35pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.referenceNo}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Order No</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.oderNo}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Narration</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.narration}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Delivery Address</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.deliveryAddress}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Payment Method</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.paymentMethod}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'><span style="font-size:16px;">Total Amount</span></h1>
            </td>
            <td style="width: 359.7pt;border: none;padding: 0cm;height: 6.6pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'><span style="font-size:16px;">${orderNotification.totalAmount}</span></p>
            </td>
        </tr>
        <tr>
            <td style="width: 108.3pt;border-top: none;border-right: none;border-left: none;border-image: initial;border-bottom: 1pt dashed rgb(166, 166, 166);padding: 0cm;height: 4pt;vertical-align: top;">
                <h1 style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;font-weight:normal;'>&nbsp;</h1>
            </td>
            <td style="width: 359.7pt;border-top: none;border-right: none;border-left: none;border-image: initial;border-bottom: 1pt dashed rgb(166, 166, 166);padding: 0cm;height: 4pt;vertical-align: top;">
                <p style='margin-top:0cm;margin-right:0cm;margin-bottom:6.0pt;margin-left:0cm;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'>&nbsp;</p>
            </td>
        </tr>
    </tbody>
</table>
<p style='margin-top:0cm;margin-right:0cm;margin-bottom:10.0pt;margin-left:0cm;line-height:115%;font-size:13px;font-family:"Gill Sans MT",sans-serif;color:black;'>&nbsp;</p>
    ''';
    return updatedTemplate;
  }
}
