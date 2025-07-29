// lib/pages/informasi_toko_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// 1. Import halaman baru
import 'package:terraserve_app/pages/upload_produk_page.dart';

class InformasiTokoPage extends StatefulWidget {
  const InformasiTokoPage({super.key});

  @override
  State<InformasiTokoPage> createState() => _InformasiTokoPageState();
}

class _InformasiTokoPageState extends State<InformasiTokoPage> {
  File? _logoToko;
  bool _setujuSyarat = false;

  Future<void> _ambilLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _logoToko = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'INFORMASI TOKO',
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              const SizedBox(height: 24),
              _buildTextField(label: 'Nama Toko', hint: 'Masukan nama anda'),
              _buildTextField(
                  label: 'Jenis Produk yang Dijual',
                  hint: 'Masukan nama anda'),
              _buildTextField(
                  label: 'Deskripsi Toko', hint: 'Masukan alamat lahan anda'),
              _buildTextField(
                  label: 'Alamat Lokasi Toko',
                  hint: 'Masukan Luas Lahan & Status'),
              _buildImagePicker(
                  label: 'Logo Toko',
                  fileGambar: _logoToko,
                  onTap: _ambilLogo),
              const SizedBox(height: 16),
              _buildSyaratKetentuan(),
              const SizedBox(height: 16),
              _buildInfoText(),
              const SizedBox(height: 24),
              // 2. Perbarui pemanggilan fungsi tombol kirim
              _buildTombolKirim(context),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Jika Anda menghadapi kesulitan, silahkan hubungi kami',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Tombol Kirim sekarang menerima context
  Widget _buildTombolKirim(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Aksi navigasi ke halaman Upload Produk
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadProdukPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF859F3D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('Kirim',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white)),
      ),
    );
  }

  // --- Widget-widget lain tidak berubah ---
  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStep(number: '1', label: 'Verifikasi Identitas', isDone: true),
        _buildStep(number: '2', label: 'Informasi Toko', isActive: true),
        _buildStep(number: '3', label: 'Upload Produk', isDone: false),
      ],
    );
  }

  Widget _buildStep({required String number, required String label, bool isActive = false, bool isDone = false}) {
    final color = isActive || isDone ? const Color(0xFF859F3D) : Colors.grey;
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: isDone
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : Text(
                  number,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600),
              children: const [
                TextSpan(text: '*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF859F3D)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(
      {required String label,
      required File? fileGambar,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: fileGambar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(fileGambar, fit: BoxFit.cover),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              color: Colors.grey[400], size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Ketuk untuk memilih gambar',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyaratKetentuan() {
    return Row(
      children: [
        Checkbox(
          value: _setujuSyarat,
          onChanged: (bool? value) {
            setState(() {
              _setujuSyarat = value!;
            });
          },
          activeColor: const Color(0xFF859F3D),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'Saya menyetujui ',
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
              children: [
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF1D65AE),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    return Text.rich(
      TextSpan(
        text: 'Dengan mengisi dan melengkapi data, berarti telah '
            'membaca dan menyetujui Syarat & Ketentuan berikut:\n',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
        children: const [
          TextSpan(
              text:
                  '1. Data yang diisi harus valid, sesuai identitas asli dan kondisi lahan sebenarnya.\n'),
          TextSpan(
              text:
                  '2. Akun hanya digunakan untuk keperluan aktivitas pertanian di platform Terraserve.\n'),
          TextSpan(
              text:
                  '3. Jika ditemukan pelanggaran seperti data palsu atau penyalahgunaan akun, '
                  'akses dapat dibekukan atau dihentikan.'),
        ],
      ),
    );
  }
}
