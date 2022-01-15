import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  //String title;
  //ProductDetailScreen({required this.title});\
  static const routeName='detailscreen';

  @override
  Widget build(BuildContext context) {
    final productId=ModalRoute.of(context)!.settings.arguments as String; // extracting id
    final loadedProduct=Provider.of<Products>(context,listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title,style: const TextStyle(
          fontSize: 20,
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,)
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Text('Price = '+loadedProduct.price.toString(),style: const TextStyle(
              fontSize: 20,
              color: Colors.blue,
            ),)
          ],
        ),
      ),
    );
  }
}
