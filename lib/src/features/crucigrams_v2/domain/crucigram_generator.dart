
import 'package:pdf_test/src/features/crucigrams/domain/model/coordinates.dart';

class CrucigramGenerator {

  late List<String> wordsForCrucigram;
  late Map<String, Map<String, List<Coordinates>>> relationsMatrix;

  CrucigramGenerator(List<String> words) {

    wordsForCrucigram = words;

    words.forEach((w)  {
      relationsMatrix[w] = _getRelationsForWord(w, words);
    });

    print(relationsMatrix);

  }

  Map<String, List<Coordinates>> _getRelationsForWord(String wordParam, List<String> words) {

    final originWordChars = wordParam.split("");

    Map<String, List<Coordinates>> wordRelationCoordinates = {};
    wordRelationCoordinates[wordParam] = [];

    words.forEach((word) {

      if(word != wordParam) {
        
        wordRelationCoordinates[word] = [];

        final wordChars = word.split("");

        originWordChars.asMap().forEach((originWordIndex, originWordChar) {

          wordChars.asMap().forEach((wordIndex, wordChar) {
            if(originWordChar == wordChar) {
              wordRelationCoordinates[word]!.add(
                Coordinates(
                  x: originWordIndex, 
                  y: wordIndex
                )
              );
            }
          });
        });
      }
    });

    return wordRelationCoordinates;
  }
  




}


final generator = CrucigramGenerator(["ana", "rana", "anastasia", "rama"]);
