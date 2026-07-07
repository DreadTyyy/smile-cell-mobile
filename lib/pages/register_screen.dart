// TODO: fungsi menyimpan data ke database (registrasi)
// TODO: masuk ke otp screen
// TODO: login -> (failed) -> register -> (success) -> otp [hapus register]

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: Icon(Icons.chevron_left)
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daftar & Isi Data Diri",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                ),
              ),
          
              SizedBox(height: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    "Nomor Handphone",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color(0xCC000000)
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Row(
                      children: [
                        Text(
                          "+62",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16.0
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: TextField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "123 4567 8900"
                            ),
                          ),
                        )
                      ]
                    )
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    "Nama Lengkap",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color(0xCC000000)
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukkan nama lengkap kamu"
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    "Kota",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color(0xCC000000)
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Kota kamu"
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: () => {
                    // Navigator.push(
                    //   context, 
                    //   PageRouteBuilder(
                    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    //       const begin = Offset(1.0, 0.0);
                    //       const end = Offset.zero;
                    //       const curve = Curves.ease;
                    
                    //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    //       return SlideTransition(position: animation.drive(tween), child: child); 
                    //     },
                    //     pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
                    //   ),
                    // )
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C93CB),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "Buat Akun",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ),
              ),
          
              SizedBox(height: 24.0)
            ],
          ),
        )
      ),
    );
  }
}