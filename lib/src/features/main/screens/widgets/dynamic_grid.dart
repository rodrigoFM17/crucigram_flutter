import 'package:flutter/material.dart';

class DynamicGrid extends StatelessWidget {
  final double lineWidth; // Ancho de las líneas
  final double spacing;   // Espacio entre celdas
  final Color color;

  // Constructor para recibir los parámetros
  const DynamicGrid({
    super.key,
    required this.lineWidth,
    required this.spacing,
    this.color = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: GridPainter(
          lineWidth: lineWidth,
          spacing: spacing,
          color: color
        ),
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}


class GridPainter extends CustomPainter {
  final double lineWidth; // Ancho de las líneas
  final double spacing;   // Espacio entre las líneas
  final Color color;

  GridPainter({
    required this.lineWidth,
    required this.spacing,
    required this.color
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Color de las líneas
      ..strokeWidth = lineWidth; // Ancho de las líneas

    // Dibujar las líneas horizontales
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Dibujar las líneas verticales
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Solo dibujar una vez, no se repinta dinámicamente
  }
}
