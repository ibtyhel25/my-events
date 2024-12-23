class Profile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String bio;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
    );
  }

  get profileImageUrl => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
    };
  }
}
