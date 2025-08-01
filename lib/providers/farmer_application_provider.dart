// File: lib/pages/providers/farmer_application_provider.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:terraserve_app/pages/models/application_data.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/services/product_category_service.dart';
import 'package:terraserve_app/pages/services/api_service.dart';

class FarmerApplicationProvider with ChangeNotifier {
  final ProductCategoryService _categoryService = ProductCategoryService();
  final FarmerApplicationData _applicationData = FarmerApplicationData();

  List<ProductCategory> _productCategories = [];
  bool _isLoadingCategories = false;
  String? _categoryError;

  // Getter untuk mengakses data dari luar provider
  FarmerApplicationData get applicationData => _applicationData;
  List<ProductCategory> get productCategories => _productCategories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoryError => _categoryError;
  List<ProductData> get products => _applicationData.products;

  // Tambahkan getter untuk userId
  int? get userId => _applicationData.userId;

  // Method baru untuk mengatur user ID setelah login
  void setUserId(int id) {
    _applicationData.userId = id;
    notifyListeners();
  }

  // Method untuk mengambil data kategori dari API
  Future<void> fetchProductCategories() async {
    _isLoadingCategories = true;
    _categoryError = null;
    notifyListeners();

    try {
      _productCategories = await _categoryService.getAllCategories();
    } catch (e) {
      _categoryError = e.toString();
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // ... (Metode updatePersonalData, updateStoreData, addProduct, clearProducts sama) ...
  void updatePersonalData({
    required String fullName,
    required String nik,
    required String farmAddress,
    required String landSizeStatus,
    required File ktpPhoto,
    required File farmPhoto,
    required File facePhoto,
  }) {
    _applicationData.fullName = fullName;
    _applicationData.nik = nik;
    _applicationData.farmAddress = farmAddress;
    _applicationData.landSizeStatus = landSizeStatus;
    _applicationData.ktpPhoto = ktpPhoto;
    _applicationData.farmPhoto = farmPhoto;
    _applicationData.facePhoto = facePhoto;
    notifyListeners();
  }

  void updateStoreData({
    required String storeName,
    required String productType,
    required String storeDescription,
    required String storeAddress,
    required File storeLogo,
  }) {
    _applicationData.storeName = storeName;
    _applicationData.productType = productType;
    _applicationData.storeDescription = storeDescription;
    _applicationData.storeAddress = storeAddress;
    _applicationData.storeLogo = storeLogo;
    notifyListeners();
  }

  void addProduct(ProductData product) {
    _applicationData.products.add(product);
    notifyListeners();
  }

  void clearProducts() {
    _applicationData.products.clear();
    notifyListeners();
  }

  // ✅ PERBAIKAN DI SINI: Tangkap hasil pengembalian dan kembalikan
  Future<Map<String, dynamic>> submitApplicationToServer(String token) async {
    if (_applicationData.userId == null ||
        _applicationData.fullName.isEmpty ||
        _applicationData.nik.isEmpty ||
        _applicationData.ktpPhoto == null ||
        _applicationData.storeName.isEmpty ||
        _applicationData.storeLogo == null ||
        _applicationData.products.isEmpty) {
      throw Exception('Data pendaftaran tidak lengkap.');
    }

    try {
      // ✅ Tangkap hasil pengembalian dari ApiService
      final response =
          await ApiService.submitFarmerApplication(_applicationData, token);

      // ✅ Kembalikan respons yang sudah ditangkap
      return response;
    } catch (e) {
      rethrow;
    }
  }

  void resetData() {
    _applicationData.fullName = '';
    _applicationData.nik = '';
    _applicationData.farmAddress = '';
    _applicationData.landSizeStatus = '';
    _applicationData.ktpPhoto = null;
    _applicationData.farmPhoto = null;
    _applicationData.facePhoto = null;
    _applicationData.storeName = '';
    _applicationData.productType = '';
    _applicationData.storeDescription = '';
    _applicationData.storeAddress = '';
    _applicationData.storeLogo = null;
    _applicationData.products = [];
    notifyListeners();
  }
}
