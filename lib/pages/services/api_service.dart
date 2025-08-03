// File: lib/pages/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'
    as http; // Masih diperlukan untuk updateProfile dan fetchUser
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:terraserve_app/pages/models/user.dart';
import 'package:dio/dio.dart';
import 'package:terraserve_app/pages/models/application_data.dart';

class ApiService {
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost/api';
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio(); // Inisialisasi Dio untuk digunakan dalam class

  // Metode yang sudah ada untuk update profil (TIDAK ADA PERUBAHAN)
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

  // Metode yang sudah ada untuk mengambil data user (TIDAK ADA PERUBAHAN)
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

  // Metode BARU untuk mengirim data pendaftaran petani dengan DIO
  static Future<Map<String, dynamic>> submitFarmerApplication(
    FarmerApplicationData data,
    String token,
  ) async {
    final uri = '$baseUrl/farmer-applications';

    print('--- Debugging File Paths ---');
    print('ktpPhoto: ${data.ktpPhoto?.path}');
    print('facePhoto: ${data.facePhoto?.path}');
    print('farmPhoto: ${data.farmPhoto?.path}');
    print('storeLogo: ${data.storeLogo?.path}');
    data.products.asMap().forEach((index, product) {
      print('product[$index] photo: ${product.photo?.path}');
    });
    print('--- End Debug ---');

    final formData = FormData();

    formData.fields
      ..add(MapEntry('user_id', data.userId.toString()))
      ..add(MapEntry('full_name', data.fullName.trim()))
      ..add(MapEntry('nik', data.nik.trim()))
      ..add(MapEntry('farm_address', data.farmAddress.trim()))
      ..add(MapEntry('land_size_status', data.landSizeStatus.trim()))
      ..add(MapEntry('store_name', data.storeName.trim()))
      ..add(MapEntry('product_type', data.productType.trim()))
      ..add(MapEntry('store_description', data.storeDescription.trim()))
      ..add(MapEntry('store_address', data.storeAddress.trim()));

    if (data.ktpPhoto != null) {
      formData.files.add(MapEntry(
          'ktp_photo', await MultipartFile.fromFile(data.ktpPhoto!.path)));
    }
    if (data.facePhoto != null) {
      formData.files.add(MapEntry(
          'face_photo', await MultipartFile.fromFile(data.facePhoto!.path)));
    }
    if (data.farmPhoto != null) {
      formData.files.add(MapEntry(
          'farm_photo', await MultipartFile.fromFile(data.farmPhoto!.path)));
    }
    if (data.storeLogo != null) {
      formData.files.add(MapEntry(
          'store_logo', await MultipartFile.fromFile(data.storeLogo!.path)));
    }

    for (int i = 0; i < data.products.length; i++) {
      final product = data.products[i];
      formData.fields
        ..add(MapEntry('products[$i][name]', product.name.trim()))
        ..add(MapEntry('products[$i][product_category_id]',
            product.productCategoryId.toString()))
        ..add(MapEntry('products[$i][price]', product.price.toString()))
        ..add(MapEntry('products[$i][stock]', product.stock.trim()))
        ..add(
            MapEntry('products[$i][description]', product.description.trim()));

      if (product.photo != null) {
        formData.files.add(MapEntry(
          'products[$i][photo]',
          await MultipartFile.fromFile(product.photo!.path),
        ));
      }
    }

    try {
      final response = await dio.post(
        uri,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('--- Respon dari Server ---');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Pendaftaran petani berhasil dikirim.');
        // ✅ PERBAIKAN DI SINI: Kembalikan respons yang berhasil
        return response.data;
      } else {
        // ✅ PERBAIKAN DI SINI: Jika status code tidak berhasil, lempar exception
        throw Exception(
            response.data?['message'] ?? 'Gagal mengirim pendaftaran.');
      }
    } on DioException catch (e) {
      print('Exception during submitFarmerApplication: ${e.response?.data}');
      // Jika ada respons dari server, gunakan pesan errornya
      if (e.response != null && e.response!.data != null) {
        throw Exception(
            e.response!.data['message'] ?? 'Terjadi kesalahan pada server.');
      }
      rethrow;
    }
  }
}
