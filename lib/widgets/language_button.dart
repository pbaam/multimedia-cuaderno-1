import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../config/utils/language_service.dart';
import '../l10n/app_localizations.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return PopupMenuButton<Locale>(
          icon: SvgPicture.asset(
            'images/language.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.language,
              color: Colors.white,
            ),
          ),
          onSelected: (Locale locale) {
            languageService.setLocale(locale);
          },
          itemBuilder: (BuildContext context) {
            final l10n = AppLocalizations.of(context)!;
            return [
              PopupMenuItem<Locale>(
                value: Locale('es'),
                child: Row(
                  children: [
                    Text('🇪🇸'),
                    SizedBox(width: 8),
                    Text(l10n.spanish),
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Row(
                  children: [
                    Text('🇬🇧'),
                    SizedBox(width: 8),
                    Text(l10n.english),
                  ],
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
