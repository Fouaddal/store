import 'package:flutter/material.dart';
import 'product.dart';
import 'ProductDetailsScreen.dart';
import 'CartItem.dart';
import 'CartScreen.dart';
import 'AccountScreen.dart';

String formatImageUrl(String relativeUrl) {
  return 'http://10.0.2.2:8000/$relativeUrl';
}

class HomeScreen extends StatefulWidget {
  final Function(CartItem) addToCart;
  final String phoneNumber;  // Added to accept phoneNumber

  HomeScreen({required this.addToCart, required this.phoneNumber});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  final product productService = product();
  late TabController _tabController;
  int _selectedIndex = 0;
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget _getAppBar() {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black12),
            ),
            style: TextStyle(color: Colors.black, fontSize: 18),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Stores'),
            ],
          ),
        );
      case 1:
        return AppBar(
          title: Text('Cart'),
        );
      case 2:
      default:
        return AppBar(
          title: Text('Account'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreenTab(addToCart: widget.addToCart, searchQuery: _searchQuery),
          CartScreen(
            cartItems: cartItems,
            onRemoveItem: (item) {
              setState(() {
                cartItems.remove(item);
              });
            },
            onFinish: () {
              // Implement finish purchase functionality
            },
          ),
          AccountScreen(user: {
            'phone_number': widget.phoneNumber,
            'first_name': '',
            'last_name': '',
            'email': '',
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Updated with non-null label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart', // Updated with non-null label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account', // Updated with non-null label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreenTab extends StatelessWidget {
  final Function(CartItem) addToCart;
  final String searchQuery;

  HomeScreenTab({required this.addToCart, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final product productService = product();
    return FutureBuilder<List>(
      future: productService.getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List products = snapshot.data!.where((product) {
            return product['productName']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        productId: products[i]['id'].toString(),
                        addToCart: addToCart,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                        child: Image.network(
                          formatImageUrl(products[i]['productImage']),
                          height: 150, // Increased height for better display
                          width: double.infinity,
                          fit: BoxFit.contain, // Ensures the entire image is displayed
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[i]['productName'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              products[i]['productDescription'],
                              style: TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
