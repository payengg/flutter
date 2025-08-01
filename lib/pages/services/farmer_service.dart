import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:terraserve_app/config/api.dart';
import 'package:terraserve_app/pages/services/storage_service.dart';

class FarmerService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<void> submitStoreInfo({
    required String storeName,
    required String storeDescription,
    File? logoFile,
  }) async {
    final url = '$baseUrl/farmer-applications/store-info';
    final token = await StorageService().getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final formData = FormData();

    formData.fields.addAll([
      MapEntry('store_name', storeName),
      MapEntry('store_description', storeDescription),
    ]);

    if (logoFile != null && await logoFile.exists()) {
      final fileName = logoFile.path.split(Platform.pathSeparator).last;
      final multipartLogo = await MultipartFile.fromFile(
        logoFile.path,
        filename: fileName,
      );
      formData.files.add(MapEntry('store_logo', multipartLogo));
    }

    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ Informasi toko berhasil dikirim: ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ Gagal kirim informasi toko: ${e.response?.data}');
      throw Exception('Gagal kirim informasi toko');
    }
  }

  Future<Map<String, dynamic>> submitApplication(
    Map<String, dynamic> jsonData,
    Map<String, String> filePaths,
  ) async {
    final url = '$baseUrl/farmer-applications';

    final token = await StorageService().getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final formData = FormData();

    // ✅ Tambahkan JSON utama sebagai field
    final jsonPayload = jsonEncode(jsonData);
    formData.fields.add(MapEntry('json_payload', jsonPayload));
    print('📝 JSON Payload: $jsonPayload');

    // ✅ Tambahkan file dari filePaths
    for (final entry in filePaths.entries) {
      final key = entry.key;
      final path = entry.value;

      if (path.isNotEmpty) {
        final file = File(path);
        final exists = await file.exists();

        if (exists) {
          final fileName = path.split(Platform.pathSeparator).last;
          try {
            final multipartFile = await MultipartFile.fromFile(
              path,
              filename: fileName,
            );
            formData.files.add(MapEntry(key, multipartFile));
            print('📎 File ditambahkan: $key → $fileName');
          } catch (e) {
            print('❌ Gagal membuat MultipartFile untuk "$key": $e');
          }
        } else {
          print('⚠️ File "$key" tidak ditemukan: $path');
        }
      } else {
        print('⚠️ Path kosong untuk file "$key".');
      }
    }

    // ✅ Kirim ke server
    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ Pendaftaran berhasil: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorData = e.response?.data;

      print('❌ Gagal mengirim. Status: $statusCode');
      print('🧾 Detail error: $errorData');
      print('📤 Data yang dikirim: $jsonData');
      print('📁 File paths: ${filePaths.toString()}');

      throw Exception(
        'Gagal mengirim pendaftaran: ${errorData?['message'] ?? 'Kesalahan tidak diketahui'}',
      );
    } catch (e) {
      print('❗ Terjadi kesalahan tak terduga: $e');
      rethrow;
    }
  }
}
