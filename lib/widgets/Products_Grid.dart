import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyfavorite;

  ProductsGrid(this.showOnlyfavorite);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(
        context); //Poskytne nám všechny metody které patří do provideru Products
    final products = showOnlyfavorite
        ? productData.favoriteItems
        : productData.items1; //Volaní metody items1
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //2 položky v řadě
            childAspectRatio: 3 / 2, //Aspect ration položky př 2/2 je čtverec
            crossAxisSpacing: 10, //místo mezi položkami
            mainAxisSpacing: 10),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(products[index].id, products[index].title,
                  products[index].imageUrl),
            ));
  }
}
