import 'package:flutter/material.dart';
import 'CartScreen.dart';
import 'product.dart';
import 'CartItem.dart';
import 'Cart.dart'; // Import Cart singleton

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final product productService = product();

  ProductDetailsScreen({required this.productId, required Function(CartItem p1) addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: productService.getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(product['productImage']),
                  SizedBox(height: 5),
                  Text(
                    product['productName'],
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: ${product['id']}',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${product['productDescription']}',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Price: \$${(product['productPrice'] ?? 0).toDouble()}', // Convert to double
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Quantity: 1', // Set quantity to 1
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        CartItem item = CartItem(
                          id: product['id'].toString(),
                          name: product['productName'],
                          description: product['productDescription'],
                          imageUrl: product['productImage'],
                          price: (product['productPrice'] ?? 0).toDouble(), // Convert to double
                          quantity: 1, // Set quantity to 1
                        );
                        Cart().addItem(item);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to Cart!'),
                          ),
                        );
                      },
                      child: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontFamily: 'Merriweather',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

String formatImageUrl(String relativeUrl) {
  return 'http://10.0.2.2:8000/$relativeUrl';
}
