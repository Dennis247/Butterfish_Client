import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/pages/widgets/order_item.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/provider/orderProvider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
          centerTitle: true,
          actions: <Widget>[
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: StreamBuilder(
            stream: orderRef.child(loggedInUser.userId).onValue,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Could not load Order Items"),
                  );
                } else {
                  DataSnapshot dataSnapshot = snapshot.data.snapshot;
                  final orderList =
                      Provider.of<OrderProvider>(context, listen: false)
                          .getStreamOrderList(dataSnapshot);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: orderList.length > 0
                        ? ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return OrderItemWidget(orderList[index]);
                            },
                            itemCount: orderList.length,
                          )
                        : Center(
                            child: Text("You Currently do not have any Orders"),
                          ),
                  );
                }
              }
            }));
  }
}

//  FutureBuilder(
//   future:
//       Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
//   builder: (ctx, dataSnapShot) {
//     if (dataSnapShot.connectionState == ConnectionState.waiting) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     } else {
//       if (dataSnapShot.error != null) {
//         return Center(
//           child: Text("An Error has Occured"),
//         );
//       } else {
//         return Consumer<OrderProvider>(
//             builder: (ctx, orderData, child) => orderData
//                         .orders.length >
//                     0
//                 ? ListView.builder(
//                     itemBuilder: (BuildContext context, int index) {
//                       return OrderItemWidget(orderData.orders[index]);
//                     },
//                     itemCount: orderData.orders.length,
//                   )
//                 : Center(
//                     child: Text("You Currently do not have any Orders"),
//                   ));
//       }
//     }
//   },
// ));
//   }
// }
