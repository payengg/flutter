// lib/pages/services/navigation_service.dart

import 'package:flutter/material.dart';

class NavigationService with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Memberi tahu widget lain bahwa ada perubahan
  }
}
