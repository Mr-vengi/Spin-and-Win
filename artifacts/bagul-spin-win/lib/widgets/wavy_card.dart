import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WavyCard extends StatelessWidget {
  const WavyCard({
    required this.child,
    this.padding = const EdgeInsets.all(22),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const WavyCardClipper(),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.cream,
          border: Border.all(color: AppColors.gold, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x220E382F),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class WavyCardClipper extends CustomClipper<Path> {
  const WavyCardClipper();

  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(12, 0);
    path.lineTo(size.width - 12, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 12);
    for (var y = 24.0; y < size.height - 24; y += 32) {
      path.quadraticBezierTo(size.width - 10, y + 8, size.width, y + 16);
      path.quadraticBezierTo(size.width + 10, y + 24, size.width, y + 32);
    }
    path.lineTo(size.width, size.height - 12);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 12,
      size.height,
    );
    path.lineTo(12, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 12);
    for (var y = size.height - 24.0; y > 24; y -= 32) {
      path.quadraticBezierTo(10, y - 8, 0, y - 16);
      path.quadraticBezierTo(-10, y - 24, 0, y - 32);
    }
    path.lineTo(0, 12);
    path.quadraticBezierTo(0, 0, 12, 0);
    return path..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
