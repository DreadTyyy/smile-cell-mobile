import 'dart:math' as math;
import 'dart:ui' as ui;
 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
Future<ui.Image> loadUiImage(String assetPath, {int targetWidth = 96}) async {
  final data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: targetWidth, // kecilkan: watermark tidak butuh resolusi besar
  );
  final frame = await codec.getNextFrame();
  return frame.image;
}
 
class WatermarkPainter extends CustomPainter {
  WatermarkPainter({
    required this.logo,
    required this.text,
    this.color = const Color(0xFF1A75AA),
    this.opacity = 0.07,
    this.angle = -math.pi / 6, // -30°
    this.logoSize = 20,
    this.gap = 2, // jarak logo ke teks
    this.spacingX = 32, // jarak antar pola horizontal
    this.spacingY = 40, // jarak antar baris
    this.fontSize = 16,
    this.tintLogo = true, // true = logo diwarnai satu warna (seperti teks)
  });
 
  final ui.Image logo;
  final String text;
  final Color color;
  final double opacity;
  final double angle;
  final double logoSize;
  final double gap;
  final double spacingX;
  final double spacingY;
  final double fontSize;
  final bool tintLogo;
 
  @override
  void paint(Canvas canvas, Size size) {
    final inkColor = color.withValues(alpha: opacity);
 
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: inkColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
 
    final logoH = logoSize;
    final logoW = logoSize * logo.width / logo.height;
    final rowH = math.max(logoH, tp.height);
    final tileW = logoW + gap + tp.width + spacingX;
    final tileH = rowH + spacingY;
 
    final logoPaint = Paint()
      ..filterQuality = FilterQuality.medium
      ..isAntiAlias = true;
    if (tintLogo) {
      logoPaint.colorFilter = ColorFilter.mode(inkColor, BlendMode.srcIn);
    } else {
      logoPaint.color = Colors.black.withValues(alpha: opacity);
    }
    final src = Rect.fromLTWH(
        0, 0, logo.width.toDouble(), logo.height.toDouble());
 
    canvas.save();
    canvas.clipRect(Offset.zero & size);
 
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);
 
    final half = math.sqrt(size.width * size.width + size.height * size.height) / 2;
 
    var row = 0;
    for (double y = -half - tileH; y < half + tileH; y += tileH, row++) {
      final shift = row.isOdd ? tileW / 2 : 0.0;
      for (double x = -half - tileW - shift; x < half + tileW; x += tileW) {
        canvas.drawImageRect(
          logo,
          src,
          Rect.fromLTWH(x, y + (rowH - logoH) / 2, logoW, logoH),
          logoPaint,
        );
        tp.paint(canvas, Offset(x + logoW + gap, y + (rowH - tp.height) / 2));
      }
    }
 
    canvas.restore();
    tp.dispose();
  }
 
  @override
  bool shouldRepaint(covariant WatermarkPainter old) =>
      old.logo != logo ||
      old.text != text ||
      old.color != color ||
      old.opacity != opacity ||
      old.angle != angle ||
      old.logoSize != logoSize ||
      old.spacingX != spacingX ||
      old.spacingY != spacingY ||
      old.fontSize != fontSize ||
      old.tintLogo != tintLogo;
}
 
class ReceiptNotchClipper extends CustomClipper<Path> {
  ReceiptNotchClipper({
    required this.notchY, 
    this.notchRadius = 10,
    this.cornerRadius = 16,
  });
 
  final double notchY;
  final double notchRadius;
  final double cornerRadius;
 
  @override
  Path getClip(Size size) {
    final card = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, Radius.circular(cornerRadius)));
    final notches = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, notchY), radius: notchRadius))
      ..addOval(Rect.fromCircle(
          center: Offset(size.width, notchY), radius: notchRadius));
    return Path.combine(PathOperation.difference, card, notches);
  }
 
  @override
  bool shouldReclip(covariant ReceiptNotchClipper old) =>
      old.notchY != notchY ||
      old.notchRadius != notchRadius ||
      old.cornerRadius != cornerRadius;
}
 
class WatermarkedBox extends StatelessWidget {
  const WatermarkedBox({
    super.key,
    required this.child,
    required this.logo,
    this.text = 'SmileCell',
    this.clipper,
    this.backgroundColor = Colors.white,
    this.elevation = 3,
    this.watermarkOnTop = true,
  });
 
  final Widget child;
  final ui.Image? logo; 
  final String text;
  final CustomClipper<Path>? clipper;
  final Color backgroundColor;
  final double elevation;
 
  final bool watermarkOnTop;
 
  @override
  Widget build(BuildContext context) {
    final watermark = logo == null
        ? const SizedBox.shrink()
        : Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WatermarkPainter(logo: logo!, text: text),
                ),
              ),
            ),
          );
 
    return PhysicalShape(
      clipper: clipper ??
          const ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
      color: backgroundColor,
      elevation: elevation,
      shadowColor: const Color(0x3314212B),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: watermarkOnTop ? [child, watermark] : [watermark, child],
      ),
    );
  }
}