class Product {
  final String id;
  final String farmerId;
  final String name;
  final String category;
  final double price;
  final double quantity;
  final String unit;
  final String description;
  final List<String> images;
  final DateTime harvestDate;
  final bool isOrganic;
  
  Product({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.images,
    required this.harvestDate,
    required this.isOrganic,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      farmerId: json['farmerId'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      description: json['description'],
      images: List<String>.from(json['images']),
      harvestDate: DateTime.parse(json['harvestDate']),
      isOrganic: json['isOrganic'],
    );
  }
}
