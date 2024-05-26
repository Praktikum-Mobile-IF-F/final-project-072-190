import 'dart:convert';
import 'package:final_project/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductDetailService {
  static const String baseUrl = 'https://asos-com1.p.rapidapi.com/products/detail';
  static const String apiKey = '66884d06f8msh130beb94e7dfaedp17374fjsn116602c63ea0';
  static const String apiHost = 'asos-com1.p.rapidapi.com';

  Future<List<Product>> fetchProductDetail(String url) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?url=$url'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );
      final body = response.body;
      final result = jsonDecode(body);

      if (result.containsKey('data') && result['data'] != null) {
        final data = result['data'];
        List<Product> products = List<Product>.from(
          data['products'].map((product) => Product.fromJson(product)),
        );
        print(products[0].imageUrl);
        return products;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}