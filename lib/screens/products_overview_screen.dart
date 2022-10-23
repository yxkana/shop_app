import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

import '../widgets/Products_Grid.dart';
import '../widgets/app_drawer.dart';

enum FilteredOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct(false).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyShops"), actions: [
        PopupMenuButton(
          onSelected: ((FilteredOptions selectedValue) {
            setState(() {
              if (selectedValue == FilteredOptions.Favorites) {
                _showOnlyFavorite = true;
              } else {
                _showOnlyFavorite = false;
              }
            });
          }),
          itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text("Only Favorite"),
              value: FilteredOptions.Favorites,
            ),
            const PopupMenuItem(
              child: Text("show All"),
              value: FilteredOptions.All,
            ),
          ],
          icon: Icon(Icons.more_vert),
        ),
        Consumer<Cart>(
          builder: (_, value, ch) => Badge(
            child: ch as Widget,
            value: value.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_basket),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Cart_Screen.routeName,
              );
            },
          ),
        )
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              _showOnlyFavorite), //Wiget je volán z /widgets/Products_grid
    );
  }
}
