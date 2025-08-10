import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// 1. Kembalikan import yang diperlukan
import 'package:terraserve_app/pages/services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  // 2. Kembalikan parameter token
  final String token; 
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String? currentGender;
  final String? currentBirthdate;

  const EditProfilePage({
    super.key,
    required this.token,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    this.currentGender,
    this.currentBirthdate,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? _selectedGender;
  final List<String> _genders = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _emailController.text = widget.currentEmail;
    _phoneController.text = widget.currentPhone;
    _dateController.text = widget.currentBirthdate ?? '';

    // Perbaikan untuk DropdownButton tetap ada
    if (widget.currentGender != null && _genders.contains(widget.currentGender)) {
      _selectedGender = widget.currentGender;
    } else {
      _selectedGender = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // --- PERBAIKAN DI SINI ---
  // Mengubah logika update menjadi lebih tangguh dengan try-catch
  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final gender = _selectedGender ?? '';
    final birthdate = _dateController.text.trim();

    try {
      // Panggil API untuk update. Kita asumsikan akan error jika gagal.
      await ApiService.updateProfile(
        name,
        email,
        phone,
        gender,
        birthdate,
        widget.token,
      );

      // Jika kode mencapai baris ini, berarti update berhasil.
      if (mounted) {
        // Kirim data baru kembali ke AkunPage
        final updatedData = {
          'name': name,
          'email': email,
        };
        Navigator.pop(context, updatedData);
      }
    } catch (e) {
      // Jika terjadi error saat memanggil API, tampilkan pesan.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memperbarui profil. Coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // --- AKHIR PERBAIKAN ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const NetworkImage('https://i.pravatar.cc/150?img=47')
                            as ImageProvider,
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt,
                        size: 18, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _nameController.text,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _emailController.text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(hint: 'Nama Lengkap', controller: _nameController),
            const SizedBox(height: 16),
            _buildTextField(hint: 'Email', controller: _emailController),
            const SizedBox(height: 16),
            _buildPhoneNumberField(),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProfile, // Panggil fungsi yang sudah diperbarui
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF859F3D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Update Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('+62', style: GoogleFonts.poppins()),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Nomor Telepon',
              hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      hint: Text(
        'Jenis Kelamin',
        style: GoogleFonts.poppins(color: Colors.grey[600]),
      ),
      onChanged: (value) => setState(() => _selectedGender = value),
      items: _genders.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender, style: GoogleFonts.poppins()),
        );
      }).toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate:
              DateTime.tryParse(_dateController.text) ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          _dateController.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        }
      },
      decoration: InputDecoration(
        hintText: 'Apa tanggal lahir Anda?',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        suffixIcon:
            Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
      ),
    );
  }
}
