import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/cards.dart';
import 'package:shopping/provider/products_provider.dart';
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/badge.dart';
import 'package:shopping/widgets/products_girds.dart';
import 'cart_screens.dart';

enum FilterOption{
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit=true;
  var _isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    //Provider.of<Products>(context).fetchAndSetProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit){
      setState(() {
        _isLoading=true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value){
        setState(() {
          _isLoading=false;
        });
      });
    }_isInit=false;
    super.didChangeDependencies();
  }

  var _showOnlyFavorites=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selected){
               setState(() {
                 if (selected==FilterOption.Favorites){
                   _showOnlyFavorites=true;
                 }else{
                   _showOnlyFavorites=false;
                 }
               });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context)=>[
                const PopupMenuItem(child: Text('Ony Favorites'),value: FilterOption.Favorites,),
                const PopupMenuItem(child: Text('Show All'),value: FilterOption.All,),
              ]),
          Consumer<Cart>(//consumer only a part of widget tree is rebuild again ie builder is re-build but in provider hole and sole is re-build
              builder: (_,cart,ch)=>Badge(
                  //key: key,
                  child: ch!,
                  value: cart.itemCount.toString(),
                  color: Colors.red),
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),): ProductsGird(shoefav: _showOnlyFavorites,),
    );
  }
}

/*
class ProductOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //final productContainer=Provider.of<Products>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selected){
              if (selected==FilterOption.Favorites){
                //productContainer.showFavoritesOnly();
              }else{
                //productContainer.showAll();
              }
            },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context)=>[
                PopupMenuItem(child: Text('Ony Favoritie'),value: FilterOption.Favorites,),
                PopupMenuItem(child: Text('Show All'),value: FilterOption.All,),
              ])
        ],
      ),
      body: ProductsGird(),
    );
  }
}*/
