import 'dart:io';

class ProductData {
  String name;
  int productCategoryId;
  int price;
  String stock;
  String description;
  File? photo;

  ProductData({
    required this.name,
    required this.productCategoryId,
    required this.price,
    required this.stock,
    required this.description,
    this.photo,
  });
}

extension ProductDataExtension on ProductData {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'product_category_id': productCategoryId,
      'price': price,
      'stock': stock,
      'description': description,
      'photo': photo?.path, // ✅ Hanya path-nya
    };
  }
}

class FarmerApplicationData {
  int? userId;
  String fullName = '';
  String nik = '';
  String farmAddress = '';
  String landSizeStatus = '';
  File? ktpPhoto;
  File? facePhoto;
  File? farmPhoto;
  String storeName = '';
  String productType = '';
  String storeDescription = '';
  String storeAddress = '';
  File? storeLogo;
  List<ProductData> products = [];
}

extension FarmerApplicationDataExtension on FarmerApplicationData {
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'nik': nik,
      'farm_address': farmAddress,
      'land_size_status': landSizeStatus,
      'store_name': storeName,
      'product_type': productType,
      'store_description': storeDescription,
      'store_address': storeAddress,
      'products': products.map((product) => product.toJson()).toList(),
      'ktp_photo': ktpPhoto?.path,
      'face_photo': facePhoto?.path,
      'farm_photo': farmPhoto?.path,
      'store_logo': storeLogo?.path,
    };
  }
}
