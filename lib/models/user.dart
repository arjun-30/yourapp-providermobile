class User {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? avatarUrl;
  final String role;
  final bool isVerified;

  User({required this.id, required this.phone, required this.name, this.email, this.avatarUrl, required this.role, required this.isVerified});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'], phone: json['phone'], name: json['name'],
    email: json['email'], avatarUrl: json['avatarUrl'],
    role: json['role'], isVerified: json['isVerified'] ?? false,
  );
}
