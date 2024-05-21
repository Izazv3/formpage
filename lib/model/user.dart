class User {
  final int? id;
  final String name;
  final String email;
  final String profile;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.profile,
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
      profile: map['profile'] ?? "",
    );
  }
}
