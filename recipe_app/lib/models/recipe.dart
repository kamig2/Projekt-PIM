class Recipe {
  final int id;
  final String title;
  final String duration;
  final String imageUrl;
  final String description;
  final String ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
  });

  // Parsowanie JSON z backendu Kamili
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final int preparationTime = json['preparationTime'] ?? 0;

    // --- LOGIKA ZDJĘĆ ---
    // Domyślny obrazek (placeholder)
    String imgUrl = 'https://placehold.co/170x120/e0e0e0/333333?text=Brak+zdjecia';

    // Sprawdzamy czy backend zwrócił listę plików w 'imageUrls' (zależnie od DTO Kamili)
    // Jeśli w JSON jest pole 'files' lub 'imageUrls' z nazwą pliku:
    if (json['imageUrls'] != null && (json['imageUrls'] as List).isNotEmpty) {
      String rawUrl = (json['imageUrls'] as List).first.toString();

      if (rawUrl.startsWith('http')) {
        // Jeśli to pełny link (np. zewnętrzny), zostawiamy jak jest
        imgUrl = rawUrl;
      } else {
        // Jeśli to nazwa pliku (np. "ciasto.jpg"), doklejamy adres serwera
        // 10.0.2.2 to adres localhosta twojego komputera widziany z Emulatora Androida
        imgUrl = 'http://10.0.2.2:8080/upload/$rawUrl';
      }
    }

    return Recipe(
      id: json['recipeId'] ?? 0,
      title: json['title'] ?? 'Bez tytułu',
      duration: '$preparationTime min',
      imageUrl: imgUrl,
      description: json['description'] ?? '',
      ingredients: json['ingredients'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Recipe && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}