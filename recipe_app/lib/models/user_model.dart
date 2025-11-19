class User {
  final int id;
  final String username;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  // Mapuje JSON z backendu: { "userID": 1, "firstName": "Kamila", ... }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? 'Nieznane',
      lastName: json['lastName'] ?? '',
    );
  }
}