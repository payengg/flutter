import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/informasi_toko_page.dart';
import 'package:terraserve_app/pages/instruksi_ktp_page.dart';
import 'package:terraserve_app/providers/farmer_application_provider.dart';

class FormIdentitasPage extends StatefulWidget {
  const FormIdentitasPage({super.key});

  @override
  State<FormIdentitasPage> createState() => _FormIdentitasPageState();
}

class _FormIdentitasPageState extends State<FormIdentitasPage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Definisikan warna utama di sini agar mudah diubah
  final Color _primaryGreen = const Color(0xFF389841);

  late final TextEditingController _namaController;
  late final TextEditingController _nikController;
  late final TextEditingController _alamatController;
  late final TextEditingController _luasController;

  File? _fotoKTP;
  File? _fotoLahan;
  File? _fotoWajah;
  bool _setujuSyarat = false;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<FarmerApplicationProvider>(context, listen: false);
    _namaController =
        TextEditingController(text: provider.applicationData.fullName);
    _nikController = TextEditingController(text: provider.applicationData.nik);
    _alamatController =
        TextEditingController(text: provider.applicationData.farmAddress);
    _luasController =
        TextEditingController(text: provider.applicationData.landSizeStatus);

    _fotoKTP = provider.applicationData.ktpPhoto;
    _fotoLahan = provider.applicationData.farmPhoto;
    _fotoWajah = provider.applicationData.facePhoto;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    _luasController.dispose();
    super.dispose();
  }

  Future<void> _mulaiAlurFotoKTP() async {
    final hasil = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (context) => const InstruksiKtpPage()),
    );

    if (hasil != null) {
      setState(() {
        _fotoKTP = hasil;
      });
    }
  }

  Future<void> _pilihFotoLahan() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _fotoLahan = File(pickedFile.path);
      });
    }
  }

  Future<void> _ambilFotoWajah() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _fotoWajah = File(pickedFile.path);
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

    if (_fotoKTP == null || _fotoWajah == null || _fotoLahan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harap unggah semua foto yang diperlukan.')),
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

    provider.updatePersonalData(
      fullName: _namaController.text,
      nik: _nikController.text,
      farmAddress: _alamatController.text,
      landSizeStatus: _luasController.text,
      ktpPhoto: _fotoKTP!,
      farmPhoto: _fotoLahan!,
      facePhoto: _fotoWajah!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InformasiTokoPage()),
    );
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
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama anda',
                  validator: (value) =>
                      value!.isEmpty ? 'Nama lengkap tidak boleh kosong' : null,
                ),
                _buildTextFormField(
                  controller: _nikController,
                  label: 'NIK',
                  hint: 'Masukkan NIK anda',
                  validator: (value) =>
                      value!.isEmpty ? 'NIK tidak boleh kosong' : null,
                ),
                _buildTextFormField(
                  controller: _alamatController,
                  label: 'Alamat Lengkap Lahan',
                  hint: 'Masukkan alamat lahan anda',
                  validator: (value) =>
                      value!.isEmpty ? 'Alamat lahan tidak boleh kosong' : null,
                ),
                _buildTextFormField(
                  controller: _luasController,
                  label: 'Luas Lahan & Status',
                  hint: 'Contoh: 2 Hektar, Milik Sendiri',
                  validator: (value) => value!.isEmpty
                      ? 'Luas lahan & status tidak boleh kosong'
                      : null,
                ),
                _buildImagePicker(
                  label: 'Foto KTP',
                  fileGambar: _fotoKTP,
                  onTap: _mulaiAlurFotoKTP,
                ),
                _buildVerifikasiWajah(),
                _buildImagePicker(
                  label: 'Foto Lahan',
                  fileGambar: _fotoLahan,
                  onTap: _pilihFotoLahan,
                ),
                const SizedBox(height: 16),
                _buildSyaratKetentuan(),
                const SizedBox(height: 16),
                _buildInfoText(),
                const SizedBox(height: 24),
                _buildTombolSelanjutnya(),
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

  Widget _buildTombolSelanjutnya() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          // ✅ UBAH WARNA TOMBOL KE 389841
          backgroundColor: _primaryGreen,
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
                // ✅ UBAH WARNA BORDER FOKUS KE 389841
                borderSide: BorderSide(color: _primaryGreen),
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

  Widget _buildVerifikasiWajah() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Verifikasi Wajah',
                  style: GoogleFonts.poppins(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  children: const [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              TextButton(
                onPressed: _ambilFotoWajah,
                child: Text(
                  'Ambil Foto Wajah >',
                  // ✅ UBAH WARNA TEXT LINK KE 389841
                  style: GoogleFonts.poppins(color: _primaryGreen),
                ),
              )
            ],
          ),
          if (_fotoWajah != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
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
          // ✅ UBAH WARNA CHECKBOX KE 389841
          activeColor: _primaryGreen,
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
        _buildStep(number: '1', label: 'Verifikasi Identitas', isActive: true),
        _buildStep(number: '2', label: 'Informasi Toko', isActive: false),
        _buildStep(number: '3', label: 'Upload Produk', isActive: false),
      ],
    );
  }

  Widget _buildStep(
      {required String number, required String label, required bool isActive}) {
    // ✅ UBAH WARNA STEPPER AKTIF KE 389841
    final color = isActive ? _primaryGreen : Colors.grey;
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
