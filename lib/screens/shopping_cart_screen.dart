// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:final_project/models/cart.dart';
//
// class ShoppingCartScreen extends StatefulWidget {
//   const ShoppingCartScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
// }
//
// class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
//   late Box<Cart> _cartBox;
//
//   @override
//   void initState() {
//     super.initState();
//     _openBox();
//   }
//
//   Future<void> _openBox() async {
//     _cartBox = await Hive.openBox<Cart>('cartBox');
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shopping Cart'),
//       ),
//       body: _cartBox == null
//           ? Center(child: CircularProgressIndicator())
//           : _buildCartItems(),
//     );
//   }
//
//   Widget _buildCartItems() {
//     final cart = _cartBox.get(_email);
//     if (cart == null || cart.products.isEmpty) {
//       return Center(child: Text('No items in the cart'));
//     } else {
//       return ListView.builder(
//         itemCount: cart.products.length,
//         itemBuilder: (context, index) {
//           final cartProduct = cart.products[index];
//           return ListTile(
//             title: Text(cartProduct.name),
//             subtitle: Text(cartProduct.productSize),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () => _removeItemFromCart(cartProduct),
//             ),
//           );
//         },
//       );
//     }
//   }
//
//   void _removeItemFromCart(CartProduct cartProduct) {
//     final cart = _cartBox.get(_email);
//     if (cart != null) {
//       setState(() {
//         cart.products.removeWhere((product) => product.productId == cartProduct.productId);
//         cart.save();
//       });
//     }
//   }
// }
