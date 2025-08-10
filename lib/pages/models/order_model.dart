// lib/models/order_model.dart

// Enum untuk merepresentasikan status pesanan
enum OrderStatus { diproses, terkirim, dibatalkan }

// Model atau "cetakan data" untuk sebuah pesanan
class Order {
  final String id;
  final String productName;
  final String quantity;
  final String imageUrl;
  final OrderStatus status;
  final double? price; // Harga opsional, hanya untuk yang dibatalkan

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.imageUrl,
    required this.status,
    this.price,
  });
}
