import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/local_user_controller.dart';
import '../../widgets/location_dropdown.dart';
import '../../widgets/drawer_general.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../l10n/app_localizations.dart';

class PantallaEditarPerfil extends StatefulWidget {
  const PantallaEditarPerfil({super.key});

  @override
  State<PantallaEditarPerfil> createState() => _PantallaEditarPerfilState();
}

class _PantallaEditarPerfilState extends State<PantallaEditarPerfil> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  late String treatment;
  String? imagePath;
  String birthPlace = '';
  final ImagePicker _picker = ImagePicker();
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<LocalUserController>(context, listen: false).user;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    ageController = TextEditingController(text: user?.age.toString() ?? '');
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
    treatment = user?.treatment ?? 'Sr';
    imagePath = user?.imagePath;
    birthPlace = user?.birthPlace ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: CommonAppBar(title: l10n.editProfile),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSection(),
              SizedBox(height: 16),
              _buildTreatmentSection(),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: l10n.age,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              LocationDropdown(
                labelText: l10n.birthPlace,
                initialValue: birthPlace,
                onChanged: (place) {
                  birthPlace = place;
                },
              ),
              SizedBox(height: 24),
              CheckboxListTile(
                title: Text(l10n.changePassword),
                value: _changePassword,
                onChanged: (value) => setState(() => _changePassword = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (_changePassword) ...[
                SizedBox(height: 16),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña actual',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return l10n.mustEnterPassword;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: Text(
                      l10n.forgotPassword,
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return l10n.mustEnterPassword;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: confirmNewPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.repeatPassword,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_changePassword && value != newPasswordController.text) {
                      return l10n.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 0),
                ),
                child: Text(l10n.saveChanges),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildImageSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        if (imagePath == null)
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.lightBlueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.upload),
                    label: Text(l10n.uploadImage),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _takePhoto,
                    icon: Icon(Icons.camera_alt),
                    label: Text(l10n.capture),
                  ),
                ],
              ),
            ],
          )
        else
          Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 150,
                        maxHeight: 150,
                      ),
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
                      onPressed: () => setState(() => imagePath = null),
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
      ],
    );
  }

  Widget _buildTreatmentSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
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
                onChanged: (value) => setState(() => treatment = value ?? 'Sr'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(l10n.mrs),
                value: 'Sra',
                groupValue: treatment,
                onChanged: (value) => setState(() => treatment = value ?? 'Sr'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() => imagePath = photo.path);
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => imagePath = photo.path);
    }
  }

  void _showForgotPasswordDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recoverPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.enterEmailToRecover),
            SizedBox(height: 16),
            Text(
              emailController.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.recoveryEmailSent)),
              );
            },
            child: Text(l10n.send),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (formKey.currentState!.validate()) {
      final userController = Provider.of<LocalUserController>(context, listen: false);
      final currentUser = userController.user;

      if (_changePassword) {
        if (currentUser?.password != oldPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.incorrectCredentials)),
          );
          return;
        }
        currentUser?.password = newPasswordController.text;
      }

      currentUser?.name = nameController.text;
      currentUser?.email = emailController.text;
      currentUser?.age = int.tryParse(ageController.text) ?? currentUser.age;
      currentUser?.birthPlace = birthPlace;
      currentUser?.treatment = treatment;
      currentUser?.imagePath = imagePath;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileUpdated)),
      );
      context.go('/main');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }
}
