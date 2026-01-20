import 'package:flutter/material.dart';
import 'intro_pages.dart'; // Navigasi lanjut ke IntroPages

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.height < 650;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const IntroPages(),
            ),
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double topImageHeight =
                constraints.maxHeight * (isSmallDevice ? 0.5 : 0.66);
            final double bottomContainerHeight =
                constraints.maxHeight * (isSmallDevice ? 0.45 : 0.4);
            return Stack(
              children: [
                SizedBox(
                  height: topImageHeight,
                  width: constraints.maxWidth,
                  child: Image.asset(
                    'assets/images/Vector 2.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: bottomContainerHeight,
                    width: constraints.maxWidth,
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.06,
                      vertical: isSmallDevice ? 18 : 32,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/logo_terraserve.png',
                          width: constraints.maxWidth * 0.13,
                          height: constraints.maxHeight * 0.06,
                        ),
                        SizedBox(height: isSmallDevice ? 8 : 16),
                        const Text(
                          'Selamat Datang\ndi TerraServe',
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/aaa.png',
                              width: constraints.maxWidth * 0.08,
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
            );
          },
        ),
      ),
    );
  }
}
