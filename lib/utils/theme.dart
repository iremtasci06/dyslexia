import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final String category;
  final Color primaryColor;
  final Color secondaryColor;
  final String backgroundImage;
  final String themeIcon;

  AppTheme({
    required this.name,
    required this.category,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundImage,
    required this.themeIcon,
  });
}

final List<AppTheme> appThemes = [
  AppTheme(
    name: 'Zürafa',
    category: 'Hayvanlar',
    primaryColor: Colors.orange,
    secondaryColor: Colors.yellow,
    themeIcon: 'assets/animals/zürafa.png',
    backgroundImage: 'assets/icons/zurafa.png',
  ),
  AppTheme(
    name: 'Panda',
    category: 'Hayvanlar',
    primaryColor: Colors.black,
    secondaryColor: Colors.white,
    backgroundImage: 'assets/icons/panda.png',
    themeIcon: 'assets/animals/panda.png',
  ),
  AppTheme(
    name: 'Uğur Böceği',
    category: 'Hayvanlar',
    primaryColor: Color(0xFFFA0011),
    secondaryColor: Colors.black,
    backgroundImage: 'assets/icons/ugur_boceği.png',
    themeIcon: 'assets/animals/uğur böceği.png',
  ),
  AppTheme(
    name: 'Balık',
    category: 'Hayvanlar',
    primaryColor: Color(0xFFA3CCDA),
    secondaryColor: Color(0xFFFAA533),
    backgroundImage:'assets/icons/balık.png',
    themeIcon:  'assets/animals/balık.png',
  ),
  AppTheme(
    name: 'Kuş',
    category: 'Hayvanlar',
    primaryColor: Color(0xFF0BA6DF),
    secondaryColor: Color(0xFFFF9D00),
    backgroundImage: 'assets/icons/kuş.png',
    themeIcon: 'assets/animals/kuş.png',
  ),
  AppTheme(
    name: 'Aslan',
    category: 'Hayvanlar',
    primaryColor: Color(0xFFEF7722),
    secondaryColor: Colors.yellow,
    backgroundImage: 'assets/icons/aslan.png',
    themeIcon: 'assets/animals/aslan.png',
  ),
  AppTheme(
    name: 'Kedi',
    category: 'Hayvanlar',
    primaryColor: Colors.brown,
    secondaryColor: Color(0xFFCFAB8D),
    backgroundImage: 'assets/icons/kedi.png',
    themeIcon: 'assets/animals/kedi.png',
  ),
  AppTheme(
    name: 'Tavşan',
    category: 'Hayvanlar',
    primaryColor: Color(0xFFF5D2D2),
    secondaryColor: Color(0xFFFFF5F2),
    backgroundImage: 'assets/icons/tavsan.png',
    themeIcon: 'assets/animals/tavşan.png',
  ),
  AppTheme(
    name: 'Kelebek',
    category: 'Hayvanlar',
    primaryColor: Colors.pinkAccent,
    secondaryColor: Color(0xFFFFC1DA),
    backgroundImage: 'assets/icons/kelebek.png',
    themeIcon: 'assets/animals/kelebek.png',
  ),
  AppTheme(
    name: 'Kaplumbağa',
    category: 'Hayvanlar',
    primaryColor: Color(0xFF3A6F43),
    secondaryColor: Color(0xFF59AC77),
    backgroundImage: 'assets/icons/kaplumbağa.png',
    themeIcon: 'assets/animals/kaplumbağa.png',
  ),
];