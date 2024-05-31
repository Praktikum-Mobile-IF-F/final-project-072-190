import 'dart:convert';

import 'package:final_project/screens/detail_product_screen.dart';
import 'package:final_project/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/models/order.dart';

class HistoryOrderScreen extends StatefulWidget {
  const HistoryOrderScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOrderScreen> createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  late String _email = '';
  late List<OrderedProduct> orderedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadOrderedProducts();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        _email = json.decode(user)['email'];
      });
    }
    _loadOrderedProducts();
  }

  Future<void> _loadOrderedProducts() async {
    final orderBox = await Hive.openBox<Order>('orderBox');
    Order? order = orderBox.get(_email);
    if (order != null) {
      setState(() {
        orderedProducts = order.products
            .toList()
            .reversed
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _loadOrderedProducts();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ordered Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: orderedProducts.isEmpty
          ? Center(
        child: Text(
          'No ordered products available',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      )
          : ListView.builder(
        itemCount: orderedProducts.length,
        itemBuilder: (context, index) {
          final orderedProduct = orderedProducts[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(orderedProduct: orderedProduct),
                ),
              );
            },
            title: Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black.withOpacity(0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.network(
                      orderedProduct.products.isNotEmpty
                          ? orderedProduct.products[0].imageUrl ?? ''
                          : 'No Image URL',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${orderedProduct.orderId}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Price: ${orderedProduct.totalPrice}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Items: ${orderedProduct.products.length}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          ;
        },
      ),
    );
  }
}

