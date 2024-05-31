import 'dart:convert';
import 'package:final_project/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'https://asos-com1.p.rapidapi.com/products/search';
  final String apiKey = dotenv.env['RAPID_API_KEY'] ?? '';
  static const String apiHost = 'asos-com1.p.rapidapi.com';

  Future<List<Product>> fetchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?q=$query'),
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
        return products;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}