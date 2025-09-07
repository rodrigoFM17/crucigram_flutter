
import 'enum/orientation.dart';
import 'relation.dart';

class Node {

  final String word;
  final Orientation orientation;
  final Relation relation;
  final Node? previous;
  Node? next;

  Node({
    required this.word,
    required this.orientation,
    required this.relation,
    required this.previous,
    required this.next
  });

  bool isWordAlreadyRelationated(String word) {

    if(this.word != word && this.previous == null) {
      return false;
    } else if(this.word != word) {
      return false || isWordAlreadyRelationated(this.previous!.word);
    } else {
      return true;
    }
  }

}