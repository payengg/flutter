import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/reset_password_pages.dart'; // Import halaman selanjutnya

class VerifyCodePage extends StatefulWidget {
  // Menerima email atau nomor telepon dari halaman sebelumnya
  final String identifier;

  const VerifyCodePage({super.key, required this.identifier});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  // Controllers untuk setiap kotak OTP
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  // FocusNodes untuk mengatur fokus antar kotak
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  // Fungsi yang dijalankan saat tombol "Verifikasi" ditekan
  void _verifyCode() {
    // Gabungkan semua digit dari setiap kotak menjadi satu string
    final otp = _controllers.map((c) => c.text).join();

    // Cek jika OTP sudah terisi 4 digit
    if (otp.length == 4) {
      // Navigasi ke halaman Reset Password, kirim identifier dan OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(
            identifier: widget.identifier,
            token: otp, // Kirim OTP yang sudah digabung
          ),
        ),
      );
    } else {
      // Tampilkan notifikasi jika OTP belum lengkap
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua 4 digit kode verifikasi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 112),
              Text(
                'Verifikasi Kode',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Masukkan kode verifikasi yang telah kami kirim ke ',
                    ),
                    TextSpan(
                      text:
                          widget.identifier, // Menampilkan email atau no. telp
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 112),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) => _onTextChanged(value, index),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 112),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // Panggil fungsi _verifyCode saat tombol ditekan
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    // --- UBAH WARNA TOMBOL DISINI ---
                    backgroundColor: const Color(0xFF389841),
                    // --------------------------------
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Verifikasi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
