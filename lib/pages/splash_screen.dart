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
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/home");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C93CB),
      body: Container(
        child: Text("hello world!"),
      ),
    );
  }
}