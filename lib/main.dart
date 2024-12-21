
import 'package:connect/SignInScreen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),  // Set the LoginScreen as the initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  final Function(CartItem) addToCart;
  const MyHomePage({required this.addToCart, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<CartItem> cartItems = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addToCart(CartItem item) {
    setState(() {
      cartItems.add(item);
    });
  }

  void removeFromCart(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  Future<void> finishPurchase() async {
    // Implement finish purchase functionality here
  }

  static List<Widget> _widgetOptions(BuildContext context, List<CartItem> cartItems, Function(CartItem) addToCart, Function(CartItem) removeFromCart, Function onFinish) {
    return <Widget>[
      HomeScreen(addToCart: addToCart),
      CartScreen(cartItems: cartItems, onFinish: onFinish, onRemoveItem: removeFromCart),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions(context, cartItems, addToCart, removeFromCart, finishPurchase).elementAt(_selectedIndex),
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
*/