import 'product.dart';

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
  final DateTime date;
  final List<OrderItem> items;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });
}
