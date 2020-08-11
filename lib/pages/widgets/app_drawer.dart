import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/helpers/custom_route.dart';
import 'package:provider_pattern/pages/auth/auth_screen.dart';
import 'package:provider_pattern/pages/home/homePage.dart';
import 'package:provider_pattern/pages/orders/orderPage.dart';
import 'package:provider_pattern/pages/payment/walletSCreen.dart';
import 'package:provider_pattern/pages/user/profilePage.dart';
import 'package:provider_pattern/pages/user/referalCode.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:share/share.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  final authData = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(""),
            otherAccountsPictures: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  Share.share(
                      "Download the ButterFish & Bread App.\nPlayStore -  https://play.google.com/store/apps/details?id=com.butterfish.bread");
                },
              )
            ],
            accountEmail: loggedInUser != null
                ? Text(loggedInUser.firstName + " " + loggedInUser.lastName)
                : Text(""),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new AssetImage(Constants.logoUrl),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.blue,
                  ),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(HomePage.routeName);
                  },
                ),
                // Divider(),
                // ListTile(
                //   leading: Icon(
                //     FontAwesomeIcons.smile,
                //     color: Colors.orange,
                //   ),
                //   title: Text("Offers"),
                //   onTap: () {
                //     Navigator.of(context)
                //         .pushReplacementNamed(OffersScreen.routename);
                //   },
                // ),
                Divider(),
                ListTile(
                    leading: Icon(
                      Icons.payment,
                      color: Colors.green,
                    ),
                    title: Text(
                      "My Orders",
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          CustomRoute(builder: (ctx) => OrdersScreen()));
                    }),
                Divider(),
                ListTile(
                    leading: Icon(Icons.person, color: Colors.orange),
                    title: Text(
                      "Referal Code",
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          CustomRoute(builder: (ctx) => ReferalCode()));
                    }),
                Divider(),
                ListTile(
                    leading: Icon(
                      Icons.account_balance_wallet,
                      color: Constants.primaryColor,
                    ),
                    title: Text(
                      "My Wallet",
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          CustomRoute(builder: (ctx) => WalletSCreen()));
                    }),
                Divider(),
                // ListTile(
                //     leading: Icon(
                //       FontAwesomeIcons.lightbulb,
                //       color: Colors.pink,
                //     ),
                //     title: Text(
                //       "Events",
                //     ),
                //     onTap: () {
                //       Navigator.of(context)
                //           .pushReplacementNamed(OrdersScreen.routeName);
                //       // Navigator.of(context).pushReplacement(
                //       //     CustomRoute(builder: (ctx) => EventsScreen()));
                //     }),
                // Divider(),
                ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.purple,
                    ),
                    title: Text(
                      "My Profile",
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ProfilePage.routeName);
                    }),

                Divider(),
                loggedInUser.lastName.isNotEmpty
                    ? ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        title: Text("Log Out"),
                        onTap: () {
                          //
                          Navigator.of(context).pop();

                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName);
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                        })
                    : ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        title: Text("Log In"),
                        onTap: () {
                          //
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(AuthScreen.routeName);
                        }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
