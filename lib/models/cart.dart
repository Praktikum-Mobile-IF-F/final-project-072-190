import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 3)
class Cart extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String email;

  @HiveField(2)
  List<CartProduct> products;

  Cart({
    required this.email,
    required this.products,
  });
}

@HiveType(typeId: 4)
class CartProduct extends HiveObject {
  @HiveField(0)
  int productId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String productSize;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  String priceCurrency;

  @HiveField(5)
  double priceValue;

  @HiveField(6)
  String productUrl;

  CartProduct({
    required this.productId,
    required this.name,
    required this.productSize,
    required this.imageUrl,
    required this.priceCurrency,
    required this.priceValue,
    required this.productUrl,
  });
}
