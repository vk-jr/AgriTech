import 'package:flutter/material.dart';

class PlantDecoration extends StatelessWidget {
  final double height;
  final double width;
  final bool showLeft;
  final bool showRight;
  final String? imagePath;
  final int imageVariant;

  const PlantDecoration({
    super.key,
    this.height = 60,
    this.width = 50,
    this.showLeft = true,
    this.showRight = true,
    this.imagePath,
    this.imageVariant = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: width * (showLeft && showRight ? 2.2 : 1.1),
      ),
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLeft)
              _buildPlantImage(isLeft: true),
            if (showRight)
              _buildPlantImage(isLeft: false),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage({required bool isLeft}) {
    final String assetPath = imagePath ?? 'assets/images/plant_decoration_$imageVariant.png';
    
    Widget plantImage = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: height,
        maxWidth: width,
      ),
      child: Image.asset(
        assetPath,
        height: height,
        width: width,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to custom painted version if image not found
          return Container(
            height: height,
            width: width,
            child: CustomPaint(
              painter: PlantPainter(isLeft: isLeft),
            ),
          );
        },
      ),
    );

    // Mirror the image for right side if needed
    if (!isLeft) {
      plantImage = Transform.scale(
        scaleX: -1,
        child: plantImage,
      );
    }

    return plantImage;
  }
}

class PlantPainter extends CustomPainter {
  final bool isLeft;

  PlantPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Create gradient effects for more vibrant colors
    final path = Path();
    
    if (isLeft) {
      // Large tropical leaf (green with gradient)
      final greenGradient = LinearGradient(
        colors: [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      paint.shader = greenGradient;
      
      path.moveTo(size.width * 0.1, size.height * 0.9);
      path.quadraticBezierTo(
        size.width * 0.05, size.height * 0.7,
        size.width * 0.2, size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.3,
        size.width * 0.3, size.height * 0.1,
      );
      path.quadraticBezierTo(
        size.width * 0.4, size.height * 0.15,
        size.width * 0.45, size.height * 0.3,
      );
      path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.5,
        size.width * 0.4, size.height * 0.7,
      );
      path.quadraticBezierTo(
        size.width * 0.3, size.height * 0.85,
        size.width * 0.1, size.height * 0.9,
      );
      canvas.drawPath(path, paint);

      // Coral/Pink leaf
      final pinkGradient = LinearGradient(
        colors: [const Color(0xFFFF8A65), const Color(0xFFD84315)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      paint.shader = pinkGradient;
      
      path.reset();
      path.moveTo(size.width * 0.5, size.height * 0.95);
      path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.8,
        size.width * 0.75, size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.4,
        size.width * 0.85, size.height * 0.2,
      );
      path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.25,
        size.width * 0.9, size.height * 0.45,
      );
      path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.65,
        size.width * 0.7, size.height * 0.8,
      );
      path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.9,
        size.width * 0.5, size.height * 0.95,
      );
      canvas.drawPath(path, paint);

      // Yellow/Orange accent leaves
      final yellowGradient = LinearGradient(
        colors: [const Color(0xFFFFD54F), const Color(0xFFFF8F00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      paint.shader = yellowGradient;
      
      // Small yellow leaf 1
      path.reset();
      path.moveTo(size.width * 0.3, size.height * 0.4);
      path.quadraticBezierTo(
        size.width * 0.4, size.height * 0.25,
        size.width * 0.5, size.height * 0.2,
      );
      path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.15,
        size.width * 0.55, size.height * 0.1,
      );
      path.quadraticBezierTo(
        size.width * 0.65, size.height * 0.2,
        size.width * 0.6, size.height * 0.3,
      );
      path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.35,
        size.width * 0.3, size.height * 0.4,
      );
      canvas.drawPath(path, paint);

      // Small yellow leaf 2
      path.reset();
      path.moveTo(size.width * 0.6, size.height * 0.7);
      path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.55,
        size.width * 0.8, size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.45,
        size.width * 0.82, size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.5,
        size.width * 0.85, size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.65,
        size.width * 0.6, size.height * 0.7,
      );
      canvas.drawPath(path, paint);

    } else {
      // Right side - mirrored version with different arrangement
      // Large tropical leaf (green with gradient)
      final greenGradient = LinearGradient(
        colors: [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      paint.shader = greenGradient;
      
      path.moveTo(size.width * 0.9, size.height * 0.9);
      path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.7,
        size.width * 0.8, size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.65, size.height * 0.3,
        size.width * 0.7, size.height * 0.1,
      );
      path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.15,
        size.width * 0.55, size.height * 0.3,
      );
      path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.5,
        size.width * 0.6, size.height * 0.7,
      );
      path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.85,
        size.width * 0.9, size.height * 0.9,
      );
      canvas.drawPath(path, paint);

      // Coral/Pink leaf
      final pinkGradient = LinearGradient(
        colors: [const Color(0xFFFF8A65), const Color(0xFFD84315)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      paint.shader = pinkGradient;
      
      path.reset();
      path.moveTo(size.width * 0.5, size.height * 0.95);
      path.quadraticBezierTo(
        size.width * 0.4, size.height * 0.8,
        size.width * 0.25, size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.1, size.height * 0.4,
        size.width * 0.15, size.height * 0.2,
      );
      path.quadraticBezierTo(
        size.width * 0.05, size.height * 0.25,
        size.width * 0.1, size.height * 0.45,
      );
      path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.65,
        size.width * 0.3, size.height * 0.8,
      );
      path.quadraticBezierTo(
        size.width * 0.4, size.height * 0.9,
        size.width * 0.5, size.height * 0.95,
      );
      canvas.drawPath(path, paint);

      // Yellow/Orange accent leaves
      final yellowGradient = LinearGradient(
        colors: [const Color(0xFFFFD54F), const Color(0xFFFF8F00)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      paint.shader = yellowGradient;
      
      // Small yellow leaf 1
      path.reset();
      path.moveTo(size.width * 0.7, size.height * 0.4);
      path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.25,
        size.width * 0.5, size.height * 0.2,
      );
      path.quadraticBezierTo(
        size.width * 0.4, size.height * 0.15,
        size.width * 0.45, size.height * 0.1,
      );
      path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.2,
        size.width * 0.4, size.height * 0.3,
      );
      path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.35,
        size.width * 0.7, size.height * 0.4,
      );
      canvas.drawPath(path, paint);

      // Small yellow leaf 2
      path.reset();
      path.moveTo(size.width * 0.4, size.height * 0.7);
      path.quadraticBezierTo(
        size.width * 0.3, size.height * 0.55,
        size.width * 0.2, size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.15, size.height * 0.45,
        size.width * 0.18, size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.1, size.height * 0.5,
        size.width * 0.15, size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.65,
        size.width * 0.4, size.height * 0.7,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
