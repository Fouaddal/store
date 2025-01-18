import 'package:flutter/material.dart';
import 'CartItem.dart';
import 'Cart.dart';

class FavoritesScreen extends StatefulWidget {
  static List<CartItem> favoriteItems = [];

  static void toggleFavorite(CartItem item) {
    if (favoriteItems.any((fav) => fav.id == item.id)) {
      favoriteItems.removeWhere((fav) => fav.id == item.id);
    } else {
      favoriteItems.add(item);
    }
  }

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems = List.filled(FavoritesScreen.favoriteItems.length, false);
  }

  void _addToCart() {
    final selectedItems = FavoritesScreen.favoriteItems
        .asMap()
        .entries
        .where((entry) => _selectedItems[entry.key])
        .map((entry) => entry.value)
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one item.')),
      );
    } else {
      for (var item in selectedItems) {
        Cart().addItem(item);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${selectedItems.length} item(s) added to cart.')),
      );
    }

    setState(() {
      _selectedItems = List.filled(FavoritesScreen.favoriteItems.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 25,
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FavoritesScreen.favoriteItems.isEmpty
            ? Center(child: Text('No favorites yet.'))
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: FavoritesScreen.favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = FavoritesScreen.favoriteItems[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        FavoritesScreen.favoriteItems.removeAt(index);
                        _selectedItems.removeAt(index);
                      });

                    },
                    child: CheckboxListTile(
                      value: _selectedItems[index],
                      onChanged: (value) {
                        setState(() {
                          _selectedItems[index] = value ?? false;
                        });
                      },
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      secondary: Image.network(item.imageUrl),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addToCart,
              child: Text('Add Selected to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Merriweather',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}