import 'package:final_project/models/boxes.dart';
import 'package:final_project/models/cart.dart';
import 'package:final_project/models/favorite.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteAdapter());
  Hive.registerAdapter(FavoriteProductAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(CartProductAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(OrderedProductAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Favorite>(HiveBoxes.favorite);
  await Hive.openBox<Cart>(HiveBoxes.cart);
  await Hive.openBox<Order>(HiveBoxes.order);
  await Hive.openBox<User>(HiveBoxes.user);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Praktikum TPM Final Project',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: AppNavigation.router,
      ),
    );
  }
}
