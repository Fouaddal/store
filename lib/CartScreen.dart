import 'package:flutter/material.dart';
import 'CartItem.dart';
import 'Cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'FavoritesScreen.dart';
//import 'notificantions.dart';
import 'OrderConfirmationScreen.dart';

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

    final url = Uri.parse('http://10.0.2.2:8000/api/cart'); // Replace with your API endpoint
    final cartData = {
      'cartItems': Cart().items.map((item) => item.toJson()).toList(),
    };

    print('Sending cart data: ${json.encode(cartData)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase completed successfully!')),
      );

      // Navigate to the confirmation screen with the cart items
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(orderedItems: List.from(Cart().items)),
        ),
      );

      // Clear the cart items after successful purchase
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
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
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
                      icon: Icon(Icons.remove_circle,color: Colors.red,),
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
              onPressed: (){
                _showConfirmationDialog;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderConfirmationScreen(orderedItems: Cart().items   )),
                );
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


