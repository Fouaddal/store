import 'package:flutter/material.dart';
import 'CartItem.dart';
import 'Cart.dart'; // Import Cart singleton
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'FavoritesScreen.dart';
import 'HomeScreen.dart';
import 'notificantions.dart';

// Simulating a global list to hold the order history
List<Map<String, dynamic>> orderHistory = [];

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _finishPurchase() async {
    if (Cart().items.isEmpty) {
      print('Cart is empty');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/cart');
    final cartData = {
      'cartItems': Cart().items.map((item) => item.toJson()).toList(),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Create order data for history
      final order = {
        'date': DateTime.now().toString(),
        'items': Cart().items.map((item) {
          return {
            'name': item.name,
            'description': item.description,
            'imageUrl': item.imageUrl,  // Add image URL here
          };
        }).toList(),
        // 'total': Cart().items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)), // Add total if needed
      };

      setState(() {
        orderHistory.add(order);  // Add the order to global order history
      });

      // Show notifications
      LocalNotifications().scheduleOrderNotifications();
      LocalNotifications.showSimpleNotification(
        title: 'Order Confirmed',
        body: 'Your order has been placed successfully!',
      );

      // Clear cart items after purchase
      setState(() {
        Cart().items.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete purchase.')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to finish the purchase?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sure'),
              onPressed: () {
                Navigator.of(context).pop();
                _finishPurchase();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Cart().items.isEmpty
                  ? Center(
                child: Text(
                  'No items in your cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: Cart().items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(Cart().items[index].imageUrl),
                    title: Text(
                      Cart().items[index].name,
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      Cart().items[index].description,
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          Cart().removeItem(Cart().items[index]);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              child: Text('Finish Purchase'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
