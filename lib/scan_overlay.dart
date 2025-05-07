import 'package:flutter/material.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _ScannerOverlayPainter(),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    // Ukuran dan posisi kotak fokus
    final scanBoxWidth = size.width * 0.9;
    final scanBoxHeight = size.height * 0.6;
    final top = size.height * 0.1;
    final left = (size.width - scanBoxWidth) / 2;

    final focusRect = Rect.fromLTWH(left, top, scanBoxWidth, scanBoxHeight);

    // Path untuk background dan lubang
    final backgroundPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRect(focusRect);
    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holePath,
    );

    // Gambar area blur di luar kotak
    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
