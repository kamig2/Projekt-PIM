import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/user_model.dart';

class RecipeService {
  // --- KONFIGURACJA ADRESU ---
  // 10.0.2.2 dla Emulatora Android.
  // Jeśli używasz fizycznego telefonu, wpisz tu IP komputera (np. 192.168.1.15)
  static const String _ip = "10.0.2.2";
  static const String baseUrl = "http://$_ip:8080";

  // Endpointy
  static const String _allRecipesEndpoint = "/api/recipes";
  // static const String addRecipeEndpoint = "/api/recipes/add"; // Nieużywane bezpośrednio, jest w metodzie

  // --- TOKEN AUTORYZACJI ---
  static String? _userToken;

  // Metoda do ustawiania tokena po zalogowaniu
  static void setAuthToken(String token) {
    _userToken = token;
    print("RecipeService: Token zaktualizowany.");
  }

  // Helper do nagłówków JSON (GET, DELETE)
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

  // --- 4. DODAWANIE PRZEPISU (UPLOAD) ---
  static Future<bool> uploadRecipe({
    required String title,
    required String ingredients,
    required String description,
    required int preparationTime,
    required int portion,
    required List<File> files,
    required List<Uint8List> filesWeb,
  }) async {
    final url = Uri.parse("$baseUrl/api/recipes/add");
    final request = http.MultipartRequest("POST", url);

    // Token
    if (_userToken != null) {
      request.headers["Authorization"] = "Bearer $_userToken";
    }

    // Pola tekstowe
    request.fields["title"] = title;
    request.fields["ingredients"] = ingredients;
    request.fields["description"] = description;
    request.fields["preparationTime"] = preparationTime.toString();
    request.fields["portion"] = portion.toString();

    // Zdjęcia – web
    for (int i = 0; i < filesWeb.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          filesWeb[i],
          filename: "image_web_$i.jpg",
        ),
      );
    }

    // Zdjęcia – mobile
    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath('files', file.path),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final respStr = await response.stream.bytesToString();
      print("Błąd uploadu: ${response.statusCode} - $respStr");
      throw Exception('Błąd uploadu: ${response.statusCode}');
    }
  }

  // --- 5. USUWANIE PRZEPISU ---
  static Future<void> deleteRecipe(int id) async {
    // Zakładamy endpoint: DELETE /api/recipes/{id}
    final url = Uri.parse("$baseUrl/api/recipes/$id");

    try {
      final response = await http.delete(url, headers: _authHeaders);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Przepis $id usunięty pomyślnie.");
      } else {
        throw Exception('Nie udało się usunąć przepisu. Kod: ${response.statusCode}');
      }
    } catch (e) {
      print("Błąd deleteRecipe: $e");
      rethrow;
    }
  }

  // --- 6. EDYCJA PRZEPISU ---
  static Future<bool> updateRecipe({
    required int id,
    required String title,
    required String ingredients,
    required String description,
    required int preparationTime,
    required int portion,
    List<File>? files,
    List<Uint8List>? filesWeb,
  }) async {
    // Zakładamy endpoint: PUT /api/recipes/{id}
    // Jeśli Twój backend wymaga POST do edycji, zmień "PUT" na "POST"
    final url = Uri.parse("$baseUrl/api/recipes/$id");

    final request = http.MultipartRequest("PUT", url);

    // Token
    if (_userToken != null) {
      request.headers["Authorization"] = "Bearer $_userToken";
    }

    // Pola tekstowe
    request.fields["title"] = title;
    request.fields["ingredients"] = ingredients;
    request.fields["description"] = description;
    request.fields["preparationTime"] = preparationTime.toString();
    request.fields["portion"] = portion.toString();

    // Dodajemy zdjęcia tylko jeśli zostały przekazane (użytkownik dodał nowe)
    if (filesWeb != null && filesWeb.isNotEmpty) {
      for (int i = 0; i < filesWeb.length; i++) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            filesWeb[i],
            filename: "new_image_web_$i.jpg",
          ),
        );
      }
    }

    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
      }
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Przepis zaktualizowany pomyślnie.");
      return true;
    } else {
      final respStr = await response.stream.bytesToString();
      print("Błąd aktualizacji: ${response.statusCode} - $respStr");
      throw Exception('Błąd edycji: ${response.statusCode}');
    }
  }

  // Helper do pobierania bajtów zdjęcia (opcjonalny)
  static Future<Uint8List?> fetchImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}