import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/products_provider.dart';
import 'package:shopping/widgets/product_item.dart';

class ProductsGird extends StatelessWidget {
  bool shoefav=false;
  ProductsGird({required this.shoefav});

  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    final products=shoefav?productsData.favoriteItem: productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(create: (c)=> products[i],
          child: ProductItem(),),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
