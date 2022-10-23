import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '../screens/order_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Padding(
                padding: EdgeInsets.only(left: 5, right: 20),
                child: Icon(
                  Icons.shop,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "Shop",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
            ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 5, right: 20),
                  child: Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Orders",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      CustomRoute(builder: ((context) => OrderScreen())));
                }),
            ListTile(
              leading: const Padding(
                padding: EdgeInsets.only(left: 5, right: 20),
                child: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "User Products",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(UserproductsScreen.routeName),
            ),
            ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 5, right: 20),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("Logout from this account"),
                          content: Text("Do you want logout?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Provider.of<Auth>(context, listen: false)
                                      .logout();
                                },
                                child: Text("Yes")),
                            TextButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacementNamed("/");
                              },
                            )
                          ],
                        ))),
          ],
        ));
  }
}
