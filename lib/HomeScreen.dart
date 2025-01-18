import 'package:flutter/material.dart';
import 'FavoritesScreen.dart';
import 'OrderHistoryScreen.dart';
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
  final Map<String, dynamic> user; // User data passed from SignInScreen/SignUpScreen
  final String phoneNumber; // Keep phoneNumber for SignIn and SignUp

  HomeScreen({
    required this.addToCart,
    required this.user,
    required this.phoneNumber,
  });

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
          actions: [
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                );
              },
            ),
          ],
          backgroundColor: Colors.blue,
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather',
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 20),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child:Text(
                  'Products',
                  style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Stores',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Merriweather',
                      color: Colors.white),
                ),
              ),
            ],
          ),
        );
      case 1:
        return AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Cart',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Merriweather',
            ),
          ),
          actions: [
            IconButton(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> OrderHistoryScreen(),
                  ),
                );
              },
              icon: Icon(Icons.history,color: Colors.white,),
          ),
          ],
        );
      case 2:
      default:
        return AppBar(
          backgroundColor: Colors.blue,
          title:
          Text(
            'Account',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Merriweather',
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreenTab(
            addToCart: widget.addToCart,
            searchQuery: _searchQuery,
          ),
          CartScreen(),
          AccountScreen(
            user: widget.user,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreenTab extends StatelessWidget {
  final Function(CartItem) addToCart;
  final String searchQuery;

  HomeScreenTab({
    required this.addToCart,
    required this.searchQuery,
  });

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
              childAspectRatio: 2 / 3, // Adjust this value to make the card bigger
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
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                        child: Image.network(
                          formatImageUrl(products[i]['productImage']),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.contain,
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
                            SizedBox(height: 5), // Add some spacing
                            Text(
                              '\$${products[i]['productPrice'].toString()}', // Display product price
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5), // Add some spacing
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
