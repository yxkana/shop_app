import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import '../widgets/app_drawer.dart';

class UserproductsScreen extends StatelessWidget {
  static const routeName = "/userProduct-screen";
  var editState = false;

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your products"),
        actions: [
          IconButton(
              onPressed: () {
                editState = true;
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                );
              },
              icon: Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Consumer<Products>(
                      builder: (context, value, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: ((context, index) => Column(children: [
                                UserProductItem(
                                    value.items1[index].title,
                                    value.items1[index].imageUrl,
                                    value.items1[index].id),
                                Divider()
                              ])),
                          itemCount: value.items1.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
