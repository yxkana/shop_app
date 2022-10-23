import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/edit_product_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products('', " ", []),
              update: (context, auth, previouseProducts) => Products(
                  auth.token ?? "",
                  auth.userId ?? "",
                  previouseProducts == null ? [] : previouseProducts.items1)),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('', "", []),
              update: (context, auth, previouseOrders) => Orders(
                  auth.token ?? "",
                  auth.userId ?? "",
                  previouseOrders == null ? [] : previouseOrders.orders))
        ],
        child: Consumer<Auth>(
          builder: ((context, value, _) => MaterialApp(
                title: "MyShops",
                theme: ThemeData(
                    pageTransitionsTheme: PageTransitionsTheme(builders: {
                      TargetPlatform.android: CustomPageTransitionBuilder()
                    }),
                    fontFamily: "Lato",
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
                            .copyWith(secondary: Colors.deepOrangeAccent)),
                home: value.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                        future: value.tryAutoLogin(),
                        builder: (ctx, authResSnapshot) =>
                            authResSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ),
                routes: {
                  ProductDetailScreen.routeName: (context) =>
                      ProductDetailScreen(),
                  Cart_Screen.routeName: (context) => Cart_Screen(),
                  OrderScreen.routeName: (context) => OrderScreen(),
                  UserproductsScreen.routeName: (context) =>
                      UserproductsScreen(),
                  EditProductScreen.routeName: (context) => EditProductScreen()
                },
              )),
        ));
  }
}
