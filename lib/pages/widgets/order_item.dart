import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  const OrderItemWidget(this.orderItem);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  Color getOrderStatus(String staus) {
    if (staus == Constants.pendingStatus) return Colors.yellow;
    if (staus == Constants.deliveredOrderStatus) return Colors.green;
    if (staus == Constants.cancelledOrderStatus) return Colors.red;

    return Colors.yellow;
  }

  Color getOrderTextColor(String staus) {
    if (staus == Constants.pendingStatus) return Colors.blue;
    if (staus == Constants.deliveredOrderStatus) return Colors.white;
    if (staus == Constants.cancelledOrderStatus) return Colors.white;

    return Colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _expanded
          ? min(widget.orderItem.products.length * 30.0 + 200.0, 295.00)
          : 150,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "${widget.orderItem.amount}",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat(
                      'dd-MM-yyyy hh:mm',
                    ).format(widget.orderItem.dateTime),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 10),
                  ),
                  Chip(
                    backgroundColor: getOrderStatus(widget.orderItem.status),
                    label: Text(
                      widget.orderItem.status,
                      style: TextStyle(
                          color: getOrderTextColor(widget.orderItem.status),
                          fontSize: 8),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Constants.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.orderItem.products.length * 15.0 + 50.0, 180.00)
                  : 0,
              child: ListView(
                children: widget.orderItem.products
                    .map((prod) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${prod.quantity}x  Ksh${prod.price}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Delivery Address : ${widget.orderItem.deliveryAddress}",
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
