import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_model.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/screens/add_recipe_screen.dart';
import 'package:recipe_app/screens/recipe_detail_screen.dart';
import 'package:recipe_app/screens/recipe_image_loader.dart'; // Upewnij się, że masz ten plik

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  // --- STAN ZAKŁADKI "RECIPES" ---
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  String? _errorMessage;

  // --- STAN ZAKŁADKI "PROFILE" ---
  List<Recipe> _myRecipes = []; // Przepisy z endpointu /userRecipes
  User? _currentUser; // Dane z endpointu /users/logged/user
  bool _isProfileLoading = false;

  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<Recipe> _favoriteRecipes = []; // Lokalne ulubione

  static const Color primaryPurple = Color(0xFF2D0C57);
  static const Color lightBackground = Color(0xFFFBFBFF);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRecipes);

    // 1. Pobierz wszystkie przepisy na start
    _fetchRecipes();

    // 2. Pobierz dane profilowe w tle
    _loadProfileData();
  }

  // --- POBIERANIE WSZYSTKICH PRZEPISÓW ---
  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final recipes = await RecipeService.fetchAllRecipes();
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Nie udało się pobrać danych.";
        });
      }
    }
  }

  // --- POBIERANIE DANYCH PROFILU ---
  Future<void> _loadProfileData() async {
    setState(() {
      _isProfileLoading = true;
    });

    try {
      // A. Pobierz dane o użytkowniku (firstName, lastName)
      final user = await RecipeService.fetchLoggedUserDetails();

      // B. Pobierz przepisy tego użytkownika (Twoje przepisy)
      // Endpoint: /api/recipes/userRecipes
      final myRecipes = await RecipeService.fetchMyRecipes();

      if (mounted) {
        setState(() {
          _currentUser = user;
          _myRecipes = myRecipes;
          _isProfileLoading = false;
        });
      }
    } catch (e) {
      print("Błąd profilu: $e");
      if (mounted) {
        setState(() {
          _isProfileLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        final titleLower = recipe.title.toLowerCase();
        return titleLower.contains(query);
      }).toList();
    });
  }

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      if (_favoriteRecipes.contains(recipe)) {
        _favoriteRecipes.remove(recipe);
      } else {
        _favoriteRecipes.add(recipe);
      }
    });
  }

  bool _isFavorite(Recipe recipe) {
    return _favoriteRecipes.contains(recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildRecipeListTab(), // 0
          _buildAddTab(),        // 1
          _buildProfileTab(),    // 2
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 2) _loadProfileData(); // Odśwież profil przy wejściu
            if (index == 0) _fetchRecipes();
          });
        },
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Recipes'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // --- WIDOK 1: LISTA PRZEPISÓW ---
  Widget _buildRecipeListTab() {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Recipes',
          style: GoogleFonts.inter(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 29),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: primaryPurple),
            onPressed: _fetchRecipes,
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: primaryPurple))
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _filteredRecipes.isEmpty
                ? const Center(child: Text("Brak przepisów."))
                : ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeCard(_filteredRecipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDOK 2: DODAWANIE ---
  Widget _buildAddTab() {
    return AddRecipeScreen(
      onCancel: () {
        setState(() {
          _selectedIndex = 0;
          _fetchRecipes();
        });
      },
    );
  }

  // --- WIDOK 3: PROFIL ---
  Widget _buildProfileTab() {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Profile', style: GoogleFonts.inter(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 29)),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh, color: primaryPurple),
              onPressed: _loadProfileData
          )
        ],
      ),
      body: _isProfileLoading
          ? const Center(child: CircularProgressIndicator(color: primaryPurple))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. DANE UŻYTKOWNIKA
          Center(
            child: Column(
              children: [
                const Icon(Icons.account_circle, size: 90, color: primaryPurple),
                const SizedBox(height: 12),
                Text(
                  _currentUser != null
                      ? "${_currentUser!.firstName} ${_currentUser!.lastName}"
                      : "Użytkownik",
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: primaryPurple),
                ),
                Text(
                  _currentUser != null ? _currentUser!.username : "Brak danych",
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // 2. LISTA PRZEPISÓW UŻYTKOWNIKA (z endpointu /userRecipes)
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: primaryPurple),
              const SizedBox(width: 8),
              Text('My Recipes', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPurple)),
            ],
          ),
          const SizedBox(height: 16),

          if (_myRecipes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Nie dodałeś jeszcze żadnych przepisów.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          else
            Column(
              children: _myRecipes.map((recipe) => _buildRecipeCard(recipe)).toList(),
            ),

          const SizedBox(height: 32),

          // 3. PRZYCISK WYLOGOWANIA
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text('Log Out', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- WIDGETY POMOCNICZE ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.inter(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final bool isFavorite = _isFavorite(recipe);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obrazek
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: RecipeImageLoader(
                  imageUrl: recipe.imageUrl,
                  width: 170,
                  height: 120,
                ),
              ),
              const SizedBox(width: 16),
              // Opis
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: primaryPurple),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.duration,
                      style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    // Ikona ulubionych
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? primaryPurple : Colors.grey.shade500, size: 24),
                          onPressed: () => _toggleFavorite(recipe),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}