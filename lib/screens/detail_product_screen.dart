import 'package:final_project/models/cart.dart';
import 'package:final_project/models/product.dart';
import 'dart:convert';
import 'package:final_project/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/models/product_detail.dart';
import 'package:final_project/services/product_detail_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  DetailScreen({required this.product});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String _email = '';
  late Future<ProductDetail?> _productDetailFuture;
  String? _selectedSize;
  static const Color backgroundColor1 = Color(0xffFFFFFF);
  late bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _productDetailFuture =
        ProductDetailService().fetchProductDetail(widget.product.url!);
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
    Box<Favorite> favoriteBox = await Hive.openBox<Favorite>('favoriteBox');
    final favorite = favoriteBox.get(_email);
    setState(() {
      isFavorited = favorite?.products.any((product) => product.productId ==
          widget.product.id) ?? false;
    });
  }

  void _toggleFavorite() async {
    final favoriteBox = await Hive.openBox<Favorite>('favoriteBox');
    setState(() {
      isFavorited = !isFavorited;
    });

    Favorite? favorite = favoriteBox.get(_email);
    if (isFavorited) {
      if (favorite == null) {
        favorite =
            Favorite(email: _email, products: [convertProduct(widget.product)]);
        favoriteBox.put(_email, favorite);
      } else {
        favorite.products.add(convertProduct(widget.product));
        favorite.save();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorites'),
        ),
      );
    } else {
      if (favorite != null) {
        favorite.products.removeWhere((product) =>
        product.productId == widget.product.id);
        favorite.save();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
        ),
      );
    }
  }

  FavoriteProduct convertProduct(Product product) {
    return FavoriteProduct(
      productId: product.id!,
      name: product.name ?? '',
      brandName: product.brandName ?? '',
      imageUrl: product.imageUrl ?? '',
      priceCurrency: product.price?.currency ?? '',
      priceValue: product.price?.current?.value ?? 0.0,
      productUrl: product.url ?? '',
    );
  }

  void addToCart(Product product, String selectedSize) async {
    final cartBox = await Hive.openBox<Cart>('cartBox');

    Cart? cart = cartBox.get(_email);
    if (cart == null) {
      cart = Cart(email: _email, products: []);
      cartBox.put(_email, cart);
    }

    cart.products.add(CartProduct(
      productId: product.id!,
      name: product.name,
      productSize: selectedSize,
      imageUrl: product.imageUrl,
      priceCurrency: product.price?.currency ?? '',
      priceValue: product.price?.current?.value ?? 0.0,
      productUrl: product.url ?? '',
    ));
    cart.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully added to cart with size: $selectedSize'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            onPressed: () => context.goNamed("shopping-cart"),
          ),
        ],
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedSize == null ||
                                _selectedSize == 'Select Size') {
                              _showSizeErrorDialog();
                            } else {
                              addToCart(widget.product, _selectedSize!);
                            }
                          },
                          child: Text('Add to Cart'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                backgroundColor1),
                          ),
                          onPressed: _toggleFavorite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Favorite',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                isFavorited ? Icons.favorite : Icons
                                    .favorite_border,
                                color: isFavorited ? Colors.red : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    productDetail.name,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.product.price != null
                        ? '${widget.product.price!.currency} ${widget.product
                        .price!.current!.value}'
                        : 'Price not available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSizeDropdown(productDetail.variants),
                  ExpansionTile(
                    title: Text(
                      'About Me',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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

    List<String> sizes = variants.map((variant) => variant.size)
        .toSet()
        .toList();
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
