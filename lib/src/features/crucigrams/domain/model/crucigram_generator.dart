
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

  void init() {

    List<Word> words = wordsForCrucigram.map(
      (wordForCrucigram) {
        return Word.fromWords(wordForCrucigram, wordsForCrucigram);
      }
    ).toList();


    final CrucigramLinkedList linkedList = CrucigramLinkedList.fromWordList(words);

  }

}

final generator = CrucigramGenerator(wordsForCrucigram: ["ana", "rana", "rapido", "anastasia"]);