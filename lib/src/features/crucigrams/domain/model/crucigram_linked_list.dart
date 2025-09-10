
import 'enum/orientation.dart';
import 'node.dart';
import 'word.dart';

class CrucigramLinkedList {

  final Node startingNode;

  CrucigramLinkedList({
    required this.startingNode
  });


  static Word getWordWithMoreRelations() {
    throw UnimplementedError();
  }

  factory CrucigramLinkedList.fromWordList(List<Word> words) {

    final startingWord = getWordWithMoreRelations();

    final startingNode = Node(
      word: startingWord,
      relation: null,
      orientation: Orientation.getRandomOrientation(), 
      previous: null, 
      next: null
    );
    startingNode.setRandomNodeRelation();

    startingNode.setNextNode(
      startingNode.relation!.word, 
      words.map((w) { return w.value;}).toList()
    );

    return CrucigramLinkedList(startingNode: startingNode);
  }
}