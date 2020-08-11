// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_pattern/models/product.dart';
// import 'package:provider_pattern/provider/productProvider.dart';

// class UserProductItem extends StatelessWidget {
//   final Product product;

//   const UserProductItem(this.product);
//   @override
//   Widget build(BuildContext context) {
//     final scaffold = Scaffold.of(context);
//     return ListTile(
//       title: Text(product.title),
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(product.imageUrl),
//       ),
//       trailing: Container(
//         width: 100,
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 // Navigator.pushNamed(context, EditProductScreen.routeName,
//                 //     arguments: product);
//               },
//               color: Theme.of(context).primaryColor,
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 showDialog(
//                     context: context,
//                     builder: (ctx) => AlertDialog(
//                           title: Text("Are You Sure ?"),
//                           content:
//                               Text("Please confirm you want to delete product"),
//                           actions: <Widget>[
//                             FlatButton(
//                               child: Text("No"),
//                               onPressed: () {
//                                 Navigator.of(ctx).pop(false);
//                               },
//                             ),
//                             FlatButton(
//                               child: Text("Yes"),
//                               onPressed: () async {
//                                 try {
//                                   Navigator.of(ctx).pop(true);
//                                   await Provider.of<ProductProvider>(context,
//                                           listen: false)
//                                       .deleteProduct(product.id);
//                                 } catch (error) {
//                                   scaffold.showSnackBar(SnackBar(
//                                     content: Text(
//                                       "Deleting failed !",
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ));
//                                 }
//                               },
//                             )
//                           ],
//                         ));
//               },
//               color: Theme.of(context).errorColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
