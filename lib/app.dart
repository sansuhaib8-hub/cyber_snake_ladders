import 'package:flutter/material.dart';
import 'presentation/screens/main_menu_screen.dart';

class CyberSnakeLaddersApp extends StatelessWidget {
  const CyberSnakeLaddersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کایەی مار و پەیژە',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF040508),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFFF),
          secondary: Color(0xFFFF00FF),
          surface: Color(0xFF0D0E15),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0E15),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      home: const MainMenuScreen(),
    );
  }
}
