class Recipe {
  final int id;
  final String title;
  final String duration;
  final String imageUrl;
  final String description;
  final String ingredients;
  final int portion; // <--- 1. Dodajemy pole

  // Konfiguracja adresu serwera
  static const String _serverIp = '10.0.2.2';
  static const String _serverPort = '8080';

  Recipe({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.portion, // <--- 2. Dodajemy do konstruktora
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final int preparationTime = json['preparationTime'] ?? 0;

    String imgUrl = '';
    if (json['imageUrls'] != null && (json['imageUrls'] as List).isNotEmpty) {
      String rawUrl = (json['imageUrls'] as List).first.toString();
      if (rawUrl.startsWith('http')) {
        imgUrl = rawUrl;
      } else {
        String cleanFileName = rawUrl.split('\\').last.split('/').last;
        imgUrl = 'http://$_serverIp:$_serverPort/upload/$cleanFileName';
      }
    }

    return Recipe(
      id: json['recipeId'] ?? 0,
      title: json['title'] ?? 'Bez tytułu',
      duration: '$preparationTime min',
      imageUrl: imgUrl,
      description: json['description'] ?? '',
      ingredients: json['ingredients'] ?? '',
      portion: json['portion'] ?? 0, // <--- 3. Pobieramy z JSON-a
    );
  }
}