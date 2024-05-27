import 'package:flutter/material.dart';
import 'package:final_project/models/product_detail.dart';
import 'package:final_project/services/product_detail_service.dart';

class DetailScreen extends StatefulWidget {
  final String url;

  DetailScreen({required this.url});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<ProductDetail?> _productDetailFuture;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _productDetailFuture =
        ProductDetailService().fetchProductDetail(widget.url);
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
                    height: 500, // Sesuaikan tinggi PageView sesuai kebutuhan
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
                  SizedBox(height: 16),
                  Text(
                    'Select Size:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildSizeDropdown(productDetail.variants),
                  SizedBox(height: 16),
                  if (productDetail.prices
                      .isNotEmpty) // Periksa jika prices tidak kosong
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prices',
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productDetail.prices.map((price) {
                            return ListTile(
                              title: Text(
                                  '${price.currency} ${price.productPrice
                                      .value}'),
                              subtitle: Text(price.productPrice.text),
                            );
                          }).toList(),
                        ),
                      ],
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

    // Extract unique sizes from variants
    List<String> sizes = variants.map((variant) => variant.size)
        .toSet()
        .toList();

    String initialValue = sizes.isNotEmpty ? sizes[0] : '';

    return DropdownButton<String>(
      value: _selectedSize ?? initialValue,
      onChanged: (String? selectedSize) {
        setState(() {
          _selectedSize = selectedSize;
          // You can implement your logic here when a size is selected
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
}

