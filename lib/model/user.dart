import 'dart:typed_data';

class User {
  final int? id;
  final String name;
  final String email;
  Uint8List? profile;

  User({
    this.id,
    required this.name,
    required this.email,
    this.profile,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profile': profile,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      profile: map['profile'],
    );
  }
}
