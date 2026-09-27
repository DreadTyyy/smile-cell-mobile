import "package:flutter/material.dart";

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          "Promo",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0.0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIllustration(),
                const SizedBox(height: 30.0),
                const Text(
                  "Oops!\nPromonya masih kosong.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Saat ini belum ada promo aktif. Tunggu update "
                  "selanjutnya untuk menikmati potongan harga "
                  "spesial agar untungmu makin maksimal.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 240.0,
      height: 240.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 210.0,
            height: 210.0,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EAEC),
              shape: BoxShape.circle,
            ),
          ),

          Container(
            width: 178.0,
            height: 178.0,
            decoration: const BoxDecoration(
              color: Color(0xFFD5E3EC),
              shape: BoxShape.circle,
            ),
          ),

          Transform.translate(
            offset: const Offset(20.0, 20.0),
            child: Image.asset(
              "assets/kado.png",
              width: 210.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}