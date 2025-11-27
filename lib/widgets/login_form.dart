import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../controllers/local_user_controller.dart';
import '../config/resources/button_styles.dart';
import '../services/audio_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _StatefulWidget();
}

class _StatefulWidget extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            nameField(),
            SizedBox(height: 16),
            passwordField(),
            SizedBox(height: 8),
            forgotPasswordLink(),
            SizedBox(height: 24),
            loginButton(),
            SizedBox(height: 8),
            registerButton(),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.orGoogleLogin, style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 16),
            googleSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget nameField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        hintText: l10n.name,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.mustEnterName;
        }
        return null;
      },
    );
  }

  Widget passwordField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: l10n.password,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.mustEnterPassword;
        }
        return null;
      },
    );
  }

  Widget forgotPasswordLink() {
    final l10n = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _showForgotPasswordDialog(context),
        child: Text(
          l10n.forgotPassword,
          style: TextStyle(color: Colors.lightBlueAccent),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recoverPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.enterEmailToRecover),
            SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
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

  Widget loginButton() {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      style: AppButtonStyles.primaryButton,
      child: Text(l10n.login),
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;

        final userController = Provider.of<LocalUserController>(context, listen: false);
        final audioService = Provider.of<AudioService>(context, listen: false);
        
        final login = await userController.login(
          nameController.text,
          passwordController.text,
        );
        if (!mounted) return;

        if (login) {
          await audioService.startBackgroundMusic();
          context.go('/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.incorrectCredentials)),
          );
        }
      },
    );
  }

  Widget registerButton() {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton(
      style: AppButtonStyles.secondaryButton,
      child: Text(l10n.register),
      onPressed: () => context.go('/register'),
    );
  }

  Widget googleSignInButton() {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: () async {
        return;
        final userController = Provider.of<LocalUserController>(context, listen: false);
        final audioService = Provider.of<AudioService>(context, listen: false);
        
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
        
        final success = await userController.loginWithGoogle();
        
        if (!mounted) return;
        
        // Close loading indicator
        Navigator.of(context).pop();
        
        if (success) {
          await audioService.startBackgroundMusic();
          context.go('/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.incorrectCredentials)),
          );
        }
      },
      icon: SvgPicture.asset(
        'images/google.svg',
        height: 24,
        width: 24,
        placeholderBuilder: (context) => Icon(Icons.login, size: 24),
      ),
      label: Text(l10n.loginWithGoogle),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
