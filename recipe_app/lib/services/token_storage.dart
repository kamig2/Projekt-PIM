import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _jwtKey = 'jwt';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _jwtKey);
  }

  //funkcja dodaje nagłówki do requestów
  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": token != null ? "Bearer $token" : "",
    };
  }
}
