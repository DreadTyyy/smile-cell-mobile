import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smile_cell/component/feature_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceHidden = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset("assets/Vector.png", height: 36.0),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smile",
                      style: GoogleFonts.getFont(
                        "Google Sans Flex",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Cell",
                      style: GoogleFonts.getFont(
                        "Google Sans Flex",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Selamat pagi,",
                  style: GoogleFonts.getFont(
                    "Google Sans Flex",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Lebron James",
                  style: GoogleFonts.getFont(
                    "Google Sans Flex",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceBox(),
              SizedBox(height: 24.0),
              Text(
                "Top Up",
                style: GoogleFonts.getFont(
                  "Google Sans Flex",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  FeatureBox(
                    urlImage: "assets/Vector.png",
                    title: "Paket Data",
                    onTap: () {},
                  ),
                  SizedBox(width: 16.0),
                  FeatureBox(
                    urlImage: "assets/Vector.png",
                    title: "Paket Pulsa",
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jumlah Saldo Kamu",
                    style: GoogleFonts.getFont(
                      "Google Sans Flex",
                      fontSize: 14.0,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        _isBalanceHidden ? "Rp•••••••" : "Rp100.000",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () => setState(
                          () => _isBalanceHidden = !_isBalanceHidden,
                        ),
                        child: Icon(
                          _isBalanceHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).colorScheme.surface,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBalanceAction(
                    icon: Icons.add_circle_outline,
                    label: "Isi Saldo",
                    onTap: () {},
                  ),
                  SizedBox(width: 20.0),
                  _buildBalanceAction(
                    icon: Icons.send_outlined,
                    label: "Kirim Saldo",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceAction({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24.0,
            ),
            SizedBox(height: 6.0),
            Text(
              label,
              style: TextStyle(fontSize: 12.0, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}