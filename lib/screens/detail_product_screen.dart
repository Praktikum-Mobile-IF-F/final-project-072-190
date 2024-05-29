import 'dart:convert';

import 'package:final_project/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/product_detail.dart';
import 'package:final_project/services/product_detail_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String url;

  DetailScreen({required this.url});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String _email = '';
  late Future<ProductDetail?> _productDetailFuture;
  String? _selectedSize;
  static const Color backgroundColor1 = Color(0xffFFFFFF);
  late bool _isFavorite = false;
  late bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _productDetailFuture = ProductDetailService().fetchProductDetail(widget.url);
    _loadUserData();
    _checkIfFavorited();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        _email = json.decode(user)['email'];
      });
    }
  }

  Future<void> _checkIfFavorited() async {
    // Box<Favorite> favoriteBox = await Hive.openBox<Favorite>('favoriteBox');
    // final favorite = favoriteBox.get(_email);
    // setState(() {
    //   _isFavorite = favorite.products.any((product) => product.id == _productDetailFuture.id);
    // });
  }

  void _toggleFavorite() async {
    // Box<Favorite> favoriteBox = await Hive.openBox<Favorite>('favorites');
    // Favorite? favorite = favoriteBox.values.firstWhere(
    //       (favorite) => favorite.email == _email,
    //   orElse: () => null,
    // );
    // if (favorite != null) {
    //   if (_isFavorite) {
    //     favorite.products.removeWhere((product) => product.id == _productDetailFuture.id);
    //   } else {
    //     favorite.products.add(_productDetailFuture);
    //   }
    //   favorite.save();
    // } else {
    //   favorite = Favorite(id: UniqueKey().toString(), email: _email, products: [_productDetailFuture]);
    //   favoriteBox.add(favorite);
    // }
    // setState(() {
    //   _isFavorite = !_isFavorite;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: FutureBuilder<ProductDetail?>(
        future: _productDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final productDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 500,
                    child: PageView.builder(
                      itemCount: productDetail.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            productDetail.images[index].url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    productDetail.name,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  ExpansionTile(
                    title: Text(
                      'About Me',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productDetail.description.aboutMe,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ExpansionTile(
                    title: Text(
                      'Brand Description',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productDetail.description.brandDescription,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ExpansionTile(
                    title: Text(
                      'Product Description',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productDetail.description.productDescription,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildSizeDropdown(productDetail.variants),
                  SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedSize == null || _selectedSize == 'Select Size') {
                                _showSizeErrorDialog();
                              } else {
                                addToCart(productDetail, _selectedSize!);
                              }
                            },
                            child: Text('Add to Cart'),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(backgroundColor1),
                            ),
                            onPressed: _toggleFavorite,

                            //     () {
                            //   setState(() {
                            //     _isFavorite = !_isFavorite;
                            //     final snackBar = SnackBar(
                            //       content: Text(
                            //         _isFavorite ? 'Added to favorites' : 'Removed from favorites',
                            //       ),
                            //     );
                            //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            //   });
                            // },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Favorite',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorite ? Colors.red : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Product not found.'));
          }
        },
      ),
    );
  }

  Widget _buildSizeDropdown(List<Variant> variants) {
    if (variants.isEmpty) {
      return Center(child: Text('No sizes available'));
    }

    List<String> sizes = variants.map((variant) => variant.size).toSet().toList();
    sizes.insert(0, 'Select Size');

    String initialValue = _selectedSize ?? sizes[0];

    return DropdownButton<String>(
      value: _selectedSize ?? initialValue,
      onChanged: (String? selectedSize) {
        setState(() {
          _selectedSize = selectedSize;
        });
      },
      items: sizes.map((String size) {
        return DropdownMenuItem<String>(
          value: size,
          child: Text(size),
        );
      }).toList(),
    );
  }

  void addToCart(ProductDetail product, String selectedSize) {
    print('Product ${product.name} added to cart with size: $selectedSize');
  }

  void _showSizeErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed'),
          content: Text('Please select the size first'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
