import 'package:pdf_test/src/features/crucigrams_v2/domain/model/coordinates.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/node.dart';

class Edge {

  final Coordinates edge;
  final Node node;

  Edge({
    required this.edge,
    required this.node
  });

  @override
  String toString() {
    return "{ coordinates: $edge, node: $node }";
  }
  
}