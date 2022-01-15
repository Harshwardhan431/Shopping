import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'cards.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String token;
  final String userId;
  Orders(this.token,this.userId,this._orders);

  Future fetchAndSetOrders() async {
    var url = "https://shopping-351e3-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    print(response.body);
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((ordId, ordData) {
      loadedOrders.add(
        OrderItem(
          id: ordId,
          amount: ordData['amount'],
          products: (ordData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
          dateTime: DateTime.parse(ordData['dateTime']),
        ),
      );
    });
    _orders=loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future addOrder(List<CartItem> cartProducts, double total) async {
    var url = "https://shopping-351e3-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
