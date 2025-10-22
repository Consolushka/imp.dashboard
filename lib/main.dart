import 'package:flutter/material.dart';
import 'package:imp/core/di.dart';
import 'screens/home_screen.dart';

// const apiUrl = "https://hfhq-a10d-zqqo.gw-1a.dockhost.net/api";
const apiUrl = "http://localhost/api";

void main() {

  DependencyInjection().registerDependencies();

  runApp(const ImpApp());
}

class ImpApp extends StatelessWidget {
  const ImpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMP Basketball Stats',
      theme: _buildTheme(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        // background: Colors.white,
        // onBackground: Colors.black,
        outline: Colors.grey,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      dividerColor: Colors.grey,
    );
  }
}
