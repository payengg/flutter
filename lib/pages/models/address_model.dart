// lib/pages/models/address_model.dart

class Address {
  final int id;
  final String street;
  final String city;
  final String recipientName;
  final String phoneNumber;
  final String tag; // 'Rumah', 'Kantor', dll.

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.recipientName,
    required this.phoneNumber,
    required this.tag,
  });
}