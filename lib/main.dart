import 'package:flutter/material.dart';
import 'package:opthadoc/home.dart';
import 'package:opthadoc/Camp/camp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  print('Current working directory: ${Directory.current.path}');
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('Failed to load .env file: $e');
  }
  runApp(const MyApp(initialRoute: '/home'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildThemeData(),
      initialRoute: initialRoute,
      routes: _buildRoutes(),
    );
  }

  // Extracted theme configuration for better readability
  ThemeData _buildThemeData() {
    return ThemeData(
      dividerColor: Colors.transparent, // Transparent divider
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Color(0xFF163352), // Cursor dropper color
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xFF163352), // Default text color
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF163352), // Default text color
        ),
      ),
    );
  }

  // Centralized routes configuration for easier expansion
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => const Home(),
      '/camp': (context) => const Camp(),
    };
  }
}
