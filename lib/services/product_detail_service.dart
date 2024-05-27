import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:final_project/models/product_detail.dart';

class ProductDetailService {
  static const String baseUrl = 'https://asos-com1.p.rapidapi.com/products/detail';
  final String apiKey = dotenv.env['RAPID_API_KEY'] ?? '';
  static const String apiHost = 'asos-com1.p.rapidapi.com';

  Future<ProductDetail?> fetchProductDetail(String url) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?url=$url'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': apiHost,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result.containsKey('data') && result['data'] != null) {
          final data = result['data'];
          return ProductDetail.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
