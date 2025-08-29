import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrintScreen extends StatelessWidget {
  final Uint8List pdf;
  const PrintScreen({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printing Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
        tooltip: 'Print Document',
        onPressed: () {
          // This is where we print the document
          Printing.layoutPdf(
            format: PdfPageFormat.letter,
            // [onLayout] will be called multiple times
            // when the user changes the printer or printer settings
            onLayout: (PdfPageFormat format) {
              // Any valid Pdf document can be returned here as a list of int
              return pdf;
            },
          );
        },
      ),
      body: Center(
        child: Text('Click on the print button below'),
      ),
    );
  }
}