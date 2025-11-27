import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/order_repository.dart';

class OrderService extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();
  List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders() async {
    _orders = await _repository.getAllOrders();
    notifyListeners();
  }

  Future<bool> createOrder(Map<String, int> cart, List<Product> allProducts) async {
    if (cart.isEmpty) return false;

    final items = <OrderItem>[];
    double total = 0;

    cart.forEach((productId, quantity) {
      final product = allProducts.firstWhere((p) => p.id == productId);
      items.add(OrderItem(product: product, quantity: quantity));
      total += product.price * quantity;
    });

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: items,
      total: total,
    );

    final success = await _repository.createOrder(order);
    if (success) {
      await loadOrders();
      notifyListeners();
    }
    return success;
  }

  Future<Order?> getOrderById(String id) async {
    return await _repository.getOrderById(id);
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    try {
      final order = _orders.firstWhere((o) => o.id == orderId);
      order.status = newStatus;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }
}
