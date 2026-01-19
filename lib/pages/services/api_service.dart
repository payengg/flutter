// File: lib/pages/services/api_service.dart

import 'dart:convert';
<<<<<<< HEAD
import 'package:http/http.dart'
    as http; // Masih diperlukan untuk updateProfile dan fetchUser
=======
import 'package:http/http.dart' as http;
>>>>>>> 27f823c514beaffddb5177255c7eeab7585d42e7
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:terraserve_app/pages/models/user.dart';
import 'package:dio/dio.dart';
import 'package:terraserve_app/pages/models/application_data.dart';

class ApiService {
  // Ganti URL sesuai konfigurasi backend kamu (localhost untuk emulator biasanya 10.0.2.2)
  static final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://10.0.2.2:8000/api';

  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  // 1. UPDATE PROFILE (Sudah diperbaiki jumlah parameternya)
  static Future<bool> updateProfile(
    String name,
    String email,
    String phone,
    String address,
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
          'address': address, // Mengirim alamat ke backend
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

  // 2. FETCH USER (DENGAN DEBUGGING / MATA-MATA)
  static Future<User?> fetchUser(String token) async {
    final url = Uri.parse('$baseUrl/user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      // 🔥🔥 DEBUGGING: LIHAT DATA MENTAH DARI SERVER DISINI 🔥🔥
      print("==========================================");
      print("STATUS CODE: ${response.statusCode}");
      print("RAW BODY API: ${response.body}");
      print("==========================================");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonMap = json.decode(response.body);
        if (jsonMap.containsKey('data')) {
          // Parsing JSON ke Model User
          return User.fromJson(jsonMap['data']);
        } else {
          print('Unexpected response format: $jsonMap');
          return null;
        }
      } else {
        print('Failed to fetch user: ${response.body}');
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // 3. SUBMIT FARMER APPLICATION (Menggunakan DIO untuk upload file)
  static Future<Map<String, dynamic>> submitFarmerApplication(
    FarmerApplicationData data,
    String token,
  ) async {
    final uri = '$baseUrl/farmer-applications';

    // Debugging path file sebelum upload
    print('--- Debugging File Paths ---');
    print('ktpPhoto: ${data.ktpPhoto?.path}');
    print('facePhoto: ${data.facePhoto?.path}');
    print('farmPhoto: ${data.farmPhoto?.path}');
    print('storeLogo: ${data.storeLogo?.path}');
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
        return response.data;
      } else {
        throw Exception(
            response.data?['message'] ?? 'Gagal mengirim pendaftaran.');
      }
    } on DioException catch (e) {
      print('Exception during submitFarmerApplication: ${e.response?.data}');
      if (e.response != null && e.response!.data != null) {
        throw Exception(
            e.response!.data['message'] ?? 'Terjadi kesalahan pada server.');
      }
      rethrow;
    }
  }
}
