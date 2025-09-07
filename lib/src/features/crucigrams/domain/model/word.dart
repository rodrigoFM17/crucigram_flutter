
import 'relation.dart';

class Word {

  final String value;
  final List<Relation> relation;

  Word({
    required this.value,
    required this.relation
  });

  factory Word.fromWords(
    String word,
    List<String> words
  ) {
    final filterWords = words.where((singleWord) {return singleWord != word;});
    final List<Relation> relations = filterWords.map((singleWord) { return Relation.fromWords(singleWord, words);}).toList();
    return Word(
      value: word, 
      relation: relations
    );
  }

  Relation getRandomRelation() {
    throw UnimplementedError();
  }
}