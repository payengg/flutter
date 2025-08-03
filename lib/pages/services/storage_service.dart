// File: lib/pages/services/storage_service.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Gunakan konstanta untuk nama kunci agar konsisten di seluruh aplikasi
  static const _tokenKey = 'access_token';
  static const _userDataKey = 'user_data';

  final _secureStorage = const FlutterSecureStorage();

  // --- TOKEN MANAGEMENT ---

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // --- USER DATA MANAGEMENT ---

  Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  // --- LOGOUT / DELETE ALL ---

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
  }
}
