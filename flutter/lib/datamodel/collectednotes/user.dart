class User {
  final int id;
  final String email;
  final String name;
  final String role;
  final bool banned;
  final String avatarKey;
  final DateTime createdAt;
  final DateTime updatedAt;

  User(
      {this.name,
        this.role,
        this.banned,
        this.avatarKey,
        this.createdAt,
        this.updatedAt,
        this.id,
        this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      banned: json['banned'],
      avatarKey: json['avatar_key'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

