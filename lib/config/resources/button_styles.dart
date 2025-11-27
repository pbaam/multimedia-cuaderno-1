import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.lightBlueAccent,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 0,
  );

  static ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    foregroundColor: Colors.lightBlueAccent,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    side: BorderSide(color: Colors.lightBlueAccent, width: 1.5),
  );
}
