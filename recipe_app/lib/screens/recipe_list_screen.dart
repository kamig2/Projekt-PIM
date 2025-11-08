import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/screens/add_recipe_screen.dart'; 
// --- Model Danych ---
//klasa do przechowywania informacji o przepisie
class Recipe {
  final String title;
  final String duration;
  final String imageUrl;
  String get id => title;

  Recipe({
    required this.title,
    required this.duration,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Recipe && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// --- Główny Widget Ekranu ---
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  // mock data
  final List<Recipe> recipes = [
    Recipe(
      title: 'Baked potatoes',
      duration: '30 min',
      // linki do zdjęć
      imageUrl:
      'https://cdn.loveandlemons.com/wp-content/uploads/2020/01/baked-potato.jpg',
    ),
    Recipe(
      title: 'Onion soup',
      duration: '60 min',
      imageUrl:
      'https://www.thespruceeats.com/thmb/BYc5SJFHrCWFCRpTO5Z2IvMtrZs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/easy-french-onion-soup-3062131-hero-01-2a93bd3c60084db5a8a8e1039c0e0a2f.jpg',
    ),
    Recipe(
      title: 'Lasagne',
      duration: '40 min',
      imageUrl:
      'https://www.pyszne.pl/foodwiki/uploads/sites/7/2018/03/lasagne.jpg',
    ),
    Recipe(
      title: 'Chocolate cake',
      duration: '55 min',
      imageUrl:
      'https://www.allrecipes.com/thmb/zb8muWE6CQ5XjclY_LQ2i-QwxN0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/17981-one-bowl-chocolate-cake-iii-DDMFS-beauty-4x3-d2e182087e4b42a3a281a0a355ea60d1.jpg',
    ),
  ];

  // Stan dla aktywnej zakładki w dolnej nawigacji
  int _selectedIndex = 0;

  // Lista do przechowywania ulubionych przepisów
  final List<Recipe> _favoriteRecipes = [];

  // Kontroler dla paska wyszukiwania
  late TextEditingController _searchController;
  // Lista przechowująca przefiltrowane przepisy
  List<Recipe> _filteredRecipes = []; // Inicjalizowana w initState

  // TODO: Zastąpić te dane prawdziwymi danymi z bazy
  // te dane użyte w zakładce profilu
  final String userName = "Jan";
  final String userSurname = "Nowak";

  @override
  void initState() {
    super.initState();
    // Inicjalizacja kontrolera wyszukiwania
    _searchController = TextEditingController();
    // Na starcie, przefiltrowana lista to pełna lista
    _filteredRecipes = List.from(recipes);
    // Dodajemy "słuchacza", który będzie reagował na zmiany w tekście
    _searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    // Czyścimy "słuchacza" i kontroler, aby uniknąć wycieków pamięci
    _searchController.removeListener(_filterRecipes);
    _searchController.dispose();
    super.dispose();
  }


  // Funkcja filtrująca przepisy
  void _filterRecipes() {
    // Pobieramy aktualny tekst z paska i zamieniamy na małe litery
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Tworzymy nową listę na podstawie głównej listy "recipes"
      _filteredRecipes = recipes.where((recipe) {
        final titleLower = recipe.title.toLowerCase();
        // Zwracamy prawdę, jeśli tytuł zawiera wpisany tekst
        return titleLower.contains(query);
      }).toList();
    });
  }

  // Funkcja do przełączania ulubionych
  void _toggleFavorite(Recipe recipe) {
    setState(() {
      if (_favoriteRecipes.contains(recipe)) {
        _favoriteRecipes.remove(recipe);
      } else {
        _favoriteRecipes.add(recipe);
      }
    });
  }

  // Funkcja do sprawdzania, czy przepis jest ulubiony
  bool _isFavorite(Recipe recipe) {
    return _favoriteRecipes.contains(recipe);
  }

  static const Color primaryPurple = Color(0xFF2D0C57);
  static const Color lightBackground = Color(0xFFFBFBFF); // Bardzo jasne tło

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Zakładka 0: Lista przepisów
          _buildRecipeListTab(),
          // Zakładka 1: Dodaj przepis
          _buildAddTab(),
          // Zakładka 2: Profil
          _buildProfileTab(),
        ],
      ),
      // Dolny pasek nawigacji
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white, // Tło paska nawigacji
        elevation: 10, // Cień paska nawigacji
        type: BottomNavigationBarType.fixed, // Stały typ
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeListTab() {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Recipes',
          style: GoogleFonts.inter(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 29,
          ),
        ),
      ),
      body: Column(
        children: [
          // Pasek wyszukiwania
          _buildSearchBar(),
          // Lista przepisów
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                // Budowanie pojedynczego elementu listy jako karty
                return _buildRecipeCard(_filteredRecipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

/*
  Widget _buildAddTab() {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Add Recipe',
          style: GoogleFonts.inter(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 29,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'TODO: add recipe',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
*/

  Widget _buildAddTab() {
    return const AddRecipeScreen();
  }

  Widget _buildProfileTab() {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 29,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sekcja z informacjami o użytkowniku
          Center(
            child: Column(
              children: [
                Icon(Icons.person_pin_circle_rounded,
                    size: 80, color: primaryPurple),
                const SizedBox(height: 12),
                Text(
                  '$userName $userSurname',
                  style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Sekcja z ulubionymi
          Text(
            'Your Favorites',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryPurple),
          ),
          const SizedBox(height: 16),
          // Budowanie listy ulubionych
          _buildFavoritesList(),

          // Przycisk wylogowania
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              // Wyloguj i wróć do ekranu logowania, czyszcząc stos nawigacji
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text('Log Out',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    if (_favoriteRecipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "You haven't added any favorites yet.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    // Jeśli są ulubione, budujemy listę
    return Column(
      children:
      _favoriteRecipes.map((recipe) => _buildRecipeCard(recipe)).toList(),
    );
  }

  /// Buduje widget paska wyszukiwania
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.inter(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    // Sprawdzamy, czy ten przepis jest ulubiony
    final bool isFavorite = _isFavorite(recipe);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Obrazek
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                recipe.imageUrl,
                width: 170,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Kolumna z tekstem i przyciskiem
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.duration,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Przycisk "Ulubione" (serduszko)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? primaryPurple : Colors.grey.shade500,
                        size: 24,
                      ),
                      onPressed: () {
                        _toggleFavorite(recipe);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

