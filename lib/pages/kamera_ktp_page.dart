// lib/pages/kamera_ktp_page.dart (Contoh)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terraserve_app/pages/konfirmasi_ktp_page.dart';

class KameraKtpPage extends StatefulWidget {
  const KameraKtpPage({super.key});

  @override
  State<KameraKtpPage> createState() => _KameraKtpPageState();
}

class _KameraKtpPageState extends State<KameraKtpPage> {
  @override
  void initState() {
    super.initState();
    _ambilDanKonfirmasiFoto();
  }

  Future<void> _ambilDanKonfirmasiFoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null || !mounted) {
      Navigator.pop(context); // Batal, kembali ke instruksi
      return;
    }

    // Buka halaman konfirmasi dan TUNGGU hasilnya.
    final hasilKonfirmasi = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (context) => KonfirmasiKtpPage(imagePath: pickedFile.path),
      ),
    );

    // Jika ada hasil dari konfirmasi, oper ke halaman sebelumnya (InstruksiKtpPage).
    if (hasilKonfirmasi != null && mounted) {
      Navigator.pop(context, hasilKonfirmasi);
    } else if (mounted) {
      Navigator.pop(context); // User menekan "Coba Lagi"
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
