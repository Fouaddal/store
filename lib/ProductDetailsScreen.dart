import 'package:flutter/material.dart';
import 'package:store1/notificantions.dart';
import 'CartScreen.dart';
import 'FavoritesScreen.dart';
import 'product.dart';
import 'CartItem.dart';
import 'Cart.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final product productService = product();

  ProductDetailsScreen({
    required this.productId,
    required Function(CartItem p1) addToCart,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the product is in the favorites list
    widget.productService.getProductById(widget.productId).then((product) {
      setState(() {
        _isFavorite = FavoritesScreen.favoriteItems
            .any((item) => item.id == product['id'].toString());
      });
    });
  }

  void _toggleFavorite(Map product) {
    setState(() {
      CartItem item = CartItem(
        id: product['id'].toString(),
        name: product['productName'],
        description: product['productDescription'],
        imageUrl: product['productImage'],
        isFavorite: !_isFavorite,
      );

      if (_isFavorite) {
        FavoritesScreen.favoriteItems.removeWhere((fav) => fav.id == item.id);
      } else {
        FavoritesScreen.favoriteItems.add(item);
      }

      _isFavorite = !_isFavorite;
    });
  }

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
              // color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              ).then((_) {
                // Recheck favorite status when returning
                widget.productService.getProductById(widget.productId).then((product) {
                  setState(() {
                    _isFavorite = FavoritesScreen.favoriteItems
                        .any((item) => item.id == product['id'].toString());
                  });
                });
              });
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map>(
        future: widget.productService.getProductById(widget.productId),
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
                      color: Colors.black,
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
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          _toggleFavorite(product);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              LocalNotifications.showSimpleNotification(
                                title: 'Done!',
                                body: 'This product has been added to your cart',
                              );
                              CartItem item = CartItem(
                                id: product['id'].toString(),
                                name: product['productName'],
                                description: product['productDescription'],
                                imageUrl: product['productImage'],
                                isFavorite: _isFavorite,
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
                      ),
                    ],
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
