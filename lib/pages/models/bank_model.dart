// lib/models/bank_model.dart

class Bank {
  // 1. Properti/informasi yang wajib ada untuk setiap bank.
  // 'final' berarti nilainya tidak bisa diubah setelah dibuat.
  final String name;
  final String logoAsset;

  // 2. Constructor: Cara untuk membuat sebuah objek 'Bank' baru.
  // 'required' berarti saat membuat Bank, kita wajib mengisi 'name' dan 'logoAsset'.
  Bank({
    required this.name,
    required this.logoAsset,
  });
}