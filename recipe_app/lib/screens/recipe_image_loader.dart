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

  // Metoda pomocnicza do budowania "zaślepki" (szare tło z ikonką)
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, color: Colors.grey[400], size: 40),
          const SizedBox(height: 4),
          const Text(
            "Brak zdjęcia",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Jeśli URL jest pusty (brak zdjęcia w bazie), od razu pokaż ikonkę
    // Nie próbujemy nawet łączyć się z siecią.
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return FutureBuilder<Uint8List?>(
      future: RecipeService.fetchImage(imageUrl),
      builder: (context, snapshot) {
        // Stan ładowania
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

        // Stan błędu pobierania lub brak danych (np. 404 z serwera)
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _buildPlaceholder();
        }

        // Sukces - mamy bajty, ale dodajemy jeszcze errorBuilder
        // na wypadek gdyby bajty były uszkodzone (to naprawia Twój czerwony błąd)
        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Błąd renderowania obrazka: $error");
            return _buildPlaceholder();
          },
        );
      },
    );
  }
}