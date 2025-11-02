import 'package:flutter/material.dart';
import 'package:recipe_app/screens/recipe_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        primaryColor: const Color(0xFF2C2C2C),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C2C2C),
          brightness: Brightness.light,
          primary: const Color(0xFF2C2C2C),
          secondary: const Color(0xFF3B82F6),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF1C1C1C),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1C1C1C)),
          bodyMedium: TextStyle(color: Color(0xFF87879D)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C2C2C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF3B82F6),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Color(0xFF87879D)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/recipes': (context) => const RecipeListScreen(),
      },
    );
  }
}
