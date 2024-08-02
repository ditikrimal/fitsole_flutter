class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String brand;
  final DateTime createdAt; // Add this if you need the timestamp
  final int quantity_sold; // Add this if you need the quantity sold

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.brand,
    required this.createdAt,
    required this.quantity_sold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      imageUrl: json['imageUrl'],
      category: json['category'],
      brand: json['brand'],
      createdAt: DateTime.parse(json['created_at']), // Parse date if included
      quantity_sold:
          json['quantity_sold'], // Add this if you need the quantity sold
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, category: $category, brand: $brand, createdAt: $createdAt, quantity_sold: $quantity_sold)';
  }
}
