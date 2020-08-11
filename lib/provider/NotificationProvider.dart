import 'package:flutter/material.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class NotificationProvider with ChangeNotifier {
  Future<void> sendOrderNotification(
      {DateTime date, String subject, String body}) async {
    String username = Constants.notificationMail;
    final smtpServer = gmail('butterfishandbread@gmail.com', 'Butter12fish');

    final message = Message()
      ..from = Address(username, 'ButterFish & Bread')
      ..recipients.addAll(['dosamuyimen@gmail.com', 'goodlink77@gmail.com'])
      ..ccRecipients.addAll(['dosamuyimen@gmail.com', 'goodlink77@gmail.com'])
      ..bccRecipients.add(Address('dosamuyimen@gmail.com'))
      ..subject = subject
      ..text = body
      ..html = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
