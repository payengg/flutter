import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terraserve_app/config/api.dart';
import 'package:terraserve_app/pages/models/banner_model.dart';

class BannerService {
  Future<List<BannerModel>> getBanners() async {
    final url = Uri.parse('$baseUrl/dashboard-banners');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((item) => BannerModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching banners: $e');
      rethrow;
    }
  }
}
