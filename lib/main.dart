import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/pages/auth/auth_screen.dart';
import 'package:provider_pattern/pages/auth/reset_password_screen.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/home/homePage.dart';
import 'package:provider_pattern/pages/user/profilePage.dart';
import 'package:provider_pattern/pages/orders/orderPage.dart';
import 'package:provider_pattern/pages/product/product_details_screen.dart';
import 'package:provider_pattern/pages/user/referalCode.dart';
import 'package:provider_pattern/pages/widgets/splashWIdget.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/categoryProvider.dart';
import 'package:provider_pattern/provider/orderProvider.dart';
import 'package:provider_pattern/provider/paymentProvider.dart';
import 'package:provider_pattern/provider/productProvider.dart';
import 'package:provider_pattern/provider/couponProvider.dart';
import 'package:provider_pattern/provider/NotificationProvider.dart';
import 'helpers/constants.dart';
import 'helpers/custom_route.dart';
import 'package:provider_pattern/provider/cartProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthProvider()),
          ChangeNotifierProvider.value(value: ProductProvider()),
          ChangeNotifierProvider.value(value: CartProvider()),
          ChangeNotifierProvider.value(value: CategoryProvider()),
          ChangeNotifierProvider.value(value: OrderProvider()),
          ChangeNotifierProvider.value(value: CouponProvider()),
          ChangeNotifierProvider.value(value: PaymentProvider()),
          ChangeNotifierProvider.value(value: NotificationProvider()),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authData, _) {
            return MaterialApp(
                title: 'Butter Bread & Fish',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primaryColor: Constants.primaryColor,
                    accentColor: Colors.deepOrange,
                    fontFamily: 'Lato',
                    pageTransitionsTheme: PageTransitionsTheme(builders: {
                      TargetPlatform.iOS: CustomPageTransitionBuilder(),
                      TargetPlatform.android: CustomPageTransitionBuilder(),
                    })),
                home: HomePage(),
                routes: {
                  ProductDetailsScreen.routeName: (context) =>
                      ProductDetailsScreen(),
                  CartScreen.routeName: (context) => CartScreen(),
                  OrdersScreen.routeName: (context) => OrdersScreen(),
                  AuthScreen.routeName: (context) => AuthScreen(),
                  HomePage.routeName: (context) => HomePage(),
                  ProfilePage.routeName: (context) => ProfilePage(),
                  ResetPasswordScreen.routeName: (context) =>
                      ResetPasswordScreen(),
                  ReferalCode.routeName: (context) => ReferalCode()
                });
          },
        ));
  }
}
