import '../models/product.dart';

class ProductRepository {
  static final List<Product> _products = [
    Product(
      id: '1',
      title: 'Portátil',
      stock: 10,
      price: 999.99,
      description: 'Portátil de alto rendimiento',
      imagePath: null,
    ),
    Product(
      id: '2',
      title: 'Ratón',
      stock: 50,
      price: 25.99,
      description: 'Ratón inalámbrico',
      imagePath: null,
    ),
    Product(
      id: '3',
      title: 'Teclado',
      stock: 30,
      price: 79.99,
      description: 'Teclado mecánico',
      imagePath: null,
    ),
  ];

  Future<List<Product>> getAllProducts() async {
    return List.unmodifiable(_products);
  }

  Future<Product?> getProductById(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
