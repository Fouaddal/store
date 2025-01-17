import 'package:flutter/material.dart';
import 'package:store1/CartScreen.dart';
import 'package:store1/HomeScreen.dart';
import 'CartItem.dart'; // Import the CartItem model

class OrderConfirmationScreen extends StatelessWidget {
  final List<CartItem> orderedItems;

  const OrderConfirmationScreen({Key? key, required this.orderedItems}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation',
        style: TextStyle(
          color: Colors.white,
        fontFamily: 'Merriweather',
        ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Order:',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orderedItems.length,
                itemBuilder: (context, index) {
                  final item = orderedItems[index];
                  return ListTile(
                    leading: Image.network(item.imageUrl),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      item.description,
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Center(child:
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(addToCart: (CartItem ) {  }, user: {}, phoneNumber: '', )),
                  );
                },
                child: Text('Okay'),
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily:'Merriweather',
                  fontSize: 18
                ),

              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
