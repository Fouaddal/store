import 'package:flutter/material.dart';
import 'product.dart';
import 'CartItem.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final product productService = product();
  final Function(CartItem) addToCart;

  ProductDetailsScreen({required this.productId, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: FutureBuilder<Map>(
        future: productService.getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(product['productImage']),
                  SizedBox(height: 5),
                  Text(
                    product['productName'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ID: ${product['id']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${product['productDescription']}',
                    style: TextStyle(fontSize: 16),
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
                        );
                        addToCart(item);
                      },
                      child: Text('Add to Cart'),
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

