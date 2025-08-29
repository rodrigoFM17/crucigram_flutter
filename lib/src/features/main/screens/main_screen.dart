import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_test/src/features/crucigrams/domain/crucigram_algortithm.dart';
import 'package:pdf_test/src/features/main/infrastructure/models/pdf_mapper.dart';
import 'package:pdf_test/src/features/main/screens/providers/interactive_state_provider.dart';
import 'package:pdf_test/src/features/main/screens/widgets/draggable_widget.dart';
import 'package:pdf_test/src/features/main/screens/widgets/dynamic_grid.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  List<Widget> widgets = [];
  List<PdfMapper> pdfWidgets = [];
  int index = 0;
  GlobalKey key = GlobalKey();
  final _controller = TransformationController();
  Offset offset = Offset.zero;

  RenderBox? _getRenderBox() {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox;
  }

  @override
  void initState() {
    super.initState();
    final crucigram = Crucigram(words: ["nigga", "ginger", "knowing"]);
    crucigram.init();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 40;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(231, 229, 230, 1),
      floatingActionButton: Row(
        children: [
          FilledButton(
            onPressed: () {
              setState(() {
                pdfWidgets.add(PdfMapper(widget: pw.Container()));
                widgets.add(
                  DraggableWidget(
                    renderBox: _getRenderBox()!,
                    position: Offset(_getRenderBox()!.constraints.maxWidth / 2, _getRenderBox()!.constraints.maxHeight / 2), 
                    index: index,
                    onDrag: (index, mapper) => pdfWidgets[index] = mapper,
                    // pdfWidget: pw.Container(
                    //   decoration: pw.BoxDecoration(color: PdfColor.fromHex("#25fef7")),
                    //   // 1 unit = 1 / 72 inches
                    //   child: pw.Text(
                    //     '¿Qué presidente de México es conocido por la frase "El respeto al derecho ajeno es la paz"?',
                    //     style: const pw.TextStyle(
                    //       fontSize: 12
                    //     )
                    //   ) 
                    // ),
                    pdfWidget: pw.SizedBox(
                      width: 612 * 0.9,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '¿Qué presidente de México es conocido por la frase "El respeto al derecho ajeno es la paz"?',
                            style: const pw.TextStyle(fontSize: 12 * 1.2),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 10),
                            child: pw.Row(
                              children: [
                                pw.Expanded(flex: 1, child: pw.Text("a) Porfirio Diaz", style: const pw.TextStyle(fontSize: 12))),
                                pw.Expanded(flex: 1, child: pw.Text("b) Benito Juárez", style: const pw.TextStyle(fontSize: 12))),
                                pw.Expanded(flex: 1, child: pw.Text("c) Lázaro Cárdenas", style: const pw.TextStyle(fontSize: 12))),
                                pw.Expanded(flex: 1, child: pw.Text("d) Venustiano Carranza", style: const pw.TextStyle(fontSize: 12))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                );
                index++;
              });
            },
            child: const Text("Add"),
          ),
          FilledButton(
            onPressed: () async {
              context.push(
                "/print"
                , extra: await buildPdf(
                  PdfPageFormat.letter, 
                  pdfWidgets
                  )
              );
            },
            child: const Text("Generate"),
          ),
        ],
      ),
      body: InteractiveViewer(
        transformationController: _controller,
        maxScale: 7,
        onInteractionEnd: (details) {
          final translation = _controller.value.getTranslation();
          ref.read(interactiveStateProvider.notifier).updateOrigin(
            Offset(translation.x, translation.y)
          );
          ref.read(interactiveStateProvider.notifier).updateScale(
            _controller.value.getMaxScaleOnAxis()
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black12,
                  )
                ],
                borderRadius: BorderRadius.circular(10)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.white,
                  height: width * 11 / 8.5,
                  width: width,
                  child: Stack(
                    key: key,
                    children: [
                      ...widgets,
                      DynamicGrid(lineWidth: 0.1, spacing: width / 215.9, color: Colors.black26,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 /// This method takes a page format and generates the Pdf file data
Future<Uint8List> buildPdf(PdfPageFormat format, List<PdfMapper> mappers) async {
  // Create the Pdf document
  final pw.Document doc = pw.Document();

  List<pw.Widget> children = [];

  for (final mapper in mappers){
    children.add(
      pw.Positioned(
        top: format.dimension.y * mapper.yFactor,
        left: format.dimension.x * mapper.xFactor,
        child: mapper.widget
      )
    );
  }

  // Add one page with centered text "Hello World"
  doc.addPage(
    pw.Page(
      pageFormat: format.copyWith(marginBottom: 0, marginTop: 0, marginLeft: 0, marginRight: 0),
      orientation: pw.PageOrientation.portrait,
      build: (pw.Context context) {
        return pw.ConstrainedBox(
          constraints: const pw.BoxConstraints.expand(),
          child: pw.Stack(
            fit: pw.StackFit.expand,
            children: children
          ),
        );
      },
    ),
  );

  // Build and return the final Pdf file data
  return await doc.save();
}