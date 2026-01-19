// lib/pages/models/user.dart

class User {
  final int id;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? birthdate;
  final String? profilePhotoUrl;
  final String? address;

  // ✅ 1. PASTIKAN INI ADA
  final String? role;

  User({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthdate,
    this.profilePhotoUrl,
    this.address,
    // ✅ 2. PASTIKAN INI ADA DI CONSTRUCTOR
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthdate: json['birthdate'],
      profilePhotoUrl: json['profile_photo_url'],
      address: json['address'],
      // ✅ 3. INI PALING PENTING! (Menangkap data dari server)
      role: json['roles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birthdate': birthdate,
      'profile_photo_url': profilePhotoUrl,
      'address': address,
      // ✅ 4. Opsional, tapi bagus ada
      'role': role,
    };
  }
}
