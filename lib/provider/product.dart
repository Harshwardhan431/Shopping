import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFavorite=false,
    required this.price,
});

  Future toggleFavoriteStatus(String token,String userId)async {
    final oldStatus=isFavorite;
    isFavorite = !isFavorite;
    var url="https://shopping-351e3-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token";
    notifyListeners();
    try{
     final response= await http.put(Uri.parse(url),//using put as we are only changing favporite for particular user
          body: json.encode(isFavorite,
          ));
     if (response.statusCode>=400){
       isFavorite=oldStatus;
       notifyListeners();
     }
    }catch (e){
      isFavorite=oldStatus;
      notifyListeners();
    }
  }
}