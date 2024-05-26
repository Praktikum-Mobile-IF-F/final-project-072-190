import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final String apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  Future<void> signup(String email, String password) async {
    Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey");

    try {
      var response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        String errorMessage = responseData['error']['message'];
        if (errorMessage == 'EMAIL_EXISTS') {
          errorMessage = 'Email already exists.';
        }
        throw errorMessage;
      }
    } catch (error) {
      throw 'Failed to sign up. $error';
    }
  }

  Future<void> signin(String email, String password) async {
    Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey");

    try {
      var response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        String errorMessage = responseData['error']['message'];
        switch (errorMessage) {
          case 'INVALID_LOGIN_CREDENTIALS':
            errorMessage = 'Wrong username or password.';
            break;
          case 'EMAIL_NOT_FOUND':
            errorMessage = 'No user found with this email. The user may have been deleted.';
            break;
          case 'INVALID_EMAIL':
            errorMessage = 'Invalid email.';
            break;
          case 'INVALID_PASSWORD':
            errorMessage = 'Invalid password or the user does not have a password.';
            break;
          case 'USER_DISABLED':
            errorMessage = 'The user account has been disabled by an administrator.';
            break;
        }
        throw errorMessage;
      }
    } catch (error) {
      throw 'Failed to sign in. $error';
    }
  }

}