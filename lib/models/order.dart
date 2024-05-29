import 'package:final_project/models/cart.dart';
import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 5)
class Order extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String email;

  @HiveField(2)
  List<OrderedProduct> products;

  Order({
    required this.email,
    required this.products,
  });
}

@HiveType(typeId: 6)
class OrderedProduct extends HiveObject {
  @HiveField(0)
  int orderId;

  @HiveField(1)
  String totalPrice;

  @HiveField(2)
  List<CartProduct> products;

  OrderedProduct({
    required this.orderId,
    required this.totalPrice,
    required this.products,
  });
}
