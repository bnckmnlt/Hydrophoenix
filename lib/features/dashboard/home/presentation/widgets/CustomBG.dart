import 'package:flutter/material.dart';

class CustomBG extends CustomPainter {
  final bool isDefault;

  CustomBG({required this.isDefault});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2
      ..color = isDefault
          ? const Color.fromARGB(255, 16, 185, 129).withOpacity(0.075)
          : const Color.fromARGB(255, 244, 114, 182).withOpacity(0.075)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2 - 80), 100, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height - 60), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
