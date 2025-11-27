import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/user_repository.dart';
import '../../models/user.dart';
import '../../widgets/common_app_bar_actions.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../../widgets/location_dropdown.dart';

class PantallaAdminUsuarios extends StatelessWidget {
  const PantallaAdminUsuarios({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = UserRepository();
    final users = userRepo.getAllUsers();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        title: Text(l10n.adminUsers),
        actions: [
          CommonAppBarActions(),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final isRootAdmin = user.name.toLowerCase() == 'admin';
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.role == UserRole.administrator
                    ? Colors.red
                    : Colors.lightBlueAccent,
                backgroundImage: user.imagePath != null
                    ? (kIsWeb
                        ? NetworkImage(user.imagePath!)
                        : FileImage(File(user.imagePath!)) as ImageProvider)
                    : null,
                child: user.imagePath == null
                    ? Icon(
                        user.role == UserRole.administrator
                            ? Icons.admin_panel_settings
                            : Icons.person,
                        color: Colors.white,
                      )
                    : null,
              ),
              title: Text(user.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email),
                  Text(
                    user.role == UserRole.administrator ? l10n.admin : l10n.user,
                    style: TextStyle(
                      color: user.role == UserRole.administrator
                          ? Colors.red
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isRootAdmin)
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showUserFormDialog(
                          context: context,
                          l10n: l10n,
                          original: user,
                          onSave: (updated) {
                            // Persist changes as needed (repository update if available)
                            user.name = updated.name;
                            user.email = updated.email;
                            user.age = updated.age;
                            user.birthPlace = updated.birthPlace;
                            user.treatment = updated.treatment;
                            user.imagePath = updated.imagePath;
                            user.password = updated.password;
                            user.role = updated.role;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${l10n.user} ${user.name} updated')),
                            );
                          },
                        );
                      },
                    ),
                  if (!isRootAdmin)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmation(context, user, l10n);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserFormDialog(
            context: context,
            l10n: l10n,
            onSave: (created) {
              // Persist creation if repository supports it; here we just notify user.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New ${l10n.user} ${created.name} added')),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, User user, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${l10n.user}'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.user} ${user.name} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Unified form for editing/creating a user by admin.
  void _showUserFormDialog({
    required BuildContext context,
    required AppLocalizations l10n,
    User? original,
    required void Function(User result) onSave,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: original?.name ?? '');
    final emailController = TextEditingController(text: original?.email ?? '');
    final ageController =
        TextEditingController(text: original != null ? original!.age.toString() : '');
    final passwordController = TextEditingController(text: original?.password ?? '');
    String treatment = original?.treatment ?? 'Sr';
    String birthPlace = original?.birthPlace ?? '';
    String? imagePath = original?.imagePath;
    UserRole role = original?.role ?? UserRole.ordinary;

    final picker = ImagePicker();

    Future<void> pickFromGallery(StateSetter setState) async {
      final x = await picker.pickImage(source: ImageSource.gallery);
      if (x != null) {
        imagePath = x.path;
        setState(() {});
      }
    }

    Future<void> pickFromCamera(StateSetter setState) async {
      final x = await picker.pickImage(source: ImageSource.camera);
      if (x != null) {
        imagePath = x.path;
        setState(() {});
      }
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setState) {
          return AlertDialog(
            title: Text(original == null ? 'Add New ${l10n.user}' : l10n.editUser),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image section
                    if (imagePath == null)
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
                                  constraints: BoxConstraints(maxWidth: 150, maxHeight: 150),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: ClipOval(
                                    child: kIsWeb
                                        ? Image.network(imagePath!, fit: BoxFit.cover)
                                        : Image.file(File(imagePath!), fit: BoxFit.cover),
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
                                    imagePath = null;
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

                    // Treatment
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.treatment, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text(l10n.mr),
                                value: 'Sr',
                                groupValue: treatment,
                                onChanged: (v) => setState(() => treatment = v ?? 'Sr'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text(l10n.mrs),
                                value: 'Sra',
                                groupValue: treatment,
                                onChanged: (v) => setState(() => treatment = v ?? 'Sr'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? l10n.mustEnterName : null,
                    ),
                    SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.mustEnterEmail;
                        if (!v.contains('@')) return l10n.invalidEmail;
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Age
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: l10n.age,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.mustEnterAge;
                        if (int.tryParse(v) == null) return l10n.invalidAge;
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Birth place (dropdown, no ListView)
                    LocationDropdown(
                      labelText: l10n.birthPlace,
                      initialValue: birthPlace,
                      onChanged: (place) => birthPlace = place,
                    ),
                    SizedBox(height: 16),

                    // Change password (no confirmation needed)
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.changePassword,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Role dropdown
                    DropdownButtonFormField<UserRole>(
                      value: role,
                      decoration: InputDecoration(
                        labelText: l10n.admin, // label text; options will show localized text below
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: UserRole.ordinary,
                          child: Text(l10n.user),
                        ),
                        DropdownMenuItem(
                          value: UserRole.administrator,
                          child: Text(l10n.admin),
                        ),
                      ],
                      onChanged: (val) => role = val ?? UserRole.ordinary,
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
                  final result = User(
                    name: nameController.text,
                    password: passwordController.text.isNotEmpty
                        ? passwordController.text
                        : (original?.password ?? ''),
                    email: emailController.text,
                    imagePath: imagePath,
                    birthPlace: birthPlace,
                    treatment: treatment,
                    age: int.parse(ageController.text),
                    role: role,
                  );
                  Navigator.pop(dialogCtx);
                  onSave(result);
                },
                child: Text(l10n.saveChanges),
              ),
            ],
          );
        },
      ),
    );
  }
}
