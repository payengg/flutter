import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:terraserve_app/pages/models/user.dart';

class ApiService {
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost/api';
  static final storage = FlutterSecureStorage();

  static Future<bool> updateProfile(
    String name,
    String email,
    String phone,
    String gender,
    String birthdate,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/user');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'gender': gender,
          'birthdate': birthdate,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully.');
        return true;
      } else {
        print('Update failed: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Exception during updateProfile: $e');
      return false;
    }
  }

  static Future<User?> fetchUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonMap = json.decode(response.body);

      if (jsonMap.containsKey('data')) {
        return User.fromJson(jsonMap['data']);
      } else {
        print('Unexpected response format: $jsonMap');
        return null;
      }
    } else {
      print('Failed to fetch user: ${response.body}');
      return null;
    }
  }
}
