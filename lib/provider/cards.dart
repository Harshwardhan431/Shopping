import 'package:flutter/material.dart';
import 'package:shopping/widgets/cart_item.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
  {
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};
  //returns the copy of above map
  Map<String,CartItem>get items{
    return {..._items};
}

int get itemCount{
    return _items.length;
}

double get totalAmount{
    var total=0.0;
    _items.forEach((key, cardItem) {
      total+=cardItem.price*cardItem.quantity;
    });
    return total;
}

void addItem(String productId,String title,double price,){
    if (_items.containsKey(productId)){
      //change the existing quantity...
      _items.update(productId, (existingValue) => CartItem(
          id: existingValue.id,
          title: existingValue.title,
          price: existingValue.price,
          quantity: existingValue.quantity+1,));
    }
    else{
      _items.putIfAbsent(productId,()=> CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
        quantity: 1,
          ));
    }
    notifyListeners();
}

void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
}

void removeSingleItem(String productId){
    if (!_items.containsKey(productId))return;
    if (_items[productId]!.quantity>1){
      _items.update(productId, (existingValue) => CartItem(id: existingValue.id,
          title: existingValue.title,
          price: existingValue.price,
          quantity: existingValue.quantity-1));
    }
    if (_items[productId]!.quantity==1){
      _items.remove(productId);
    }
    notifyListeners();
}

//to clear the order
void clear(){
    _items={};
    notifyListeners();
}
}