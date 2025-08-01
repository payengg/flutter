// File: lib/pages/upload_produk_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/akun_page.dart';
import 'package:terraserve_app/pages/dashboard_pages.dart';
import 'package:terraserve_app/pages/models/application_data.dart';
import 'package:terraserve_app/pages/models/product_category_model.dart';
import 'package:terraserve_app/pages/pendaftaran_sukses_page.dart';
import 'package:terraserve_app/providers/farmer_application_provider.dart';
import 'package:terraserve_app/pages/services/api_service.dart';
import 'package:terraserve_app/pages/models/user.dart'; // ✅ Pastikan import ini ada

class UploadProdukPage extends StatefulWidget {
  const UploadProdukPage({super.key});

  @override
  State<UploadProdukPage> createState() => _UploadProdukPageState();
}

class _UploadProdukPageState extends State<UploadProdukPage> {
  final _formKey = GlobalKey<FormState>();

  File? _fotoProduk;
  int? _kategoriTerpilihId;

  final TextEditingController _namaProdukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKategori();
    // Panggil method clearProducts dari provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FarmerApplicationProvider>(context, listen: false)
          .clearProducts();
    });
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // Metode untuk memuat kategori dari provider
  Future<void> _loadKategori() async {
    final provider =
        Provider.of<FarmerApplicationProvider>(context, listen: false);
    await provider.fetchProductCategories();
  }

  Future<void> _ambilFotoProduk() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _fotoProduk = File(pickedFile.path);
      });
    }
  }

  void _tambahProduk() {
    if (!_formKey.currentState!.validate() ||
        _fotoProduk == null ||
        _kategoriTerpilihId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Harap isi semua field produk dan tambahkan foto.'),
      ));
      return;
    }

    // Buat objek ProductData dari input
    final productData = ProductData(
      name: _namaProdukController.text,
      productCategoryId: _kategoriTerpilihId!,
      price: int.tryParse(_hargaController.text) ?? 0,
      stock: _stokController.text, // Pastikan tipe data sesuai model
      description: _deskripsiController.text,
      photo: _fotoProduk!,
    );

    // Tambahkan produk ke provider
    Provider.of<FarmerApplicationProvider>(context, listen: false)
        .addProduct(productData);

    // Reset form setelah produk ditambahkan
    setState(() {
      _namaProdukController.clear();
      _hargaController.clear();
      _stokController.clear();
      _deskripsiController.clear();
      _fotoProduk = null;
      _kategoriTerpilihId = null;
      _formKey.currentState?.reset();
      FocusScope.of(context).unfocus();
    });
  }

  // ✅ PERBAIKAN TOTAL PADA METODE SUBMIT
  Future<void> _submitApplication() async {
    final provider =
        Provider.of<FarmerApplicationProvider>(context, listen: false);

    if (provider.products.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap tambahkan minimal satu produk.')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Ambil token dari storage
      final token = await ApiService.storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      // 2. Kirim data pendaftaran ke server
      await provider.submitApplicationToServer(token);

      // 3. Ambil data user yang baru saja terdaftar/diupdate dari server
      final User? user = await ApiService.fetchUser(token);

      // ✅ PERBAIKAN: Pastikan data user tidak null sebelum navigasi.
      if (user == null) {
        throw Exception('Gagal mengambil data pengguna setelah pendaftaran.');
      }

      // 4. Reset data provider sebelum navigasi
      provider.resetData();

      // 5. Navigasi ke halaman sukses dan TUNGGU hingga di-pop.
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PendaftaranSuksesPage(),
        ),
      );

      // 6. Setelah user kembali dari halaman sukses, BARU navigasi ke Dashboard
      //    dengan data user yang sudah divalidasi.
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AkunPage(
                    user: user,
                    token: token,
                  )),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pendaftaran: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<FarmerApplicationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            const SizedBox(height: 24),
            Text(
              "Tambahkan Produk Anda",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Tambahkan minimal satu produk sebagai contoh untuk ditampilkan di toko Anda.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'Nama Produk',
                    hint: 'Contoh: Cabai Merah Keriting',
                    controller: _namaProdukController,
                    validator: (v) =>
                        v!.isEmpty ? 'Nama produk wajib diisi' : null,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: _buildDropdownKategori(
                              productProvider.productCategories)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: 'Harga per Kg',
                          hint: 'Contoh: 20000',
                          controller: _hargaController,
                          isNumber: true,
                          validator: (v) =>
                              v!.isEmpty ? 'Harga wajib diisi' : null,
                        ),
                      ),
                    ],
                  ),
                  _buildTextField(
                    label: 'Stok Tersedia',
                    hint: 'Contoh: 50 kg',
                    controller: _stokController,
                    validator: (v) => v!.isEmpty ? 'Stok wajib diisi' : null,
                  ),
                  _buildTextField(
                    label: 'Deskripsi Produk',
                    hint: 'Jelaskan tentang produk Anda',
                    controller: _deskripsiController,
                    maxLines: 3,
                    validator: (v) =>
                        v!.isEmpty ? 'Deskripsi wajib diisi' : null,
                  ),
                  _buildImagePicker(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTambahProdukButton(),
            const SizedBox(height: 24),
            _buildProductList(productProvider.products),
            const SizedBox(height: 24),
            _buildTombolKirim(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Jika Anda menghadapi kesulitan, silahkan hubungi kami',
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //... (Widget lainnya tidak berubah)

  AppBar _buildAppBar() => AppBar(
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
      );

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

  Widget _buildStep({
    required String number,
    required String label,
    bool isActive = false,
    bool isDone = false,
  }) {
    final color = isActive || isDone ? const Color(0xFF859F3D) : Colors.grey;
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: isDone
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : Text(number,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    int? maxLines,
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w600),
              children: const [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
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
            validator: validator,
          ),
        ],
      ),
    );
  }

  // Perbaikan di sini: Gunakan langsung data dari provider
  Widget _buildDropdownKategori(List<ProductCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Kategori Produk',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.w600),
            children: const [
              TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _kategoriTerpilihId,
          hint: Text('Pilih Kategori',
              style: GoogleFonts.poppins(color: Colors.grey[400])),
          onChanged: (int? newValue) {
            setState(() {
              _kategoriTerpilihId = newValue;
            });
          },
          items: categories.map<DropdownMenuItem<int>>((category) {
            return DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.name, style: GoogleFonts.poppins()),
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value == null ? 'Kategori wajib dipilih' : null,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Foto Produk',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.w600),
            children: const [
              TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: _ambilFotoProduk,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!)),
                child: _fotoProduk == null
                    ? Icon(Icons.add_photo_alternate_outlined,
                        color: Colors.grey[600], size: 30)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_fotoProduk!,
                            width: 80, height: 80, fit: BoxFit.cover),
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Hanya dapat mengupload 1 foto per produk.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProductList(List<ProductData> products) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            "Belum ada produk yang ditambahkan.",
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...products.map((produk) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file((produk.photo!),
                        width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(produk.name,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                        Text("Rp ${produk.price} / kg",
                            style:
                                GoogleFonts.poppins(color: Colors.grey[700])),
                        Text("Stok: ${produk.stock}",
                            style: GoogleFonts.poppins(
                                color: Colors.grey[700], fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildTambahProdukButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.add),
        label: Text("Tambah Produk ke Daftar",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        onPressed: _tambahProduk,
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: const Color(0xFF859F3D),
            side: const BorderSide(color: Color(0xFF859F3D)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  Widget _buildTombolKirim() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF859F3D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text('Kirim Pendaftaran',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white)),
      ),
    );
  }
}
