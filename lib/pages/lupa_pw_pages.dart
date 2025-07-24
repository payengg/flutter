import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import 'package:terraserve_app/config/api.dart';
import 'package:terraserve_app/pages/verify_code_pages.dart';

class LupaPwPages extends StatefulWidget {
  const LupaPwPages({super.key});

  @override
  State<LupaPwPages> createState() => _LupaPwPagesState();
}

class _LupaPwPagesState extends State<LupaPwPages> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  int _selectedTabIndex = 0;
  bool _isLoading = false;

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

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final isEmail = _selectedTabIndex == 0;
    final endpoint = isEmail ? '/forgot-password' : '/forgot-password/phone';
    final key = isEmail ? 'email' : 'phone';
    final value = isEmail
        ? _inputController.text
        : '+${_selectedCountry.phoneCode}${_inputController.text}';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Accept': 'application/json'},
        body: {key: value},
      );

      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['meta']['message'] ?? 'Kode OTP telah dikirim.'),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Navigasi ke halaman verifikasi OTP
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['meta']['message'] ?? 'Gagal mengirim kode.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat terhubung ke server. Periksa koneksi Anda.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 27),
                Text(
                  'Lupa Password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Masukkan email atau nomor telepon Anda, kami akan mengirimkan kode verifikasi',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 80),
                _buildTabs(),
                const SizedBox(height: 49),
                if (_selectedTabIndex == 0)
                  _buildEmailField()
                else
                  _buildMobileField(),
                const SizedBox(height: 25),
                _buildPrimaryButton(
                  text: 'Kirim Kode',
                  onPressed: _isLoading ? null : _sendCode,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabItem('E-mail', 0)),
          Expanded(child: _buildTabItem('Nomor Handphone', 1)),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _inputController.clear();
          _formKey.currentState?.reset();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _inputController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Masukkan email Anda',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset('assets/images/icon_email.png', height: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildMobileField() {
    return TextFormField(
      controller: _inputController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Nomor telepon tidak boleh kosong';
        return null;
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Masukkan nomor Anda',
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                bottomSheetHeight: 500,
                inputDecoration: InputDecoration(
                  labelText: 'Cari Negara',
                  hintText: 'Mulai ketik untuk mencari',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selectedCountry.flagEmoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '+${_selectedCountry.phoneCode}',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    Widget? child,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF859F3D),
          disabledBackgroundColor: const Color(0xFF859F3D).withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: child ??
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
