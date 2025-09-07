
import 'crucigram_linked_list.dart';
import 'enum/orientation.dart';
import 'node.dart';
import 'word.dart';

class CrucigramGenerator {

  final List<String> wordsForCrucigram;

  CrucigramGenerator({
    required this.wordsForCrucigram
  });

  Word getWordWithMoreRelations() {
    throw UnimplementedError();
  }

  void setNextNode(Node node, Word nextWord) {

    node.next = Node(
      word: nextWord.value, 
      orientation: node.orientation.rotate(), 
      relation: nextWord.getRandomRelation(), 
      previous: node, 
      next: null
    );
  }

  void init() {

    List<Word> words = wordsForCrucigram.map((wordForCrucigram) {
      return Word.fromWords(wordForCrucigram, wordsForCrucigram);
    }).toList();

    final startingWord = getWordWithMoreRelations();

    final CrucigramLinkedList linkedList = CrucigramLinkedList(
      startingNode: Node(
        word: startingWord.value, 
        orientation: Orientation.getRandomOrientation(), 
        relation: startingWord.getRandomRelation(), 
        previous: null, 
        next: null
      )
    );

    words = words.where((w) { return w != startingWord;}).toList(); // quitamos la palabra del inicio


    while(words.length > 0) {

      linkedList.startingNode

    }



    words.forEach((w) {


      
    })


  }

}