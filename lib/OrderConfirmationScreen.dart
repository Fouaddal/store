// import 'package:flutter/material.dart';
// import 'package:store1/CartScreen.dart';
// import 'package:store1/HomeScreen.dart';
// import 'OrderHistoryScreen.dart'; // Import the Order History Screen
// import 'CartItem.dart';
// import 'notificantions.dart';
//
// class OrderConfirmationScreen extends StatelessWidget {
//   final List<CartItem> orderedItems;
//
//   const OrderConfirmationScreen({Key? key, required this.orderedItems}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Order Confirmation',
//           style: TextStyle(
//             color: Colors.white,
//             fontFamily: 'Merriweather',
//           ),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Your Order:',
//               style: TextStyle(
//                 fontFamily: 'Merriweather',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: orderedItems.length,
//                 itemBuilder: (context, index) {
//                   final item = orderedItems[index];
//                   return ListTile(
//                     leading: Image.network(item.imageUrl),
//                     title: Text(
//                       item.name,
//                       style: TextStyle(
//                         fontFamily: 'Merriweather',
//                         fontSize: 20,
//                       ),
//                     ),
//                     subtitle: Text(
//                       item.description,
//                       style: TextStyle(
//                         fontFamily: 'Merriweather',
//                         fontSize: 16,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   final order = {
//                     'date': DateTime.now().toString(),
//                     'items': orderedItems.map((item) {
//                       return {
//                         'name': item.name,
//                         'description': item.description,
//                         // 'quantity': item.quantity,
//                         // 'price': item.price,
//                         'imageUrl': item.imageUrl,  // Add image URL here
//                       };
//                     }).toList(),
//                     // 'total': orderedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
//                   };
//
//                   orderHistory.add(order);
//
//                   LocalNotifications().scheduleOrderNotifications();
//                   LocalNotifications.showSimpleNotification(
//                     title: 'Order Confirmed',
//                     body: 'Your order has been placed successfully!',
//                   );
//
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeScreen(
//                         addToCart: (CartItem item) {},
//                         user: {},
//                         phoneNumber: '',
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text('Okay'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   textStyle: TextStyle(
//                     fontFamily: 'Merriweather',
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
// }