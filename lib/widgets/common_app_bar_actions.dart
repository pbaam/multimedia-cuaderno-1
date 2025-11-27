import 'package:flutter/material.dart';
import 'audio_button.dart';
import 'language_button.dart';

class CommonAppBarActions extends StatelessWidget {
  const CommonAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AudioButton(),
        LanguageButton(),
      ],
    );
  }
}
