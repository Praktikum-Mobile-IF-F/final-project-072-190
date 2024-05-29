// import 'package:flutter/material.dart';
// import 'package:final_project/models/order.dart'; // Pastikan path model Order sesuai dengan struktur proyek Anda
//
// class OrderScreen extends StatelessWidget {
//
//   const OrderScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order ID: ${order.orderId}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Price: ${order.totalPrice}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Ordered Products:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: order.products.length,
//                 itemBuilder: (context, index) {
//                   final cartProduct = order.products[index];
//                   return ListTile(
//                     leading: Image.network(
//                       cartProduct.imageUrl ?? 'No Image Url',
//                       fit: BoxFit.contain,
//                       width: 60,
//                       height: 60,
//                     ),
//                     title: Text(
//                       cartProduct.name ?? 'No Name',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('${cartProduct.productSize ?? 'No Size'}'),
//                         Text(
//                           '${cartProduct.priceCurrency} ${cartProduct.priceValue}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
