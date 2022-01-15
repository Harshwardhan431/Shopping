import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/auth.dart';
import 'package:shopping/provider/cards.dart';
import 'package:shopping/provider/order.dart';
import 'package:shopping/provider/products_provider.dart';
import 'package:shopping/screens/auth_screen.dart';
import 'package:shopping/screens/cart_screens.dart';
import 'package:shopping/screens/edit_product_screen.dart';
import 'package:shopping/screens/orders_screen.dart';
import 'package:shopping/screens/product_detail_screen.dart';
import 'package:shopping/screens/products_overview_screen.dart';
import 'package:shopping/screens/splash_screen.dart';
import 'package:shopping/screens/user_products_screen.dart';
import 'package:shopping/widgets/product_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeNamed: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        //ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProxyProvider<Auth, Products>(
          //used to pass parameter from one class to another
          // create: (ctx)=>Products(authToken, _items),
          create: (_) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
              auth.token!,
              auth.userId!,
              previousProducts!.items == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
              auth.token!,
              auth.userId!,
              previousOrders!.orders == null ? [] : previousOrders.orders),
        ),
        /* ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),*/
      ],
    );
  }
}
