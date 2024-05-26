import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final String apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  void signup(String email, String password) async {
    Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey");

    var response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    print(json.decode(response.body));
  }

  void signin(String email, String password) async {
    Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey");

    var response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    print(json.decode(response.body));
  }
}