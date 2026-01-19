import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  int _stock = 100;
  String? _category;
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, String>> _addedProducts = [];

  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _images.add(picked);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _submit() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Produk dikirim')));
  }

  void _addProduct() {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Silakan unggah foto produk terlebih dahulu')));
      return;
    }
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama dan harga wajib diisi')));
      return;
    }

    _addedProducts.add({
      'name': _nameController.text,
      'price': _priceController.text,
      'image': _images.first.path,
    });

    setState(() {
      _nameController.clear();
      _priceController.clear();
      _descController.clear();
      _images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tinggi status bar (area jam & sinyal)
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Set top: false agar konten bisa naik ke area status bar
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER CUSTOM (Mentok Atas) ---
              Container(
                color: Colors.white,
                // Padding atas ditambah statusBarHeight agar tulisan aman tidak ketutup jam
                padding: EdgeInsets.only(
                    top: statusBarHeight + 12, bottom: 12, left: 8, right: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black87),
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Tambah Produk Baru',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // Penyeimbang agar judul tetap di tengah
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // -----------------------------------

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nama Produk*'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                        hintText: 'Nama produk',
                        counterText: '${_nameController.text.length}/50',
                      ),
                      maxLength: 50,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Kategori Produk*'),
                              const SizedBox(height: 8),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: DropdownButton<String>(
                                  value: _category,
                                  isExpanded: true,
                                  underline: const SizedBox.shrink(),
                                  hint: Text('Pilih Kategori',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey)),
                                  items: ['Sayur', 'Buah', 'Umbi', 'Rempah']
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _category = v),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Harga per Kg/Paket*'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  hintText: 'Masukkan Harga',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _label('Stok Tersedia*'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => setState(
                                () => _stock = (_stock - 1).clamp(0, 99999)),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('$_stock',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => setState(
                                () => _stock = (_stock + 1).clamp(0, 99999)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _label('Deskripsi Produk'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      maxLines: 6,
                      maxLength: 500,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                        hintText: 'Deskripsi produk',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _label('Foto Produk*'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                              width: 1),
                        ),
                        child: _images.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined,
                                        size: 28, color: Colors.grey.shade400),
                                    const SizedBox(height: 6),
                                    Text('Silakan unggah foto produk Anda',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey.shade500)),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  GridView.builder(
                                    padding: const EdgeInsets.all(12),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8),
                                    itemCount: _images.length,
                                    itemBuilder: (context, index) {
                                      final file = File(_images[index].path);
                                      return Stack(
                                        children: [
                                          Positioned.fill(
                                              child: Image.file(file,
                                                  fit: BoxFit.cover)),
                                          Positioned(
                                            right: 4,
                                            top: 4,
                                            child: GestureDetector(
                                                onTap: () =>
                                                    _removeImage(index),
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Colors.black54,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: const Icon(
                                                        Icons.close,
                                                        size: 12,
                                                        color: Colors.white))),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Pastikan gambar jelas dan produk terlihat utuh',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    _label('Produk*'),
                    const SizedBox(height: 8),
                    if (_images.isNotEmpty && _addedProducts.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: FileImage(File(_images.first.path)),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      _nameController.text.isEmpty
                                          ? 'Nama Produk'
                                          : _nameController.text,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                      _priceController.text.isEmpty
                                          ? 'Rp - /kg'
                                          : 'Rp ${_priceController.text}/kg',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey),
                          ],
                        ),
                      )
                    else if (_addedProducts.isNotEmpty)
                      Column(
                        children: _addedProducts.reversed.map((p) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: FileImage(File(p['image']!)),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p['name'] ?? '',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text('Rp ${p['price']}/kg',
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _addedProducts.remove(p)),
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child:
                                  const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Belum ada produk',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _addProduct,
                      icon: const Icon(Icons.add, color: Color(0xFF389841)),
                      label: Text('Tambah Produk',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF389841))),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF389841),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Kirim',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600));
}
