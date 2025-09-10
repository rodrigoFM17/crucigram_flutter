
import 'word.dart';

class Coordinates {

  final int x; // indice del caracter de la palabra de origen
  final int y; // indice del caracter de la palabra relacionada

  Coordinates({
    required this.x,
    required this.y
  });

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

