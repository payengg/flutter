import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/startup_pages.dart';
import 'package:terraserve_app/pages/services/favorite_service.dart';
import 'package:terraserve_app/pages/services/cart_service.dart'; // ✅ PATH SUDAH BENAR
import 'package:terraserve_app/pages/services/navigation_service.dart';
import 'package:terraserve_app/providers/farmer_application_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteService()),
        ChangeNotifierProvider(create: (context) => CartService()),
        ChangeNotifierProvider(create: (context) => NavigationService()),
        ChangeNotifierProvider(
            create: (context) => FarmerApplicationProvider()),
      ],
      child: const TerraServe(),
    ),
  );
}

class TerraServe extends StatelessWidget {
  const TerraServe({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartupPage(),
    );
  }
}
