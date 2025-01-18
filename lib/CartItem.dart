class CartItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price; // Add this line
  final int quantity; // Add this line

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price, // Add this line
    required this.quantity, // Add this line
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price, // Add this line
      'quantity': quantity, // Add this line
    };
  }
}
