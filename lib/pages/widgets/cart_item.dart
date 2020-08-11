import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/provider/cartProvider.dart';

class CartItemWIdget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imgrl;

  const CartItemWIdget(this.id, this.productId, this.price, this.quantity,
      this.title, this.imgrl);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are You Sure ?"),
                  content: Text("Do You want to remove item from the cart"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        final cartContainer = Provider.of<CartProvider>(context, listen: false);
        cartContainer.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              // child: FittedBox(
              //     child: Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: Text("Ksh$price"),
              // )),
              radius: 30.0,
              backgroundImage: NetworkImage(imgrl),
              backgroundColor: Colors.transparent,
            ),
            title: Text(title),
            subtitle: Text("price : Ksh$price "),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Quantity :$quantity x"),
                SizedBox(
                  height: 5,
                ),
                Text("Total : Ksh${price * quantity}"),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
