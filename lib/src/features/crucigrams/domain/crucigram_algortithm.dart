import 'dart:math';

enum Orientation {
  horizontal,
  vertical;
}

T randomListChoose<T>(List<T> list) {

  var random = Random();
  final length = list.length; 

  if(length > 1) {
    final randomIndex = random.nextInt(length);
    return list[randomIndex];
  } else {
    return list[0];
  }
}

class CrucigramWord {

  final String word;
  final Orientation orientation;
  final List<Relation> relations;

  CrucigramWord({
    required this.word,
    required this.orientation,
    required this.relations
  });

  Relation getRandomRelation() {
    return randomListChoose(relations);
  }

  @override
  String toString() {
    
    return"""
{
  word: $word ,
  relations: [
    ${relations.map((relation) {
      return """ {
        originWord: ${relation.originWord},
        relationWord: ${relation.relationWord},
        wordCordinates: [${relation.wordCordinates.map((cordinates) {
          return """{x: ${cordinates.originIndex}, y: ${cordinates.relationIndex}}""";
        })}
      ]}""";
    })}
  ]

}""";
  }

}

class WordCoordinates {

  final int originIndex;
  final int relationIndex;

  WordCoordinates({
    required this.originIndex,
    required this.relationIndex
  });
}

class Relation {

  final String originWord;
  final String relationWord;
  List<WordCoordinates> wordCordinates;

  Relation({
    required this.originWord,
    required this.relationWord,
    required this.wordCordinates
  });


  static List<Relation> getRelations(String originWord, List<String> words) {
    List<Relation> relations = [];

    final originWordChars = originWord.split("");

    words.forEach((word) {

      if(word != originWord) {
        
        final relation = Relation(
          originWord: originWord, 
          relationWord: word,
          wordCordinates: []
        );

        final wordChars = word.split("");

        originWordChars.asMap().forEach((originWordIndex, originWordChar) {

          wordChars.asMap().forEach((wordIndex, wordChar) {
            if(originWordChar == wordChar) {
              relation.wordCordinates.add(
                WordCoordinates(
                  originIndex: originWordIndex, 
                  relationIndex: wordIndex
                )
              );
            }
          });

        });
        
        relations.add(relation);

      }
      
    });

    return relations;
  }

}

class Crucigram {

  final List<String> words;
  final List<CrucigramWord> crucigramWords = [];

  final List<CrucigramWord> addedWords = [];

  final List<CrucigramWord> wordsForCrucigram = [];

  Crucigram({
    required this.words,
  });

  bool isValid() {

    bool isValid = false;
    crucigramWords.forEach((word) {
      isValid = isValid || word.relations.isNotEmpty;
    });

    return isValid;
  }

  init() {


    words.forEach((word) {

      final relations = _getRelations(word, words);

      final crucigramWord = CrucigramWord(
        word: word, 
        orientation: Orientation.horizontal, 
        relations: relations
      );

      crucigramWords.add(crucigramWord);
    });


    print(crucigramWords);

    final startWord = _getWordWithMoreRelations();
    final relation = startWord.getRandomRelation();

    final wordForCrucigram = CrucigramWord(
      word: startWord.word, 
      orientation: Orientation.horizontal, 
      relations: [relation]
    );

    wordsForCrucigram.add(wordForCrucigram);



  }


  List<Relation> _getRelations(String originWord, List<String> words) {

    List<Relation> relations = [];

    final originWordChars = originWord.split("");

    words.forEach((word) {

      if(word != originWord) {
        
        final relation = Relation(
          originWord: originWord, 
          relationWord: word,
          wordCordinates: []
        );

        final wordChars = word.split("");

        originWordChars.asMap().forEach((originWordIndex, originWordChar) {

          wordChars.asMap().forEach((wordIndex, wordChar) {
            if(originWordChar == wordChar) {
              relation.wordCordinates.add(
                WordCoordinates(
                  originIndex: originWordIndex, 
                  relationIndex: wordIndex
                )
              );
            }
          });

        });
        
        relations.add(relation);

      }
      
    });

    return relations;
  }

  CrucigramWord _getWordWithMoreRelations() {

    var wordsWithMoreRelations = [crucigramWords[0]];

    for(int i = 1; i < crucigramWords.length; i++ ) {
      
      if(crucigramWords[i].relations.length > wordsWithMoreRelations[0].relations.length) {
        wordsWithMoreRelations = [crucigramWords[i]];
      } else if ( crucigramWords[i].relations.length == wordsWithMoreRelations[0].relations.length) {
        wordsWithMoreRelations.add(crucigramWords[i]);
      }
    }

    return randomListChoose<CrucigramWord>(wordsWithMoreRelations);

  }

  void generateCrucigram() {
    init();

    if(isValid()) {


    }

  }

}


void generateCrucigram(List<String> words) {


  words.forEach( (word) {

    

  });




}