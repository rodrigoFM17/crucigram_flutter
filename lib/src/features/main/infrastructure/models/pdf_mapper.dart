import 'package:pdf/widgets.dart';

class PdfMapper {
  final double xFactor;
  final double yFactor;
  final double sFactor;
  final Widget widget;

  PdfMapper({
    this.xFactor = 0, 
    this.yFactor = 0, 
    this.sFactor = 1, 
    required this.widget
  });
  
}