import 'package:flutter_dotenv/flutter_dotenv.dart';

// Ambil BASE_URL dari .env, jika tidak ada, gunakan string kosong
final String baseUrl = dotenv.env['BASE_URL'] ?? '';