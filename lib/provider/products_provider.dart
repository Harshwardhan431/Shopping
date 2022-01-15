import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping/model/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier{
   List<Product> _items=[
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  List<Product> get favoriteItem{
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //var _showFavoriteOnly=false;
  //returing list of only favorite items
  List<Product> get items{
   /* if (_showFavoriteOnly){
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }*/
    return [..._items];
  }

   String authToken='';
  String userId='';
  Products(this.authToken,this.userId,this._items);

  /*void showFavoritesOnly() {
    _showFavoriteOnly=true;
    notifyListeners();
  }

  void showAll(){
    _showFavoriteOnly=false;
    notifyListeners();
  }*/

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id==id);
  }

  Future fetchAndSetProducts([bool filterByUser=false])async{
   // print(userId);
    final filterString= filterByUser? 'orderBy="createrId"&equalTo="$userId"':'';
    var url='https://shopping-351e3-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
   try{
     final response=await http.get(Uri.parse(url));
     print('kkk');
     print(json.decode(response.body));
     print('kkkkk');
     final extractedData=json.decode(response.body) as Map<String,dynamic>;

     var urlFav="https://shopping-351e3-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken";
     final favoriteResponse=await http.get(Uri.parse(urlFav));
     final favoriteData=json.decode(favoriteResponse.body);
     //print(response.body);
     final List<Product> loadedProduct=[];
     extractedData.forEach((proId, proData) {
      // print(proData['title']);
       loadedProduct.add(Product(id: proId,
           title: proData['title'],
           description: proData['description'],
           imageUrl: proData['imageUrl'],
           isFavorite: favoriteData==null? false: favoriteData[proId],
           price: proData['price']));
     });
     _items=loadedProduct;
     notifyListeners();
   }catch (e){
     throw e;
   }
  }

  Future addProduct(Product product)async{
    //adding data in firebase
    var url="https://shopping-351e3-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    Map<String,dynamic> mk={
      'title':product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'createrId': userId,
    };
    try{
      final response= await http.post(Uri.parse(url), body: json.encode(mk));
      print(json.decode(response.body));
      //adding data in local machine
      final newProduct=Product(id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: double.parse(product.price.toString()));
      _items.add(newProduct);
      notifyListeners();
    }catch (e){
      throw e;
    }
  }

  Future updateProduct(String id,Product newProduct)async{
    var url="https://shopping-351e3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

    final prodIndex=_items.indexWhere((element) => element.id==id);
    if (prodIndex>=0){
      http.patch(Uri.parse(url),
          body: json.encode({
           'title':newProduct.title,
            'description':newProduct.description,
            'imageUrl':newProduct.imageUrl,
            'price':double.parse(newProduct.price.toString()),
      }));
      _items[prodIndex]=newProduct;
      notifyListeners();
    }else{
      print('product Index is less than 0');
    }
  }

  Future deleteProducts(String id)async{
    var url="https://shopping-351e3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    //http.delete(Uri.parse(url)); only this can be done to delete

    //optmitic deleting
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = Product(id: '', title: '', description: '', imageUrl: '', price: 0.00);
  }
}