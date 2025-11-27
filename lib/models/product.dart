class Product {
  String id;
  String title;
  int stock;
  double price;
  String description;
  String? imagePath;

  Product({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.description,
    this.imagePath,
  });
}
