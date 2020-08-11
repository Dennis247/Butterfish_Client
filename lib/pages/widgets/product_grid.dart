// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_pattern/providers/products.dart';

// import 'product_item.dart';

// class ProductGrid extends StatelessWidget {
//   final bool _showOnlyFavourite;
//   ProductGrid(this._showOnlyFavourite);
//   @override
//   Widget build(BuildContext context) {
//     final productsData = Provider.of<Products>(context);
//     final products = _showOnlyFavourite
//         ? productsData.items.where((prod) => prod.isFavourite).toList()
//         : productsData.items;
//     return GridView.builder(
//       padding: const EdgeInsets.all(10.0),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         return ChangeNotifierProvider.value(
//             //  builder: (context) => products[index],
//             value: products[index],
//             child: ProductItem());
//       },
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 3 / 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 2),
//     );
//   }
// }
