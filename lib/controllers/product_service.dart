import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_repository.dart';

class ProductService extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<Product> _products = [];
  Map<String, int> _cart = {};

  List<Product> get products => List.unmodifiable(_products);
  Map<String, int> get cart => Map.unmodifiable(_cart);
  
  int get cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);
  
  double get cartTotal {
    double total = 0;
    _cart.forEach((productId, quantity) {
      final product = _products.firstWhere((p) => p.id == productId);
      total += product.price * quantity;
    });
    return total;
  }

  Future<void> loadProducts() async {
    _products = await _repository.getAllProducts();
    notifyListeners();
  }

  void addToCart(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    final currentQty = _cart[productId] ?? 0;
    
    if (currentQty < product.stock) {
      _cart[productId] = currentQty + 1;
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    if (_cart.containsKey(productId)) {
      _cart[productId] = _cart[productId]! - 1;
      if (_cart[productId]! <= 0) {
        _cart.remove(productId);
      }
      notifyListeners();
    }
  }

  int getCartQuantity(String productId) {
    return _cart[productId] ?? 0;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateProduct(String productId, String title, String description, double price, {String? imagePath}) {
    final i = _products.indexWhere((p) => p.id == productId);
    if (i != -1) {
      _products[i].title = title;
      _products[i].description = description;
      _products[i].price = price;
      _products[i].imagePath = imagePath;
      notifyListeners();
    }
  }

  void updateStock(String productId, int newStock) {
    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _products[productIndex].stock = newStock;
      notifyListeners();
    }
  }
}
