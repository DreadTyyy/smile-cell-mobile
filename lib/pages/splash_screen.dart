//to do list
//ambil data user(user) dan API(api_token)
//cek ada atau tidak ada
//jika tidak ada keduanya arahkan ke halaman login
//jika ada keduanya arahkan ke homescreen
//jika ada data user tetapi tidak ada API arahakan ke login
//jika ada API tetapi tidak ada data user minta ke backend
//tambah gambar bebas di center (72x72)
//hapus delay agar mengetahui pengambilan data sukses

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:smile_cell/data/local/session_helpers.dart";
import "package:smile_cell/providers/auth_provider.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final sessionHelpers = SessionHelpers();

    final token = await sessionHelpers.getSessionData("api_token");
    final userProfile = await sessionHelpers.getUserProfile();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    if (userProfile == null) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    context.read<AuthProvider>().initUser();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C93CB),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 72),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}