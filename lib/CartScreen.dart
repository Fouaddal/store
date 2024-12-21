import 'package:flutter/material.dart';
import 'CartItem.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function onFinish;
  final Function(CartItem) onRemoveItem;

  const CartScreen({
    required this.cartItems,
    required this.onFinish,
    required this.onRemoveItem,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(cartItems[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        onRemoveItem(cartItems[index]);
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onFinish();
              },
              child: Text('Finish Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}
