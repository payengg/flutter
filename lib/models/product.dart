class Product {
  final String name;
  final String desc;
  final String image;
  final String price;
  // 1. Tambahkan variabel unit (nullable)
  final String? unit;

  Product({
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    // 2. Tambahkan di constructor (tidak perlu required karena nullable)
    this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Ambil gambar dari galleries, jika ada
    String imageUrl = '';
    if (json['galleries'] != null &&
        json['galleries'] is List &&
        json['galleries'].isNotEmpty) {
      imageUrl = json['galleries'][0]['url']?.toString() ?? '';
    }

    return Product(
      name: json['name']?.toString() ?? '',
      desc: json['description']?.toString() ?? '',
      image: imageUrl,
      // Format harga menjadi String
      price: json['price']?.toString() ?? '0',
      // 3. Ambil data unit dari JSON (pastikan key-nya sesuai dengan backend, misal 'unit' atau 'weight')
      // Jika di JSON tidak ada key 'unit', dia akan otomatis null
      unit: json['unit']?.toString(),
    );
  }
}
