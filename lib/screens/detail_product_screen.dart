import 'package:flutter/material.dart';
import 'package:final_project/models/product_detail.dart';
import 'package:final_project/services/product_detail_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailScreen extends StatefulWidget {
  final String url;

  DetailScreen({required this.url});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<ProductDetail?> _productDetailFuture;

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
                  Text(
                    productDetail.brandName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    productDetail.description.aboutMe,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Images',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 400, // Sesuaikan tinggi PageView sesuai kebutuhan
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
                    'Variants',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: productDetail.variants.map((variant) {
                      return ListTile(
                        title: Text(variant.sku),
                        subtitle: Text(variant.size),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  if (productDetail.prices.isNotEmpty) // Periksa jika prices tidak kosong
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prices',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productDetail.prices.map((price) {
                            return ListTile(
                              title: Text('${price.currency} ${price.productPrice.value}'),
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
}
