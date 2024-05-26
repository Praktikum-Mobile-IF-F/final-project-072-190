import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final envPath = ".env";
    if (File(envPath).existsSync()) {
      await dotenv.load(fileName: envPath);
      print('Env file loaded successfully');
      print('API_KEY: ${dotenv.env['API_KEY']}');
    } else {
      print('.env file does not exist at path: $envPath');
    }
  } catch (e) {
    print('Error loading .env file: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dotenv Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dotenv Example'),
        ),
        body: Center(
          child: Text('API_KEY: ${dotenv.env['API_KEY']}'),
        ),
      ),
    );
  }
}
