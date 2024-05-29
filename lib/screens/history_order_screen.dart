import 'dart:convert';

import 'package:final_project/models/order.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryOrderScreen extends StatefulWidget {
  const HistoryOrderScreen({super.key});

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
    setState(() {
      orderedProducts = order?.products.toList().reversed.toList() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _loadOrderedProducts();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ordered Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: orderedProducts.isEmpty
          ? const Center(
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
          // final product = convertFavoriteProduct(favoriteProduct);
          return ListTile(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => DetailScreen(product: product),
            //     ),
            //   );
            // },
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
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(14.0),
                  //       child: SizedBox(
                  //         height: 100,
                  //         width: 110,
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(12),
                  //           child: Image.network(
                  //             favoriteProduct.imageUrl ?? 'No Image Url',
                  //             fit: BoxFit.contain,
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                orderedProduct.totalPrice ?? 'No Total Price' ,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text(
                        //         favoriteProduct.brandName ?? 'No Brand Name',
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 1,
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           color: Colors.black54,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 2),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text(
                        //         '${favoriteProduct.priceCurrency} ${favoriteProduct.priceValue}',
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 1,
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 2),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text(
                        //         '${job.annualSalaryMin} - ${job.annualSalaryMax}',
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 1,
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           color: Colors.black54,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
