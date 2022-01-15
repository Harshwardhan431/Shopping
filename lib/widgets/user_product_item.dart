import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/product.dart';
import 'package:shopping/provider/products_provider.dart';
import 'package:shopping/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(this.id,this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    var scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
                //argument is to pass forward the id
              },
              color: Colors.red,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: ()async {
                try{
                  await Provider.of<Products>(context,listen: false).deleteProducts(id);
                }catch (e){
                  scaffold.showSnackBar(SnackBar(content: Text('Deleting Failed!')));
                }
              },
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
