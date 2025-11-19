import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Poniższy import jest KLUCZOWY - mówi temu ekranowi czym jest "Recipe"
import 'package:recipe_app/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  static const Color primaryPurple = Color(0xFF2D0C57);
  static const Color lightBackground = Color(0xFFFBFBFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryPurple),
        // Wyświetlamy prawdziwy tytuł z bazy
        title: Text(
          recipe.title,
          style: GoogleFonts.inter(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obrazek przepisu
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              color: Colors.grey[400], size: 60),
                          const SizedBox(height: 8),
                          Text("Brak zdjęcia", style: TextStyle(color: Colors.grey[500]))
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Czas przygotowania
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    recipe.duration,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sekcja: Składniki (Dane z bazy)
              Text(
                "Ingredients",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 12),
              // Wyświetlamy składniki z obiektu recipe.
              // Jeśli w bazie są oddzielone przecinkami lub nowymi liniami, wyświetlą się tutaj.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  recipe.ingredients.isNotEmpty
                      ? recipe.ingredients
                      : "No ingredients info provided.",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sekcja: Instrukcje / Opis (Dane z bazy)
              Text(
                "Description & Instructions",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  recipe.description.isNotEmpty
                      ? recipe.description
                      : "No description provided.",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}