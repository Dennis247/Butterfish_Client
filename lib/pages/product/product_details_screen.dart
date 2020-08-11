import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/product.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:toast/toast.dart';

class ProductDetailsScreen extends StatefulWidget {
  static final String routeName = "/productDetail";

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  Widget buildProductItem(Product product) {
    return Container(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 3.0,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    child: Hero(
                      tag: product.id != null ? product.id : "xxx",
                      child: CachedNetworkImage(
                        imageUrl: "${product.imageUrl}",
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6.0,
                  right: 6.0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 6.0,
                    left: 6.0,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "\$ ${product.price}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            )))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuantity() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  }),
              SizedBox(
                width: 15,
              ),
              Text(
                quantity.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      quantity = --quantity == 0 ? 1 : quantity;
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDescription(Product product) {
    return ListTile(
        title: Text(
          "${product.title}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          product.description,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final loadedProduct = ModalRoute.of(context).settings.arguments as Product;
    // final loadedProduct =
    //     Provider.of<Products>(context, listen: false).getProduct(productId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("DETAILS"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: buildProductItem(loadedProduct),
            ),
            buildQuantity(),
            SizedBox(height: 15),
            buildDescription(loadedProduct),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaterialButton(
          height: 45,
          color: Constants.primaryColor,
          onPressed: () {
            cart.addDetailCartItem(loadedProduct, quantity);
            Toast.show("Your item has been added to the cart", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "ADD TO CART",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
