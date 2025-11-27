import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_service.dart';
import '../../controllers/order_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/language_button.dart';
import '../../services/audio_service.dart';

class PantallaHome extends StatefulWidget {
  const PantallaHome({super.key});

  @override
  State<PantallaHome> createState() => _PantallaHomeState();
}

class _PantallaHomeState extends State<PantallaHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductService>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        if (productService.products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: productService.products.length,
                itemBuilder: (context, index) {
                  final product = productService.products[index];
                  final quantity = productService.getCartQuantity(product.id);
                  
                  return ProductCard(
                    product: product,
                    quantity: quantity,
                    onIncrease: () => productService.addToCart(product.id),
                    onDecrease: () => productService.removeFromCart(product.id),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: productService.cart.isEmpty ? null : () => _realizarCompra(context),
                icon: Icon(Icons.shopping_cart),
                label: Text('Realizar compra (€${productService.cartTotal.toStringAsFixed(2)})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _realizarCompra(BuildContext context) async {
    final productService = Provider.of<ProductService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);

    final success = await orderService.createOrder(
      productService.cart,
      productService.products,
    );

    if (!mounted) return;

    if (success) {
      productService.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compra realizada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la compra')),
      );
    }
  }
}
