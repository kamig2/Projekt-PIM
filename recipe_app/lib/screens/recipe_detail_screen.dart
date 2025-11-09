import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_list_screen.dart';

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
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey[400], size: 60),
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

              // Sekcja: Składniki
              Text(
                "Ingredients",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 12),
              _buildPlaceholderList([
                "2 cups of flour",
                "1 tbsp of olive oil",
                "Salt and pepper to taste",
                "1 onion, chopped",
                "1 cup of water",
              ]),

              const SizedBox(height: 24),

              // Sekcja: Instrukcje
              Text(
                "Instructions",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "1. Preheat your oven to 180°C.\n"
                    "2. Mix all ingredients in a large bowl.\n"
                    "3. Pour the mixture into a baking dish.\n"
                    "4. Bake for 30–40 minutes until golden brown.\n"
                    "5. Let it cool before serving.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 6, color: primaryPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  ingredient,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
