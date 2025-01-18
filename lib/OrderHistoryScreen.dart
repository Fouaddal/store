import 'package:flutter/material.dart';

// Simulating a global list to hold the order history
List<Map<String, dynamic>> orderHistory = [];

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Merriweather',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: orderHistory.isEmpty
          ? Center(
        child: Text(
          'No orders yet.',
          style: TextStyle(fontSize: 18, fontFamily: 'Merriweather'),
        ),
      )
          : ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Order #${index + 1}'),
              subtitle: Text('Date: ${order['date']}'),
              trailing: Text('Total: \$${order['total']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order['items'] ?? []; // Fallback to an empty list if items are null
    final total = order['total'] ?? 0.0;
    final date = order['date'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details',
          style: TextStyle(
          color: Colors.white,
          fontFamily: 'Merriweather',
        ),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date: $date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily:'Merriweather' ),
            ),
            SizedBox(height: 10),

            Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily:'Merriweather'),
            ),
            Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: item['imageUrl'] != null
                        ? Image.network(item['imageUrl'])
                        : Icon(Icons.broken_image),
                    title: Text(item['name'] ?? 'Unnamed Item'),
                    subtitle: Text(item['description'] ?? 'No description'),
                    trailing: Text('Qty: ${item['quantity'] ?? 0}'),
                  );
                },
              )
                  : Center(
                child: Text('No items in this order.'),
              ),
            ),

            // Display total amount
            SizedBox(height: 10),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
