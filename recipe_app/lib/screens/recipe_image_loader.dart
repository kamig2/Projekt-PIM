import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:recipe_app/services/recipe_service.dart';

class RecipeImageLoader extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const RecipeImageLoader({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      // Tu wywołujemy naszą nową metodę z serwisu
      future: RecipeService.fetchImage(imageUrl),
      builder: (context, snapshot) {
        // 1. Stan ładowania
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        // 2. Stan błędu lub brak danych (null)
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, color: Colors.grey),
                const SizedBox(height: 4),
                // Wyświetlamy mały tekst diagnostyczny
                const Text("Błąd", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          );
        }

        // 3. Sukces - mamy bajty!
        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      },
    );
  }
}