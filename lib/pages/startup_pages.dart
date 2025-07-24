import 'package:flutter/material.dart';
import 'package:terraserve_app/pages/intro_pages.dart'; // Import halaman intro

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IntroPages()),
          );
        },
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.66,
              width: double.infinity,
              child: Image.asset(
                'assets/images/Vector 2.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo_terraserve.png',
                      width: 45,
                      height: 47.31,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Selamat Datang\ndi TerraServe',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Rectangle 3.png',
                          width: 27,
                          height: 8,
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          'assets/images/Ellipse 1.png',
                          width: 8,
                          height: 8,
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          'assets/images/Ellipse 2.png',
                          width: 8,
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
