// lib/pages/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/services/api_service.dart';
// ✅ 1. Tambahkan import country_picker
import 'package:country_picker/country_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String token;
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String? currentAddress;

  const EditProfilePage({
    super.key,
    required this.token,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    this.currentAddress,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final Color _primaryGreen = const Color(0xFF389841);

  // ✅ 2. Tambahkan variabel state untuk Negara (Default Indonesia)
  Country _selectedCountry = Country(
    phoneCode: '62',
    countryCode: 'ID',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Indonesia',
    example: 'Indonesia',
    displayName: 'Indonesia',
    displayNameNoCountryCode: 'ID',
    e164Key: '',
  );

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _emailController.text = widget.currentEmail;

    // Logika membersihkan awalan nomor telepon agar hanya tersisa angkanya saja di controller
    String phone = widget.currentPhone;
    if (phone.startsWith('+62')) {
      phone = phone.substring(3);
    } else if (phone.startsWith('62')) {
      phone = phone.substring(2);
    } else if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    _phoneController.text = phone;

    _addressController.text = widget.currentAddress ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phoneRaw = _phoneController.text.trim();
    final address = _addressController.text.trim();

    // ✅ 3. Gunakan kode negara dari _selectedCountry, bukan hardcode +62 lagi
    final phoneFormatted = '+${_selectedCountry.phoneCode}$phoneRaw';

    try {
      await ApiService.updateProfile(
        name,
        email,
        phoneFormatted,
        address,
        widget.token,
      );

      if (mounted) {
        final updatedData = {
          'name': name,
          'email': email,
          'phone': phoneFormatted,
          'address': address,
        };
        Navigator.pop(context, updatedData);
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/user_avatar.png'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : "Nama Pengguna",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _emailController.text.isNotEmpty
                        ? _emailController.text
                        : "email@domain.com",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                      controller: _nameController, hint: "Nama Lengkap"),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _emailController, hint: "Email"),
                  const SizedBox(height: 16),

                  // ✅ 4. Panggil Widget Phone Field yang baru
                  _buildPhoneField(),

                  const SizedBox(height: 16),
                  _buildAddressField(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
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
          ),
        ],
      ),
    );
  }

  // ✅ 5. Widget Khusus untuk Input Nomor Telepon dengan Country Picker
  // (Menggantikan implementasi Row manual yang error gambar tadi)
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Nomor Telepon",
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          // Bagian Prefix Icon untuk memilih negara
          prefixIcon: GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                },
                countryListTheme: CountryListThemeData(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  bottomSheetHeight: 500,
                  inputDecoration: InputDecoration(
                    labelText: 'Cari Negara',
                    hintText: 'Mulai ketik untuk mencari',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCountry.flagEmoji, // Menampilkan bendera emoji
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${_selectedCountry.phoneCode}', // Menampilkan kode +62
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        controller: _addressController,
        maxLines: 5,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Alamat',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
