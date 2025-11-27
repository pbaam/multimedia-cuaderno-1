import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/login_form.dart';
import '../widgets/language_button.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _PantallaInicioSesion();
}

class _PantallaInicioSesion extends State<PantallaInicioSesion> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mainPage),
        automaticallyImplyLeading: false,
        actions: [
          LanguageButton(),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'images/youtube.svg',
                  semanticsLabel: 'YouTube logo',
                  height: 150,
                  width: 150,
                  colorFilter: ColorFilter.mode(
                    Colors.lightBlueAccent,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (context) => Container(
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}