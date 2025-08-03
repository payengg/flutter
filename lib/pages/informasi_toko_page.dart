import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/upload_produk_page.dart';
import 'package:terraserve_app/providers/farmer_application_provider.dart';

class InformasiTokoPage extends StatefulWidget {
  const InformasiTokoPage({super.key});

  @override
  State<InformasiTokoPage> createState() => _InformasiTokoPageState();
}

class _InformasiTokoPageState extends State<InformasiTokoPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaTokoController;
  late final TextEditingController _jenisProdukController;
  late final TextEditingController _deskripsiTokoController;
  late final TextEditingController _alamatTokoController;

  File? _logoToko;
  bool _setujuSyarat = false;

  @override
  void initState() {
    super.initState();
    // Mengambil data dari provider jika sudah ada
    final provider =
        Provider.of<FarmerApplicationProvider>(context, listen: false);
    _namaTokoController =
        TextEditingController(text: provider.applicationData.storeName);
    _jenisProdukController =
        TextEditingController(text: provider.applicationData.productType);
    _deskripsiTokoController =
        TextEditingController(text: provider.applicationData.storeDescription);
    _alamatTokoController =
        TextEditingController(text: provider.applicationData.storeAddress);
    _logoToko = provider.applicationData.storeLogo;
  }

  @override
  void dispose() {
    _namaTokoController.dispose();
    _jenisProdukController.dispose();
    _deskripsiTokoController.dispose();
    _alamatTokoController.dispose();
    super.dispose();
  }

  Future<void> _ambilLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _logoToko = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harap isi semua kolom yang wajib diisi.')),
      );
      return;
    }

    if (_logoToko == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap unggah logo toko Anda.')),
      );
      return;
    }

    if (!_setujuSyarat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda harus menyetujui Syarat & Ketentuan.')),
      );
      return;
    }

    final provider =
        Provider.of<FarmerApplicationProvider>(context, listen: false);

    // Memanggil metode updateStoreData yang sudah disesuaikan
    provider.updateStoreData(
      storeName: _namaTokoController.text,
      productType: _jenisProdukController.text,
      storeDescription: _deskripsiTokoController.text,
      storeAddress: _alamatTokoController.text,
      storeLogo: _logoToko!,
    );

    // Navigasi ke halaman selanjutnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadProdukPage()),
    );
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepper(),
                const SizedBox(height: 24),
                _buildTextFormField(
                  controller: _namaTokoController,
                  label: 'Nama Toko',
                  hint: 'Masukkan nama toko Anda',
                  validator: (value) =>
                      value!.isEmpty ? 'Nama toko tidak boleh kosong' : null,
                ),
                _buildTextFormField(
                  controller: _jenisProdukController,
                  label: 'Jenis Produk yang Dijual',
                  hint: 'Contoh: Sayuran Organik, Buah-buahan',
                  validator: (value) =>
                      value!.isEmpty ? 'Jenis produk tidak boleh kosong' : null,
                ),
                _buildTextFormField(
                  controller: _deskripsiTokoController,
                  label: 'Deskripsi Toko',
                  hint: 'Jelaskan tentang toko Anda',
                  validator: (value) => value!.isEmpty
                      ? 'Deskripsi toko tidak boleh kosong'
                      : null,
                ),
                _buildTextFormField(
                  controller: _alamatTokoController,
                  label: 'Alamat Lokasi Toko',
                  hint: 'Masukkan alamat lengkap toko',
                  validator: (value) =>
                      value!.isEmpty ? 'Alamat toko tidak boleh kosong' : null,
                ),
                _buildImagePicker(
                  label: 'Logo Toko',
                  fileGambar: _logoToko,
                  onTap: _ambilLogo,
                ),
                const SizedBox(height: 16),
                _buildSyaratKetentuan(),
                const SizedBox(height: 16),
                _buildInfoText(),
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
      ),
    );
  }

  // Widget-widget pembangun UI tetap sama seperti sebelumnya,
  // namun saya perbaiki `_buildStepper` agar statusnya dinamis
  Widget _buildTombolKirim() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF859F3D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('Selanjutnya',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white)),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?)? validator,
  }) {
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
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
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
              _setujuSyarat = value ?? false;
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
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }

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

  Widget _buildStep(
      {required String number,
      required String label,
      bool isActive = false,
      bool isDone = false}) {
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
