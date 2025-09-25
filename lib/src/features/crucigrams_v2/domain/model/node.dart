import 'package:pdf_test/src/features/crucigrams_v2/domain/model/coordinates.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/edge.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/enum/orientation.dart';
import 'package:pdf_test/src/shared/utils/random.dart';

class Node {

  final String value;
  final Orientation orientation;
  final Node? parent;
  final List<Edge> edges;

  Node({
    required this.value,
    required this.orientation,
    required this.parent,
    required this.edges
  });


  Coordinates? isConnectedToWord(String word) {

    final connectedWordCoordinates = edges.where((edge) { return edge.node.value == word;}).toList();
    return connectedWordCoordinates.first.edge;
  }

  bool isCoordinatesBusy(Coordinates coordinates) {

    final wordCoordinates = edges.where((edge) { 
        return edge.edge.x == coordinates.x; 
      }
    ).toList();

    return wordCoordinates.isNotEmpty;
  }

  Node getRandomLeaf() {

    if (edges.isEmpty) {
      return this;
    } else {

      final List<Node> leafs = edges.map((edge) => edge.node.getRandomLeaf()).toList(); 
      return getRandomListItem(leafs);
    }
  }

  Coordinates getCoordinates(String word) {
    final edge = edges.where((edge) => edge.node.value == word).toList();
    return edge.first.edge;
  }

  @override
  String toString() {
    
    return """
\n{ 
  value: $value,
  edges: [ ${edges.map((edge) => " $edge")}
  ]
}
""";
  }



  void executeInNodes(Function action, List<List<String?>> charactersMatrix, Map<String, Coordinates> wordCoordinatesInMatrix) {
    action(this, charactersMatrix, wordCoordinatesInMatrix);
    edges.forEach((edge) => edge.node.executeInNodes(action, charactersMatrix, wordCoordinatesInMatrix));
  }

  



}