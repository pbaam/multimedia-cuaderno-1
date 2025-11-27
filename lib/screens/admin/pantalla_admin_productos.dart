import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../../controllers/product_service.dart';
import '../../models/product.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';

class PantallaAdminProductos extends StatelessWidget {
  const PantallaAdminProductos({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.adminProducts,
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
              return Center(child: CircularProgressIndicator());
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.description),
                        SizedBox(height: 4),
                        Text(
                          '€${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text('${l10n.stock}: ${product.stock}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditProductDialog(context, product, l10n);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, product, l10n);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context, l10n);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
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

  void _showEditProductDialog(
      BuildContext context, Product product, AppLocalizations l10n) {
    final nameController = TextEditingController(text: product.title);
    final descriptionController = TextEditingController(text: product.description);
    final priceController = TextEditingController(text: product.price.toString());
    String? tempImagePath = product.imagePath;
    final formKey = GlobalKey<FormState>();
    final ImagePicker picker = ImagePicker();

    Future<void> pickFromGallery(StateSetter setState) async {
      final x = await picker.pickImage(source: ImageSource.gallery);
      if (x != null) {
        tempImagePath = x.path;
        setState(() {});
      }
    }

    Future<void> pickFromCamera(StateSetter setState) async {
      final x = await picker.pickImage(source: ImageSource.camera);
      if (x != null) {
        tempImagePath = x.path;
        setState(() {});
      }
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setState) {
          return AlertDialog(
            title: Text(l10n.editProduct),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image section
                    if (tempImagePath == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => pickFromGallery(setState),
                            icon: Icon(Icons.upload),
                            label: Text(l10n.uploadImage),
                          ),
                          SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => pickFromCamera(setState),
                            icon: Icon(Icons.camera_alt),
                            label: Text(l10n.capture),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onTap: () => pickFromGallery(setState),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 150,
                                    maxHeight: 150,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: kIsWeb
                                        ? Image.network(
                                            tempImagePath!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(tempImagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.all(4),
                                  ),
                                  onPressed: () {
                                    tempImagePath = null;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            l10n.tapToChange,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? l10n.mustEnterName : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) => (v == null || v.isEmpty) ? l10n.mustEnterDescription : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: l10n.price,
                        prefixText: '€ ',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.mustEnterPrice;
                        final p = double.tryParse(v);
                        if (p == null || p <= 0) return l10n.invalidPrice;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final newTitle = nameController.text;
                  final newDesc = descriptionController.text;
                  final newPrice = double.parse(priceController.text);
                  Provider.of<ProductService>(context, listen: false)
                      .updateProduct(product.id, newTitle, newDesc, newPrice, imagePath: tempImagePath);
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.productUpdated}: $newTitle')),
                  );
                },
                child: Text(l10n.saveChanges),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Product product, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProduct),
        content: Text('${l10n.areYouSureDeleteProduct} ${product.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.productDeleted}: ${product.title}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addNewProduct),
        content: Text(l10n.addNewProduct),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.newProductAdded)),
              );
            },
            child: Text(l10n.addProduct),
          ),
        ],
      ),
    );
  }
}
