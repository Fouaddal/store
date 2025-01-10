import 'CartItem.dart';

class Cart {
  static final Cart _instance = Cart._internal();
  List<CartItem> items = [];

  factory Cart() {
    return _instance;
  }

  Cart._internal();

  void addItem(CartItem item) {
    items.add(item);
  }

  void removeItem(CartItem item) {
    items.remove(item);
  }
}
