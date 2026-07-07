//to do list
//ambil data user(user) dan API(api_token)
//cek ada atau tidak ada
//jika tidak ada keduanya arahkan ke halaman login
//jika ada keduanya arahkan ke homescreen
//jika ada data user tetapi tidak ada API arahakan ke login
//jika ada API tetapi tidak ada data user minta ke backend
//tambah gambar bebas di center (72x72)
//hapus delay agar mengetahui pengambilan data sukses

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigate();
  }

  Future<void> _navigate()async{
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("user");
    final token = prefs.getString("api_token");
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    if (user != null && user.isNotEmpty) {
      Navigator.pushReplacementNamed(context, "/home");
      return;
    }

    final success = await _fetchUserFromBackend(token);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, success ? "/home" : "/login");
  }

  Future<bool> _fetchUserFromBackend(String token) async {
    try {
      final response = await http.get(
        Uri.parse("https://api.example.com/me"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user", response.body);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C93CB),
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