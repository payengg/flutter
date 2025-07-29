class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? gender; // <== Tambahkan ini
  final String? birthdate; // <== Tambahkan ini

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.gender, // <== Tambahkan ini
    this.birthdate, // <== Tambahkan ini
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'], // <== Tambahkan ini
      birthdate: json['birthdate'], // <== Tambahkan ini
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender, // <== Tambahkan ini
      'birthdate': birthdate, // <== Tambahkan ini
    };
  }
}
