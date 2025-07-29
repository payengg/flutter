// lib/pages/upload_produk_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// 1. Import halaman baru
import 'package:terraserve_app/pages/pendaftaran_sukses_page.dart';

// Model sederhana untuk data produk
class Produk {
  final String nama;
  final String harga;
  final List<File> gambar; // Diubah dari File menjadi List<File>

  Produk({required this.nama, required this.harga, required this.gambar});
}

class UploadProdukPage extends StatefulWidget {
  const UploadProdukPage({super.key});

  @override
  State<UploadProdukPage> createState() => _UploadProdukPageState();
}

class _UploadProdukPageState extends State<UploadProdukPage> {
  final List<File> _fotoProduk = [];
  String? _kategoriTerpilih;
  final List<String> _kategoriList = ['Sayuran', 'Buah-buahan', 'Rempah', 'Umbi-umbian'];
  final List<Produk> _daftarProduk = [];

  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  Future<void> _ambilFotoProduk() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _fotoProduk.add(File(pickedFile.path));
      });
    }
  }
  
  void _tambahProduk() {
    // Validasi input sebelum menambahkan produk
    if (_namaProdukController.text.isNotEmpty && 
        _hargaController.text.isNotEmpty && 
        _fotoProduk.isNotEmpty &&
        _kategoriTerpilih != null) {
      setState(() {
        _daftarProduk.add(
          Produk(
            nama: _namaProdukController.text,
            harga: 'Rp ${_hargaController.text}/kg',
            // Simpan SEMUA foto yang dipilih
            gambar: List.from(_fotoProduk), 
          ),
        );
        // Reset fields untuk input produk selanjutnya
        _namaProdukController.clear();
        _hargaController.clear();
        _stokController.clear();
        _deskripsiController.clear();
        _fotoProduk.clear();
        _kategoriTerpilih = null;
      });
    } else {
      // Tampilkan pesan jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field yang wajib diisi dan tambahkan foto.'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'UPLOAD PRODUK',
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              const SizedBox(height: 24),
              _buildTextField(label: 'Nama Produk', hint: 'Contoh: Cabai Merah Keriting', controller: _namaProdukController),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDropdownKategori()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(label: 'Harga per Kg/Paket', hint: 'Contoh: 20000', controller: _hargaController, isNumber: true)),
                ],
              ),
              _buildTextField(label: 'Stok Tersedia', hint: 'Contoh: 50 kg', controller: _stokController),
              _buildTextField(label: 'Deskripsi Produk', hint: 'Jelaskan tentang produk Anda', maxLines: 3, controller: _deskripsiController),
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildProductList(),
              const SizedBox(height: 16),
              _buildTambahProdukButton(),
              const SizedBox(height: 24),
              _buildTombolKirim(),
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

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStep(number: '1', label: 'Verifikasi Identitas', isDone: true),
        _buildStep(number: '2', label: 'Informasi Toko', isDone: true),
        _buildStep(number: '3', label: 'Upload Produk', isActive: true),
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
  
  Widget _buildTextField({required String label, required String hint, int? maxLines, TextEditingController? controller, bool isNumber = false}) {
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
            controller: controller,
            maxLines: maxLines ?? 1,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  Widget _buildDropdownKategori() {
     return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Kategori Produk',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600),
              children: const [
                TextSpan(text: '*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _kategoriTerpilih,
            hint: Text('Pilih Kategori', style: GoogleFonts.poppins(color: Colors.grey[400])),
            onChanged: (String? newValue) {
              setState(() {
                _kategoriTerpilih = newValue!;
              });
            },
            items: _kategoriList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
               border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Foto Produk',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600),
              children: const [
                TextSpan(text: '*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _ambilFotoProduk,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Icon(Icons.add, color: Colors.grey[600], size: 30),
                  ),
                ),
                const SizedBox(width: 10),
                ..._fotoProduk.map((file) => Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                  ),
                )).toList(),
              ],
            ),
          ),
           const SizedBox(height: 8),
           Text('Pastikan gambar jelas dan produk terlihat utuh', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         RichText(
            text: TextSpan(
              text: 'Produk',
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600),
              children: const [
                TextSpan(text: '*', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ..._daftarProduk.map((produk) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (produk.gambar.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(produk.gambar.first, width: 60, height: 60, fit: BoxFit.cover),
                ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produk.nama, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  Text(produk.harga, style: GoogleFonts.poppins(color: Colors.grey[700])),
                ],
              )
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildTambahProdukButton() {
    return GestureDetector(
      onTap: _tambahProduk,
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: const Color(0xFF859F3D)),
          const SizedBox(width: 8),
          Text(
            'Tambah Produk',
            style: GoogleFonts.poppins(
                color: const Color(0xFF859F3D), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTombolKirim() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // 2. Arahkan ke halaman pendaftaran sukses
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PendaftaranSuksesPage()),
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
}
