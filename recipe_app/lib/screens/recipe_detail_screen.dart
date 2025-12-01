import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Upewnij się, że Twój model Recipe ma pole 'portion' (int lub String)
import 'package:recipe_app/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  static const Color primaryPurple = Color(0xFF2D0C57);
  static const Color lightBackground = Color(0xFFFBFBFF);

  @override
  Widget build(BuildContext context) {
    List<String> ingredientsList = [];
    if (recipe.ingredients.isNotEmpty) {
      ingredientsList = recipe.ingredients.split(', ');
    }

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryPurple),
        centerTitle: true,
        title: Text(
          recipe.title,
          style: GoogleFonts.inter(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. ZDJĘCIE ---
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported,
                              color: Colors.grey[400], size: 60),
                          const SizedBox(height: 8),
                          Text("Brak zdjęcia",
                              style: TextStyle(color: Colors.grey[500]))
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // --- 2. METADANE (CZAS I PORCJE) ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Czas
                    _buildIconInfo(
                        Icons.timer_outlined,
                        recipe.duration, // np. "45 min"
                        "Cook time"
                    ),
                    // Separator pionowy
                    Container(height: 40, width: 1, color: Colors.grey[200]),
                    // Porcje
                    _buildIconInfo(
                        Icons.people_outline,
                        // Zakładam, że w modelu Recipe masz pole 'portion' (int)
                        // Jeśli nazywa się inaczej, zmień poniższą linię
                        "${recipe.portion} servings",
                        "Yield"
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 3. SKŁADNIKI (FORMATOWANA LISTA) ---
              Text(
                "Ingredients",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 16),

              if (ingredientsList.isEmpty)
                const Text("No ingredients info provided.")
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(), // Scrolluje całe body, nie lista
                  shrinkWrap: true,
                  itemCount: ingredientsList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ingredient = ingredientsList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Color(0xFF00C853), // Zielony "ptaszek"
                              size: 20
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 32),

              // --- 4. OPIS / INSTRUKCJE ---
              Text(
                "Preparation",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Text(
                  recipe.description.isNotEmpty
                      ? recipe.description
                      : "No description provided.",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.6, // Większy odstęp między liniami dla czytelności
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

  // Pomocniczy widget do wyświetlania ikonki z tekstem (Czas/Porcje)
  Widget _buildIconInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: primaryPurple, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}