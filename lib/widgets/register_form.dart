import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../models/user.dart';
import '../controllers/local_user_controller.dart';
import '../config/resources/button_styles.dart';
import '../config/resources/app_colors.dart';
import '../config/resources/app_dimensions.dart';
import '../config/utils/validators.dart';
import 'location_dropdown.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  
  String treatment = 'Sr';
  bool acceptTerms = false;
  String? imagePath;
  String birthPlace = '';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          treatmentRadioButtons(),
          SizedBox(height: AppDimensions.spacing16),
          nameField(),
          SizedBox(height: AppDimensions.spacing16),
          emailField(),
          SizedBox(height: AppDimensions.spacing16),
          passwordField(),
          SizedBox(height: AppDimensions.spacing16),
          confirmPasswordField(),
          SizedBox(height: AppDimensions.spacing16),
          imageUploadSection(),
          SizedBox(height: AppDimensions.spacing16),
          ageField(),
          SizedBox(height: AppDimensions.spacing16),
          birthPlaceField(),
          SizedBox(height: AppDimensions.spacing16),
          termsCheckbox(),
          SizedBox(height: AppDimensions.spacing24),
          acceptButton(),
        ],
      ),
    );
  }

  Widget treatmentRadioButtons() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.treatment, style: TextStyle(fontSize: AppDimensions.fontSize16, fontWeight: FontWeight.w500)),
        SizedBox(height: AppDimensions.spacing8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(l10n.mr),
                value: 'Sr',
                groupValue: treatment,
                onChanged: (String? value) {
                  setState(() => treatment = value ?? 'Sr');
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(l10n.mrs),
                value: 'Sra',
                groupValue: treatment,
                onChanged: (String? value) {
                  setState(() => treatment = value ?? 'Sr');
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget nameField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: l10n.name,
        border: OutlineInputBorder(),
      ),
      validator: (value) => FormValidators.validateName(value, l10n),
    );
  }

  Widget emailField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: l10n.email,
        border: OutlineInputBorder(),
      ),
      validator: (value) => FormValidators.validateEmail(value, l10n),
    );
  }

  Widget passwordField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: l10n.password,
        border: OutlineInputBorder(),
      ),
      validator: (value) => FormValidators.validatePassword(value, l10n),
    );
  }

  Widget confirmPasswordField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: l10n.repeatPassword,
        border: OutlineInputBorder(),
      ),
      validator: (value) => FormValidators.validateConfirmPassword(
        value,
        passwordController.text,
        l10n,
      ),
    );
  }

  Widget imageUploadSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (imagePath == null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload),
                label: Text(l10n.uploadImage),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing16, horizontal: AppDimensions.spacing24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing8),
              OutlinedButton.icon(
                onPressed: _takePhoto,
                icon: Icon(Icons.camera_alt),
                label: Text(l10n.capture),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing16, horizontal: AppDimensions.spacing24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                  ),
                ),
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
                        maxWidth: AppDimensions.imageSize150,
                        maxHeight: AppDimensions.imageSize150,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                        child: kIsWeb
                            ? Image.network(
                                imagePath!,
                                fit: BoxFit.contain,
                              )
                            : Image.file(
                                File(imagePath!),
                                fit: BoxFit.contain,
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
                        setState(() => imagePath = null);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spacing8),
              Text(
                l10n.tapToChange,
                style: TextStyle(fontSize: AppDimensions.fontSize12, color: AppColors.grey600),
              ),
            ],
          ),
      ],
    );
  }

  /// Selecciona una imagen de la galería
  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    
    if (photo != null) {
      setState(() => imagePath = photo.path);
    }
  }

  /// Toma una foto con la cámara
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
    );
    
    if (photo != null) {
      setState(() => imagePath = photo.path);
    }
  }

  Widget ageField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: ageController,
      decoration: InputDecoration(
        labelText: l10n.age,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) => FormValidators.validateAge(value, l10n),
    );
  }

  Widget birthPlaceField() {
    final l10n = AppLocalizations.of(context)!;
    return LocationDropdown(
      labelText: l10n.birthPlace,
      initialValue: birthPlace,
      onChanged: (place) {
        birthPlace = place;
      },
    );
  }

  Widget termsCheckbox() {
    final l10n = AppLocalizations.of(context)!;
    return CheckboxListTile(
      title: Text(l10n.acceptTerms),
      value: acceptTerms,
      onChanged: (bool? value) {
        setState(() => acceptTerms = value ?? false);
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget acceptButton() {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      style: AppButtonStyles.primaryButton,
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;
        
        if (!acceptTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.mustAcceptTerms)),
          );
          return;
        }

        if (birthPlace.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.mustEnterBirthPlace)),
          );
          return;
        }

        final user = User(
          name: nameController.text,
          password: passwordController.text,
          email: emailController.text,
          imagePath: imagePath,
          birthPlace: birthPlace,
          treatment: treatment,
          age: int.parse(ageController.text),
        );

        final userController = Provider.of<LocalUserController>(context, listen: false);
        final success = await userController.register(user);
        
        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.registrationSuccessful)),
          );
          context.go('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.userAlreadyExists)),
          );
        }
      },
      child: Text(l10n.accept),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
