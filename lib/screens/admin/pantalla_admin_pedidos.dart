import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/order_service.dart';
import '../../models/order.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';

class PantallaAdminPedidos extends StatelessWidget {
  const PantallaAdminPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.adminOrders,
        showBackButton: true,
        onBackPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/admin');
          }
        },
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Consumer<OrderService>(
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
                final l10nBuilder = AppLocalizations.of(context)!;
                
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(order.status),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('${l10nBuilder.order} #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10nBuilder.date}: ${order.date.day}/${order.date.month}/${order.date.year}',
                        ),
                        Text(
                          '${l10nBuilder.status}: ${_getStatusText(order.status, l10nBuilder)}',
                          style: TextStyle(
                            color: _getStatusColor(order.status),
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
                          subtitle: Text('${l10nBuilder.quantity}: ${item.quantity}'),
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
                                _showOrderDetailsDialog(context, order, l10nBuilder);
                              },
                              icon: Icon(Icons.info),
                              label: Text(l10nBuilder.details),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showUpdateStatusDialog(context, order, l10nBuilder);
                              },
                              icon: Icon(Icons.update),
                              label: Text(l10nBuilder.updateStatus),
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

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status, AppLocalizations l10n) {
    switch (status) {
      case OrderStatus.pending:
        return l10n.pending;
      case OrderStatus.processing:
        return l10n.processing;
      case OrderStatus.shipped:
        return l10n.shipped;
      case OrderStatus.delivered:
        return l10n.delivered;
      case OrderStatus.cancelled:
        return l10n.cancelled;
    }
  }

  void _showOrderDetailsDialog(
      BuildContext context, Order order, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l10n.orderDetails} #${order.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.date}: ${order.date.day}/${order.date.month}/${order.date.year}'),
            SizedBox(height: 8),
            Text('${l10n.total}: €${order.total.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('${l10n.items}: ${order.items.length}'),
            SizedBox(height: 8),
            Text('${l10n.status}: ${_getStatusText(order.status, l10n)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(
      BuildContext context, Order order, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.updateStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.currentStatus}: ${_getStatusText(order.status, l10n)}'),
            SizedBox(height: 16),
            Text('${l10n.selectNewStatus}:'),
            SizedBox(height: 16),
            ...OrderStatus.values.map((status) {
              return ListTile(
                leading: Icon(
                  Icons.circle,
                  color: _getStatusColor(status),
                ),
                title: Text(_getStatusText(status, l10n)),
                trailing: order.status == status
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  final orderService = Provider.of<OrderService>(context, listen: false);
                  orderService.updateOrderStatus(order.id, status);
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.order} #${order.id} ${l10n.orderStatusUpdated} ${_getStatusText(status, l10n)}'),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
