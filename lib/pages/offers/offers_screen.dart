import 'package:cached_network_image/cached_network_image.dart';
/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider_pattern/helpers/constants.dart';
import 'package:provider_pattern/models/product.dart';
import 'package:provider_pattern/pages/product/product_details_screen.dart';
import 'package:provider_pattern/pages/widgets/app_drawer.dart';
import 'package:provider_pattern/pages/widgets/swiper_pagination.dart';
import 'package:provider_pattern/provider/offersProvider.dart';

class OffersScreen extends StatefulWidget {
  static final String routename = "offers-screen";
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final SwiperController _swiperController = SwiperController();
  int _pageCount = 0;
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    _voidGetOffers();
    super.initState();
  }

  void _setLoadingState(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> _voidGetOffers() async {
    _setLoadingState(true);
    await Provider.of<OfferProvider>(context, listen: false).fetchOffers();
    _setLoadingState(false);
  }

  @override
  Widget build(BuildContext context) {
    //  final offerData = Provider.of<OfferProvider>(context, listen: false);
    _pageCount = offerlist == null ? 0 : offerlist.length;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("SPECIAL OFFERS"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://s3.amazonaws.com/static.evanced.info/Customer/ossininglibrary/MALAYSIAFOODIEGUIDE640_433CB835.JPG",
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                        child: Swiper(
                      index: _currentIndex,
                      controller: _swiperController,
                      itemCount: _pageCount,
                      onIndexChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      loop: false,
                      itemBuilder: (context, index) {
                        return _buildPage(
                            title: offerlist[index].title,
                            imageUrl: offerlist[index].imageUrl,
                            description: offerlist[index].description,
                            price: offerlist[index].price);
                      },
                      pagination: SwiperPagination(
                          builder: CustomPaginationBuilder(
                              activeSize: Size(10.0, 20.0),
                              size: Size(10.0, 15.0),
                              color: Colors.white)),
                    )),
                    SizedBox(height: 10.0),
                    _buildButtons(),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            textColor: Colors.grey.shade700,
            child: Text("Skip"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          IconButton(
            icon: Icon(
              _currentIndex < _pageCount - 1
                  ? FontAwesomeIcons.arrowCircleRight
                  : FontAwesomeIcons.checkCircle,
              size: 40,
              color: Constants.primaryColor,
            ),
            onPressed: () async {
              if (_currentIndex < _pageCount - 1)
                _swiperController.next();
              else {
                Navigator.of(context).pushReplacementNamed("/");
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage(
      {String title, String imageUrl, String description, double price}) {
    final TextStyle titleStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(Colors.black38, BlendMode.multiply
            // )
          ),
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(5.0, 5.0),
                color: Colors.black26)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: titleStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
          Hero(
            tag: "xxx",
            child: RaisedButton(
              color: Constants.primaryColor,
              splashColor: Constants.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Constants.primaryColor)),
              onPressed: () {
                final Product product = new Product(
                    id: null,
                    title: title + "(special offer)",
                    description: description,
                    price: price,
                    imageUrl: imageUrl);
                Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                    arguments: product);
              },
              child: Text(
                "PURCHASE OFFER",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
