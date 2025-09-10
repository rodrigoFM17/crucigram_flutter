
import '../../../../shared/utils/random.dart';
import 'enum/orientation.dart';
import 'node_relation.dart';
import 'relation.dart';
import 'word.dart';

class Node {

  final String word;
  final Orientation orientation;
  late final NodeRelation? relation;
  final Node? previous;
  Node? next;

  Node({
    required this.word,
    required this.orientation,
    required this.previous,
    required this.relation,
    required this.next
  });

  void setNextNode(String nextWord,List<String> words) {

    final filteredWords = words.where((w) { return w != word;}).toList();

    this.next = Node(
      word: nextWord, 
      orientation: orientation.rotate(), 
      relation: null,
      previous: this,
      next: null
    );

    if(filteredWords.isNotEmpty) {
      this.setRandomNodeRelation();
      this.next!.setNextNode(relation!.word , filteredWords);

    }
      
  }

  void setRandomNodeRelation() {

    var randomRelation = getRandomListItem<Relation>();
    
    while(isWordAlreadyRelationated(randomRelation.word.value)) {
      randomRelation = getRandomListItem(word.relation);
    }

    var randomCoordinates = getRandomListItem(randomRelation.coordinates);

    while(randomCoordinates.x == previous!.relation!.coordinates.y) {
      randomCoordinates = getRandomListItem(randomRelation.coordinates);
    }

    this.relation = NodeRelation(
      word: randomRelation.word, 
      coordinates: randomCoordinates
    );
  }

  bool isWordAlreadyRelationated(String word) {

    if(this.word != word && this.previous == null) {
      return false;
    } else if(this.word != word) {
      return false || isWordAlreadyRelationated(this.previous!.word.value);
    } else {
      return true;
    }
  }

}