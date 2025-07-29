// lib/pages/kamera_ktp_page.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/konfirmasi_ktp_page.dart';

class KameraKtpPage extends StatefulWidget {
  const KameraKtpPage({super.key});

  @override
  State<KameraKtpPage> createState() => _KameraKtpPageState();
}

class _KameraKtpPageState extends State<KameraKtpPage> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    if(mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      
      // Ganti halaman dengan halaman konfirmasi, kirim path gambar
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KonfirmasiKtpPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Foto KTP',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Arahkan kamera ke kartu identitas. Pastikan di dalam bingkai.\nPastikan cukup jelas.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Tampilkan preview kamera dengan overlay
                      return AspectRatio(
                        aspectRatio: 3 / 4, // Sesuaikan
                        child: CameraPreview(_controller!),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FloatingActionButton(
                onPressed: _takePicture,
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}