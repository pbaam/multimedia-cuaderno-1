import 'package:cuaderno1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/login_form.dart';
import '../widgets/language_button.dart';
import '../config/resources/app_colors.dart';
import '../config/resources/app_dimensions.dart';

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
          constraints: BoxConstraints(maxWidth: AppDimensions.maxWidth500),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'images/youtube.svg',
                  semanticsLabel: 'YouTube logo',
                  height: AppDimensions.imageSize150,
                  width: AppDimensions.imageSize150,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (context) => Container(
                    width: AppDimensions.imageSize150,
                    height: AppDimensions.imageSize150,
                    child: Icon(
                      Icons.account_circle,
                      size: AppDimensions.imageSize150,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spacing40),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}