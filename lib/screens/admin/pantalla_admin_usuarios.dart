import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/user_repository.dart';
import '../../models/user.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/location_dropdown.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../../config/resources/app_colors.dart';
import '../../config/resources/app_dimensions.dart';
import '../../config/utils/validators.dart';

class PantallaAdminUsuarios extends StatefulWidget {
  const PantallaAdminUsuarios({super.key});

  @override
  State<PantallaAdminUsuarios> createState() => _PantallaAdminUsuariosState();
}

class _PantallaAdminUsuariosState extends State<PantallaAdminUsuarios> {
  final UserRepository userRepo = UserRepository();

  @override
  Widget build(BuildContext context) {
    final users = userRepo.getAllUsers();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.adminUsers,
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
      body: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final isRootAdmin = user.name.toLowerCase() == 'admin';
          return Card(
            margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.role == UserRole.administrator
                    ? AppColors.red
                    : AppColors.primary,
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
                        color: AppColors.white,
                      )
                    : null,
              ),
              title: Text(user.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email),
                  Text(
                    user.role == UserRole.administrator
                        ? l10n.admin
                        : l10n.user,
                    style: TextStyle(
                      color: user.role == UserRole.administrator
                          ? AppColors.red
                          : AppColors.grey,
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
                      icon: Icon(Icons.edit, color: AppColors.blue),
                      onPressed: () {
                        _showUserFormDialog(
                          context: context,
                          l10n: l10n,
                          original: user,
                          onSave: (updated) {
                            // Persiste cambios según sea necesario (actualización del repositorio si está disponible)
                            user.name = updated.name;
                            user.email = updated.email;
                            user.age = updated.age;
                            user.birthPlace = updated.birthPlace;
                            user.treatment = updated.treatment;
                            user.imagePath = updated.imagePath;
                            user.password = updated.password;
                            user.role = updated.role;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${l10n.user} ${user.name} ${l10n.userUpdated}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  if (!isRootAdmin)
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.red),
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
            onSave: (created) async {
              final success = await userRepo.register(created);
              if (success) {
                setState(() {}); // Desencadena reconstrucción
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${l10n.user} ${created.name} ${l10n.registrationSuccessful}',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.userAlreadyExists)));
              }
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    User user,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteUser),
        content: Text('${l10n.areYouSureDeleteUser} ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.user} ${user.name} ${l10n.userDeleted}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  /// Formulario unificado para editar/crear un usuario por el administrador
  void _showUserFormDialog({
    required BuildContext context,
    required AppLocalizations l10n,
    User? original,
    required void Function(User result) onSave,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: original?.name ?? '');
    final emailController = TextEditingController(text: original?.email ?? '');
    final ageController = TextEditingController(
      text: original != null ? original!.age.toString() : '',
    );
    final passwordController = TextEditingController(
      text: original?.password ?? '',
    );
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
            title: Text(original == null ? l10n.createUser : l10n.editUser),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sección de imagen
                    if (imagePath == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => pickFromGallery(setState),
                            icon: Icon(Icons.upload),
                            label: Text(l10n.uploadImage),
                          ),
                          SizedBox(width: AppDimensions.spacing8),
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
                                    maxWidth: AppDimensions.imageSize150,
                                    maxHeight: AppDimensions.imageSize150,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.grey),
                                  ),
                                  child: ClipOval(
                                    child: kIsWeb
                                        ? Image.network(
                                            imagePath!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(imagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: AppColors.red),
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppColors.white,
                                    padding: EdgeInsets.all(AppDimensions.spacing4),
                                  ),
                                  onPressed: () {
                                    imagePath = null;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.spacing8),
                          Text(
                            l10n.tapToChange,
                            style: TextStyle(
                              fontSize: AppDimensions.fontSize12,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Tratamiento
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.treatment,
                          style: TextStyle(
                            fontSize: AppDimensions.fontSize16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text(l10n.mr),
                                value: 'Sr',
                                groupValue: treatment,
                                onChanged: (v) =>
                                    setState(() => treatment = v ?? 'Sr'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text(l10n.mrs),
                                value: 'Sra',
                                groupValue: treatment,
                                onChanged: (v) =>
                                    setState(() => treatment = v ?? 'Sr'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Nombre
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => FormValidators.validateName(v, l10n),
                    ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Correo
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => FormValidators.validateEmail(v, l10n),
                    ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Edad
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: l10n.age,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => FormValidators.validateAge(v, l10n),
                    ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Lugar de nacimiento - usar LocationDropdown
                    LocationDropdown(
                      labelText: l10n.birthPlace,
                      initialValue: birthPlace,
                      onChanged: (place) {
                        birthPlace = place;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Cambiar contraseña (no se necesita confirmación)
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.changePassword,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing16),

                    // Menú desplegable de rol
                    DropdownButtonFormField<UserRole>(
                      value: role,
                      decoration: InputDecoration(
                        labelText: l10n.admin, // texto de etiqueta; las opciones mostrarán texto localizado abajo
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
                child: Text(original == null ? l10n.create : l10n.save),
              ),
            ],
          );
        },
      ),
    );
  }
}
