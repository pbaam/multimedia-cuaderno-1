import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/order_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common_app_bar_actions.dart';

class PantallaAdminPedidos extends StatelessWidget {
  const PantallaAdminPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminOrders),
        actions: [
          CommonAppBarActions(),
        ],
      ),
      body: Consumer<OrderService>(
        builder: (context, orderService, child) {
          if (orderService.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    l10n.noOrders,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: orderService.orders.length,
            itemBuilder: (context, index) {
              final order = orderService.orders[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(index),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('${l10n.order} #${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.date}: ${order.date.day}/${order.date.month}/${order.date.year}',
                      ),
                      Text(
                        'Status: ${_getStatusText(index)}',
                        style: TextStyle(
                          color: _getStatusColor(index),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '€${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  children: [
                    ...order.items.map((item) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.product.imagePath != null
                              ? Image.network(
                                  item.product.imagePath!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildPlaceholderImage(),
                                )
                              : _buildPlaceholderImage(),
                        ),
                        title: Text(item.product.title),
                        subtitle: Text('${l10n.quantity}: ${item.quantity}'),
                        trailing: Text(
                          '€${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              _showOrderDetailsDialog(context, order, l10n);
                            },
                            icon: Icon(Icons.info),
                            label: Text('Details'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Order #${order.id} status updated'),
                                ),
                              );
                            },
                            icon: Icon(Icons.check),
                            label: Text('Update Status'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey[200],
      child: Icon(
        Icons.image,
        size: 25,
        color: Colors.grey[400],
      ),
    );
  }

  Color _getStatusColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  String _getStatusText(int index) {
    switch (index % 3) {
      case 0:
        return 'Pending';
      case 1:
        return 'Processing';
      default:
        return 'Delivered';
    }
  }

  void _showOrderDetailsDialog(
      BuildContext context, dynamic order, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l10n.order} #${order.id} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.date}: ${order.date.day}/${order.date.month}/${order.date.year}'),
            SizedBox(height: 8),
            Text('Total: €${order.total.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Items: ${order.items.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
