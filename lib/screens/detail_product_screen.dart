import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [product.imageUrl, ...(product.additionalImageUrls ?? [])];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                Uri imageUrl = Uri.parse(imageUrls[index]);
                return Image.network(
                  imageUrl.toString(),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  product.brandName ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  product.price != null
                      ? '${product.price!.currency} ${product.price!.current!.value}'
                      : 'Price not available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Description', // Add product description as needed
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Product description can be added here.', // Add product description as needed
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
