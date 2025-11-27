import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/register_form.dart';
import '../widgets/language_button.dart';
import '../l10n/app_localizations.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistro();
}

class _PantallaRegistro extends State<PantallaRegistro> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.register),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        actions: [
          LanguageButton(),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}