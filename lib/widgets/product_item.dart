import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/auth.dart';
import 'package:shopping/provider/cards.dart';
import 'package:shopping/provider/product.dart';
import 'package:shopping/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Product>(context);
    final authData=Provider.of<Auth>(context,listen: false);
    final cart=Provider.of<Cart>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(product.isFavorite? Icons.favorite : Icons.favorite_border,),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavoriteStatus(authData.token.toString(),authData.userId.toString());
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id,
                  product.title,
                  product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Iteim added to cart'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(label: 'UNDO',onPressed: (){
                cart.removeSingleItem(product.id);
              },),));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
