import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/debouncer.dart';
import 'package:provider_pattern/models/category.dart';
import 'package:provider_pattern/models/product.dart';
import 'package:provider_pattern/pages/cart/cartPage.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/pages/widgets/badge.dart';
import 'package:provider_pattern/pages/widgets/category_list_item.dart';
import 'package:provider_pattern/provider/cartProvider.dart';
import 'package:provider_pattern/provider/productProvider.dart';

class CategoryPage extends StatefulWidget {
  static final routeName = "CategoryPage";
  final Category category;
  final bool isallCategories;

  const CategoryPage({this.category, this.isallCategories});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Product> _allProducts;
  List<Product> _filteredProducts = List();
  final TextEditingController _searchControl = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    setState(() {
      if (widget.isallCategories) {
        _allProducts = currentProductList;
        _filteredProducts = _allProducts;
      } else {
        _allProducts = currentProductList
            .where((cat) => cat.categoryId == widget.category.id)
            .toList();
        _filteredProducts = _allProducts;
      }
    });

    if (widget.isallCategories) {
      _filteredProducts = currentProductList;
    } else {
      //todo filter items yet
      _filteredProducts = currentProductList
          .where((cat) => cat.categoryId == widget.category.id)
          .toList();
      //    _filteredProducts = xx;
      if (widget.category.id == currentProductList[1].categoryId) {
        print(true);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
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
        elevation: 0.0,
        title: Text(widget.category.name),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: mediaQuery.height * 0.02,
            ),
            Card(
              elevation: 2.0,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Search..",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                    onChanged: (string) {
                      _debouncer.run(() {
                        setState(() {
                          _filteredProducts = _allProducts
                              .where((f) => (f.title
                                  .toLowerCase()
                                  .contains(string.toLowerCase())))
                              .toList();
                        });
                      });
                    },
                  )),
            ),
            SizedBox(height: 10.0),
            if (_filteredProducts.length > 0)
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                    value: _filteredProducts[index],
                    child: CategoryListItem(),
                  );
                },
              ),
            if (_filteredProducts.length == 0)
              Center(
                child: Text("No items in this Category"),
              ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
