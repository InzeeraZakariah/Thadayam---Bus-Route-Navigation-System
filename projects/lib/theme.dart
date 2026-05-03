import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: Color(0xFF2F80ED),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}