class User {
  final int? id;
  final String userId;
  final String name;
  final String email;
  final String profile;

  User({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.profile,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'profile': profile,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      email: map['email'],
      profile: map['profile'],
    );
  }
}
