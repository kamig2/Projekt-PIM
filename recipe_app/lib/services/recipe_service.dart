import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_model.dart';

class RecipeService {
  // --- KONFIGURACJA ADRESU ---
  // 10.0.2.2 dla Emulatora. Dla telefonu wpisz IP komputera (np. 192.168.1.x)
  static const String _ip = "10.0.2.2";
  static const String baseUrl = "http://$_ip:8080";
  static const String _allRecipesEndpoint = "/api/recipes";

  // --- TOKEN AUTORYZACJI ---
  // ZMIANA: Usunięty sztywny token. Teraz domyślnie jest null.
  static String? _userToken;

  // Metoda do ustawiania tokena po zalogowaniu
  static void setAuthToken(String token) {
    _userToken = token;
    print("RecipeService: Token zaktualizowany.");
  }

  // Helper do nagłówków
  static Map<String, String> get _authHeaders {
    final headers = {"Content-Type": "application/json"};
    if (_userToken != null) {
      headers["Authorization"] = "Bearer $_userToken";
    }
    return headers;
  }

  // --- 1. POBIERANIE WSZYSTKICH PRZEPISÓW (Publiczne) ---
  static Future<List<Recipe>> fetchAllRecipes() async {
    final url = Uri.parse("$baseUrl$_allRecipesEndpoint");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Recipe.fromJson(item)).toList();
      } else {
        throw Exception('Błąd serwera: ${response.statusCode}');
      }
    } catch (e) {
      print("Błąd fetchAllRecipes: $e");
      rethrow;
    }
  }

  // --- 2. POBIERANIE "MOICH PRZEPISÓW" (Wymaga tokena) ---
  static Future<List<Recipe>> fetchMyRecipes() async {
    final url = Uri.parse("$baseUrl/api/recipes/userRecipes");

    try {
      final response = await http.get(url, headers: _authHeaders);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Recipe.fromJson(item)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('Brak dostępu (403). Token może być nieważny lub brak tokena.');
      } else {
        throw Exception('Błąd serwera: ${response.statusCode}');
      }
    } catch (e) {
      print("Błąd fetchMyRecipes: $e");
      rethrow;
    }
  }

  // --- 3. POBIERANIE DANYCH ZALOGOWANEGO UŻYTKOWNIKA ---
  static Future<User> fetchLoggedUserDetails() async {
    final url = Uri.parse("$baseUrl/users/logged/user");

    try {
      final response = await http.get(url, headers: _authHeaders);

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        return User.fromJson(body);
      } else {
        throw Exception('Nie udało się pobrać danych użytkownika: ${response.statusCode}');
      }
    } catch (e) {
      print("Błąd fetchLoggedUserDetails: $e");
      rethrow;
    }
  }

  // --- 4. POBIERANIE ZDJĘCIA ---
  static Future<Uint8List?> fetchImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}