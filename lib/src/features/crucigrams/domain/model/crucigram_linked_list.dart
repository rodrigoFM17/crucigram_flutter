
import 'enum/orientation.dart';
import 'node.dart';
import 'word.dart';

class CrucigramLinkedList {

  final Node startingNode;

  CrucigramLinkedList({
    required this.startingNode
  });

  static Node setNextNode(
    Word word, 
    List<Word> words, 
    Node? previousNode
  ) {

    final filteredWords = words.where((w) {return w != word;}).toList();

    final newNode = Node(
      word: word.value, 
      orientation: Orientation.getRandomOrientation(), 
      relation: word.getRandomRelation(), 
      previous: previousNode, 
      next: filteredWords.length >= 1 ? setNextNode(word, filteredWords) : null
    );

    return newNode;
  }

  static Word getWordWithMoreRelations() {
    throw UnimplementedError();
  }

  factory CrucigramLinkedList.fromWordList(List<Word> words) {

    final startingWord = getWordWithMoreRelations();

    final startingNode = setNextNode()


    return 
  }
}