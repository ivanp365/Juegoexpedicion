import 'package:flutter/material.dart';
class TC {
  TC._();
  static const woodLightest = Color(0xFFE0B584);
  static const woodLight = Color(0xFFC08850);
  static const woodMid = Color(0xFF8B5A2B);
  static const woodDark = Color(0xFF5C3A1E);
  static const woodShadow = Color(0xFF2E1A0A);
  static const woodDeep = Color(0xFF1A0E04);
  static const goldBright = Color(0xFFFFE08A);
  static const gold = Color(0xFFF2C94C);
  static const goldDark = Color(0xFFB8860B);
  static const goldDeep = Color(0xFF7A5800);
  static const leaf = Color(0xFF6FB54A);
  static const leafDark = Color(0xFF3A6B22);
  static const leafDeep = Color(0xFF1E3A10);
  static const cream = Color(0xFFFFF8EC);
  static const creamDark = Color(0xFFE8D4B0);
  static const red = Color(0xFFD9342B);
  static const redDark = Color(0xFF8B1F1A);
  static const provision = Color(0xFF6FB54A);
  static const regulacion = Color(0xFF4A90B8);
  static const soporte = Color(0xFFD9A441);
  static const cultural = Color(0xFF9B6BB5);
  static BoxDecoration woodPanel({bool destacado = false}) => BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: destacado ? [goldBright, gold, goldDark] : [woodLightest, woodLight, woodDark], stops: const [0.0, 0.45, 1.0]), borderRadius: BorderRadius.circular(20), border: Border.all(color: woodShadow, width: 3), boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))]);
}
