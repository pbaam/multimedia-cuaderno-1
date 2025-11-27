import 'product.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });
}

class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime date;
  final double total;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.date,
    required this.total,
    this.status = OrderStatus.pending,
  });
}
