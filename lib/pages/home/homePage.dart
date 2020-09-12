import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/models/category.dart';
import 'package:provider_pattern/models/product.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/category/categoryPage.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/pages/widgets/category_item.dart';
import 'package:provider_pattern/pages/widgets/product_item.dart';
import 'package:provider_pattern/provider/authProvider.dart';
import 'package:provider_pattern/provider/categoryProvider.dart';
import 'package:provider_pattern/provider/productProvider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';

enum FilteredOptions { favourites, all }

class HomePage extends StatelessWidget {
  static final String routeName = "/home-Page";
  @override
  Widget build(BuildContext context) {
    //store unknown user profile here
    Provider.of<AuthProvider>(context, listen: false).getAnonymousUserProfile();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          elevation: 6.0,
          title: Text(
            "BUTTER FISH & BREAD",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Favourite",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "See all food items",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              category: Category(name: "All FOOD ITEMS"),
                              isallCategories: true,
                            ),
                          ));
                    },
                  ),
                ],
              ),

              SizedBox(height: 10.0),

              //Horizontal List here
              Container(
                height: MediaQuery.of(context).size.height / 2.4,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream: productRef.onValue,
                    builder: (context, AsyncSnapshot<Event> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "An Error Occured Loading Food Items List",
                            ),
                          );
                        } else {
                          List<Product> loadedProduct = productProvider
                              .getProductStreaList(snapshot.data.snapshot);
                          return loadedProduct.length > 0
                              ? ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final product = loadedProduct[index];
                                    return ProductItem(product);
                                  })
                              : Center(
                                  child: Text("Category List is empty"),
                                );
                        }
                      }
                    }),
              ),

              SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0),

              Container(
                height: MediaQuery.of(context).size.height / 6,
                child: StreamBuilder(
                    stream: categoryRef.onValue,
                    builder: (context, AsyncSnapshot<Event> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "An Error Occured Loading Food Items List",
                            ),
                          );
                        } else {
                          List<Category> loadedCategory = categoryProvider
                              .getCategoryStreamList(snapshot.data.snapshot);

                          return loadedCategory.length > 0
                              ? ListView.builder(
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: loadedCategory.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CategoryItem(loadedCategory[index]);
                                  },
                                )
                              : Center(
                                  child: Text(
                                      "You Currently do not have any Orders"));
                        }
                      }
                    }),

                //FutureBuilder(
                //   future: Provider.of<CategoryProvider>(context,
                //           listen: false)
                //       .getCategories(),
                //   builder: (ctx, dataSnapShot) {
                //     if (dataSnapShot.connectionState ==
                //         ConnectionState.waiting) {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     } else {
                //       if (dataSnapShot.error != null) {
                //         return Center(
                //           child: Text("An Error has Occured"),
                //         );
                //       } else {
                //         return Consumer<CategoryProvider>(
                //             builder: (ctx, categoryData, child) =>
                //                 categoryData.categories.length > 0
                //                     ? ListView.builder(
                //                         primary: false,
                //                         scrollDirection:
                //                             Axis.horizontal,
                //                         shrinkWrap: true,
                //                         itemCount: categoryData
                //                             .categories.length,
                //                         itemBuilder:
                //                             (BuildContext context,
                //                                 int index) {
                //                           return CategoryItem(
                //                               categoryData
                //                                   .categories[index]);
                //                         },
                //                       )
                //                     : Center(
                //                         child: Text(
                //                             "You Currently do not have any Orders"),
                //                       ));
                //       }
                //     }
                //   },
                // )
              ),

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
