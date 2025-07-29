// lib/pages/form_identitas_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terraserve_app/pages/instruksi_ktp_page.dart';
// 1. Import halaman baru
import 'package:terraserve_app/pages/informasi_toko_page.dart';

class FormIdentitasPage extends StatefulWidget {
  const FormIdentitasPage({super.key});

  @override
  State<FormIdentitasPage> createState() => _FormIdentitasPageState();
}

class _FormIdentitasPageState extends State<FormIdentitasPage> {
  File? _fotoKTP;
  File? _fotoLahan;
  File? _fotoWajah;
  bool _setujuSyarat = false;

  Future<void> _ambilGambarDariGaleri(Function(File) onFilePilih) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        onFilePilih(File(pickedFile.path));
      });
    }
  }

  Future<void> _mulaiAlurFotoKTP() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InstruksiKtpPage()),
    );

    if (hasil != null && hasil is File) {
      setState(() {
        _fotoKTP = hasil;
      });
    }
  }

  Future<void> _ambilFotoWajah(Function(File) onFilePilih) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        onFilePilih(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'VERIFIKASI IDENTITAS',
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
              _buildTextField(label: 'Nama Lengkap', hint: 'Masukkan nama anda'),
              _buildTextField(label: 'NIK', hint: 'Masukkan NIK anda'),
              _buildTextField(
                  label: 'Alamat Lengkap Lahan',
                  hint: 'Masukkan alamat lahan anda'),
              _buildTextField(
                  label: 'Luas Lahan & Status',
                  hint: 'Contoh: 2 Hektar, Milik Sendiri'),
              _buildImagePicker(
                label: 'Foto KTP',
                fileGambar: _fotoKTP,
                onTap: _mulaiAlurFotoKTP,
              ),
              _buildVerifikasiWajah(),
              _buildImagePicker(
                label: 'Foto Lahan',
                fileGambar: _fotoLahan,
                onTap: () => _ambilGambarDariGaleri((file) => _fotoLahan = file),
              ),
              const SizedBox(height: 16),
              _buildSyaratKetentuan(),
              const SizedBox(height: 16),
              _buildInfoText(),
              const SizedBox(height: 24),
              // 2. Perbarui fungsi tombol kirim
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
          // Aksi navigasi ke halaman Informasi Toko
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InformasiTokoPage()),
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

  Widget _buildVerifikasiWajah() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Verifikasi Wajah',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: () => _ambilFotoWajah((file) => _fotoWajah = file),
                child: Text(
                  'Ambil Foto Wajah >',
                  style: GoogleFonts.poppins(color: const Color(0xFF859F3D)),
                ),
              )
            ],
          ),
          if (_fotoWajah != null)
            Container(
              height: 120,
              width: 120,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(_fotoWajah!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStep(number: '1', label: 'Verifikasi Identitas', isActive: true),
        _buildStep(number: '2', label: 'Informasi Toko', isActive: false),
        _buildStep(number: '3', label: 'Upload Produk', isActive: false),
      ],
    );
  }

  Widget _buildStep(
      {required String number, required String label, required bool isActive}) {
    final color = isActive ? const Color(0xFF859F3D) : Colors.grey;
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: Text(
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
