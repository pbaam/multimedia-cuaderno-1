import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/product_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';

class PantallaAdminInventario extends StatelessWidget {
  const PantallaAdminInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.adminInventory,
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
        child: Consumer<ProductService>(
          builder: (context, productService, child) {
            if (productService.products.isEmpty) {
              productService.loadProducts();
              return CircularProgressIndicator();
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: productService.products.length,
              itemBuilder: (context, index) {
                final product = productService.products[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imagePath != null
                          ? Image.network(
                              product.imagePath!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderImage(),
                            )
                          : _buildPlaceholderImage(),
                    ),
                    title: Text(product.title),
                    subtitle: Text('${l10n.stock}: ${product.stock} unidades'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: product.stock > 0
                              ? () {
                                  productService.updateStock(
                                      product.id, product.stock - 1);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Stock reduced for ${product.title}',
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: product.stock > 10
                                ? Colors.green
                                : product.stock > 0
                                    ? Colors.orange
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${product.stock}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () {
                            productService.updateStock(
                                product.id, product.stock + 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Stock increased for ${product.title}',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: Icon(
        Icons.image,
        size: 30,
        color: Colors.grey[400],
      ),
    );
  }
}
