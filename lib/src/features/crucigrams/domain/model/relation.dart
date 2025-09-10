
import 'coordinates.dart';
import 'word.dart';

class Relation {
  final String word;
  List<Coordinates> coordinates;

  Relation({
    required this.word,
    required this.coordinates
  });

  factory Relation.fromWords(Word word, List<String> words) {

    return Relation(
      word: word, 
      coordinates: _getCoordinates(word, words)
    );
  }


  static List<Coordinates> _getCoordinates(Word wordParam, List<String> words) {

    final originWordChars = wordParam.value.split("");
    final List<Coordinates> coordinates = [];
    

    words.forEach((word) {

      if(word != wordParam) {
        
        final wordChars = word.split("");

        originWordChars.asMap().forEach((originWordIndex, originWordChar) {

          wordChars.asMap().forEach((wordIndex, wordChar) {
            if(originWordChar == wordChar) {
              coordinates.add(
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
    return coordinates;
  }


}