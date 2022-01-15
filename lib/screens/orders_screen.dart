import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/order.dart' show Orders;
import 'package:shopping/widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeNamed='/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    /*Future.delayed(Duration.zero).then((_)async{
      setState(() {
        _isLoading=true;
      });
     await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
     setState(() {
       _isLoading=false;
     });
    });*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
        builder: (ctx,dataSnapshot){
        if (dataSnapshot.connectionState==ConnectionState.waiting){
          return Center(child: const CircularProgressIndicator());
        }else{
          if (dataSnapshot.error!=null){
            return Text('Error');
            //do error handling
        }else{//here we need to use consumer or else with provider this will go in infinite loop
            return  Consumer<Orders>(
        builder: (ctx,orderData,child)=>ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        ),);
        }
        }
      },),
    );
  }
}
