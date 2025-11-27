import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/order_service.dart';
import '../../services/audio_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class PantallaPedidos extends StatefulWidget {
  const PantallaPedidos({super.key});

  @override
  State<PantallaPedidos> createState() => _PantallaPedidosState();
}

class _PantallaPedidosState extends State<PantallaPedidos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderService>(context, listen: false).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: CommonAppBar(title: l10n.myOrders),
      drawer: AppDrawer(),
      body: Consumer<OrderService>(
        builder: (context, orderService, child) {
          if (orderService.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
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
                  title: Text('${l10n.order} #${order.id}'),
                  subtitle: Text(
                    '${l10n.date}: ${order.date.day}/${order.date.month}/${order.date.year}',
                  ),
                  trailing: Text(
                    '€${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  children: order.items.map((item) {
                    return ListTile(
                      title: Text(item.product.title),
                      subtitle: Text('${l10n.quantity}: ${item.quantity}'),
                      trailing: Text(
                        '€${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1),
    );
  }
}
