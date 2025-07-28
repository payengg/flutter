// lib/pages/services/favorite_service.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService with ChangeNotifier {
  final List<int> _favoriteProductIds = [];
  static const _prefKey = 'favorite_ids';

  FavoriteService() {
    _loadFavorites();
  }

  List<int> get favoriteProductIds => _favoriteProductIds;

  // Fungsi untuk memuat ID favorit dari penyimpanan lokal
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsStringList = prefs.getStringList(_prefKey) ?? [];
    _favoriteProductIds.clear();
    for (var idString in favoriteIdsStringList) {
      _favoriteProductIds.add(int.parse(idString));
    }
    notifyListeners();
  }

  // Fungsi untuk menyimpan ID favorit ke penyimpanan lokal
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsStringList = _favoriteProductIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_prefKey, favoriteIdsStringList);
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (isFavorite(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    _saveFavorites(); // Simpan setiap kali ada perubahan
    notifyListeners(); // Beri tahu UI bahwa ada perubahan
  }
}