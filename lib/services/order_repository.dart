import '../models/order.dart';

class OrderRepository {
  static final List<Order> _orders = [];

  Future<bool> createOrder(Order order) async {
    _orders.add(order);
    return true;
  }

  Future<List<Order>> getAllOrders() async {
    return List.unmodifiable(_orders);
  }

  Future<Order?> getOrderById(String id) async {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}
