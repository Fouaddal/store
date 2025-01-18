class CartItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isFavorite;


  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}