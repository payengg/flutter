// lib/services/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/config/api.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    final Uri url = Uri.parse('$baseUrl/products');

    try {
      final response = await http.get(url);

      // Tips Debugging: Cetak respons mentah dari server untuk melihat strukturnya
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // ✅ PERBAIKAN FINAL DI SINI
        // 1. Decode respons sebagai Map (karena ada "meta" dan "data")
        final Map<String, dynamic> body = json.decode(response.body);

        // 2. Ambil list produk dari dalam kunci 'data'
        final List<dynamic> data = body['data'];

        // 3. Ubah list tersebut menjadi List<Product>
        List<Product> products =
            data.map((item) => Product.fromJson(item)).toList();

        return products;
      } else {
        throw Exception(
          'Gagal memuat produk (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error di getProducts: $e');
      throw Exception('Gagal terhubung ke server.');
    }
  }
}
