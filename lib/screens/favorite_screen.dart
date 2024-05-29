import 'dart:convert';
import 'package:final_project/models/favorite.dart';
import 'package:final_project/models/product.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/screens/detail_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late String _email = '';
  late List<FavoriteProduct> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        _email = json.decode(user)['email'];
      });
    }
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoriteBox = await Hive.openBox<Favorite>('favoriteBox');
    Favorite? favorite = favoriteBox.get(_email);
    setState(() {
      favoriteProducts = favorite?.products.toList().reversed.toList() ?? [];
    });
  }

  Product convertFavoriteProduct(FavoriteProduct favoriteProduct) {
    return Product(
      id: favoriteProduct.productId,
      name: favoriteProduct.name ?? '',
      brandName: favoriteProduct.brandName ?? '',
      imageUrl: favoriteProduct.imageUrl ?? '',
      url: favoriteProduct.productUrl ?? '',
      price: Price(
        current: PriceDetails(
          value: favoriteProduct.priceValue ?? 0.0,
        ),
        currency: favoriteProduct.priceCurrency ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _loadFavorites();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            onPressed: () => context.goNamed("shopping-cart"),
          ),
        ],
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
        child: Text(
          'No favorite products available',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      )
          : ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final favoriteProduct = favoriteProducts[index];
          final product = convertFavoriteProduct(favoriteProduct);
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(product: product),
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: SizedBox(
                          height: 100,
                          width: 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              favoriteProduct.imageUrl ?? 'No Image Url',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                favoriteProduct.name ?? 'No Name' ,
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                favoriteProduct.brandName ?? 'No Brand Name',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${favoriteProduct.priceCurrency} ${favoriteProduct.priceValue}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
