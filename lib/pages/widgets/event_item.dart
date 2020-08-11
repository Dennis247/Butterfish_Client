import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/event.dart';

class EventItem extends StatelessWidget {
  final Event event;

  const EventItem(this.event);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return EventDetails(
        //     event: event,
        //   );
        // }));
      },
      child: ListTile(
          title: Text(
            "event type",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          subtitle: Text(
            event.title,
            style: TextStyle(color: Colors.black),
          ),
          leading: CircleAvatar(
            backgroundColor: Constants.primaryColor,
            child: event.eventType == "ADMIN"
                ? CircleAvatar(
                    backgroundImage: NetworkImage(event.imageUrl),
                  )
                : Icon(
                    Icons.event,
                    color: Colors.white,
                  ),
          ),
          trailing: event.eventType == "ADMIN"
              ? Icon(
                  FontAwesomeIcons.book,
                  color: Constants.primaryColor,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "booking date",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        event.bookingDate.year.toString() +
                            "-" +
                            event.bookingDate.month.toString() +
                            "-" +
                            event.bookingDate.day.toString(),
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )),
    );
  }
}
