import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_test/src/features/main/infrastructure/models/pdf_mapper.dart';
import 'package:pdf_test/src/features/main/screens/providers/interactive_state_provider.dart';

class DraggableWidget extends ConsumerStatefulWidget {
  final Offset position;
  final pw.Widget pdfWidget;
  final int index;
  final RenderBox renderBox;
  final Function(int index, PdfMapper mapper) onDrag;

  const DraggableWidget({
    super.key, 
    required this.position, 
    required this.pdfWidget, 
    required this.index, 
    required this.onDrag, 
    required this.renderBox, 
  });

  @override
  DraggableWidgetState createState() => DraggableWidgetState();

}

class DraggableWidgetState extends ConsumerState<DraggableWidget> {

  bool touched = false;
  double scaleOfWidget = 0.9;
  List<Offset> corners = [];

  int nCells = 0;

  late Offset position;
  late Offset localTapPosition;
  double xFactor = 0;
  double yFactor = 0;

  @override
  void initState() {
    super.initState();
    position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    final scale = ref.watch(interactiveStateProvider).scale;
    final origin = widget.renderBox.localToGlobal(Offset.zero);
    final constraints = widget.renderBox.constraints;
    final cellWidth = constraints.maxWidth / 215.9; 
    final fontSize = 12 * constraints.maxWidth / 612;

    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Stack(
        children: [
          
          GestureDetector(
            onTap: () => {
              setState(() {
                touched = !touched;
              })
            },
            onPanDown: (details) {
              setState(() {
                localTapPosition = details.localPosition;
              });
            },
            onPanUpdate: (details) { 
              final calcPosition = (details.globalPosition - origin) / scale - localTapPosition;
              final dx =(calcPosition.dx / cellWidth).round() * cellWidth;
              final dy =(calcPosition.dy / cellWidth).round() * cellWidth;
              setState(() {
                position = Offset(dx, dy);
              });
            },
            onPanEnd: (details) {
              final calcPosition = (details.globalPosition - origin) / scale - localTapPosition;
              final dx =(calcPosition.dx / cellWidth).round() * cellWidth;
              final dy =(calcPosition.dy / cellWidth).round() * cellWidth;
              setState(() {
                position = Offset(dx, dy);
                xFactor = position.dx / widget.renderBox.constraints.maxWidth;
                yFactor = position.dy / widget.renderBox.constraints.maxHeight;
              });
              onDrag();
            },
            child: SizedBox(
              width: constraints.maxWidth * scaleOfWidget,
          
              child: Container(
                decoration: touched ? BoxDecoration(
                  border:  Border.all(
                    color: Colors.deepPurple,
                    width: 1.0
                  )
                ) : null,
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Qué presidente de México es conocido por la frase "El respeto al derecho ajeno es la paz"?',
                      style: TextStyle(fontSize: fontSize * 1.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text("a) Porfirio Diaz", style: TextStyle(fontSize: fontSize))),
                          Expanded(flex: 1, child: Text("b) Benito Juárez", style: TextStyle(fontSize: fontSize))),
                          Expanded(flex: 1, child: Text("c) Lázaro Cárdenas", style: TextStyle(fontSize: fontSize))),
                          Expanded(flex: 1, child: Text("d) Venustiano Carranza", style: TextStyle(fontSize: fontSize))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                final calcPosition = (details.globalPosition - origin) / scale - localTapPosition;
            
                final currentDx = (position.dx / cellWidth).round() * cellWidth;
                final currentDy = (position.dx / cellWidth).round() * cellWidth;
            
                final dx =(calcPosition.dx / cellWidth).round() * cellWidth;
                final dy =(calcPosition.dy / cellWidth).round() * cellWidth;
            
                final resX = position.dx - dx;
                final resY = position.dy - dy;
            
                if(resX > 0 || resY > 0) {
                  setState(() {
                    scaleOfWidget = scaleOfWidget * 1.01;
                  });
                } else {
                  setState(() {
                    scaleOfWidget = scaleOfWidget * 0.99;
                  });
                }
            
              },
              child: Container(
                width: 5,
                color: Colors.deepPurple,
                height: 5,
                
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDrag(){
    final constraints = widget.renderBox.constraints;
    final xFactor = (position.dx) / constraints.maxWidth;
    final yFactor = (position.dy) / constraints.maxHeight;
    final mapper = PdfMapper(widget: widget.pdfWidget, xFactor: xFactor, yFactor: yFactor);
    widget.onDrag(widget.index, mapper);
  }
}