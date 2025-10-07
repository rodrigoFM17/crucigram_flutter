
import 'dart:ffi';

import 'package:pdf_test/src/features/crucigrams_v2/domain/model/coordinates.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/enum/orientation.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/node.dart';

class CrucigramTree {

  Node root;
  late List<List<String?>> charactersMatrix;

  CrucigramTree({required this.root}) {
    charactersMatrix = getCharactersMatrix();
  }

  List<List<String?>> getCharactersMatrix() {

    Map<String, Coordinates> wordCoordinatesInMatrix = {};
    charactersMatrix = [];
    root.executeInNodes(CrucigramTree.addWordToMatrix, charactersMatrix, wordCoordinatesInMatrix);
    return charactersMatrix;

  }

  static void addWordToMatrix(Node node, List<List<String?>> charactersMatrix, Map<String, Coordinates> wordCoordinatesInMatrix) {

  
    charactersMatrix.forEach((row) {
      print(row);
    });
    final currentWord = node.value;
    final charactersList = currentWord.split("");

    final wordCoordinates2 = node.parent?.getCoordinates(node.value);
    final parentWordCoordinates2 = wordCoordinatesInMatrix[node.parent?.value];

    print("currentWord: $currentWord");
    print("orientation: ${node.orientation}");
    print("parentWord: ${node.parent?.value}");
    print("parentWordCoordinates: $parentWordCoordinates2");
    print("wordCoordinates: $wordCoordinates2");

    if(charactersMatrix.isEmpty) {
      if(node.orientation == Orientation.horizontal) {
        charactersMatrix.add(node.value.split(""));
      } else {
        charactersList.forEach((character) => charactersMatrix.add([character]));
      }
      wordCoordinatesInMatrix[currentWord] = Coordinates(x: 0, y: 0);

    } else  {

      final wordCoordinates = node.parent!.getCoordinates(node.value);
      final currentParentWord = node.parent!.value;
      Coordinates parentWordCoordinates = wordCoordinatesInMatrix[currentParentWord]!;
      final xLength = charactersMatrix.first.length;
      final yLength = charactersMatrix.length;
      int initialX = 0;
      int initialY = 0;

      int finalX = 0;
      int finalY = 0;

      if (node.orientation == Orientation.horizontal) {

        final diffLeft = wordCoordinates.y;
        final diffRight = currentWord.length - diffLeft - 1;
        int matrixDiffLeft = parentWordCoordinates.x - diffLeft;
        int matrixDiffRight = parentWordCoordinates.x + currentWord.length - diffLeft - xLength;

        print("parentWordCoordinates: $parentWordCoordinates");
        print("diffLeft: $diffLeft");
        print("diffRight: $diffRight");
        print("matrixDiffLeft: $matrixDiffLeft");
        print("matrixDiffRight: $matrixDiffRight");
        print("initialX: $initialX");
        print("initialY: $initialY");

        // verificar que la matriz tiene espacio a la izquierda
        if(matrixDiffLeft < 0) {
          // si no anadir espacio rellenando con null
          charactersMatrix.forEach((row) {
            for(int i = 0; i < matrixDiffLeft.abs(); i++){
              row.insert(0, null as String?);
            }
          });
          parentWordCoordinates.x += diffLeft.abs();
        }
        if(matrixDiffRight > 0) {
          charactersMatrix.forEach((row) {
            for(int i = 0; i < matrixDiffRight; i++){
              row.add(null as String?);
            }
          });
        }
        
        initialX = parentWordCoordinates.x;
        initialY = parentWordCoordinates.y + wordCoordinates.x; 

        finalX = initialX - diffLeft;
        finalY = initialY;

        // colocar caracteres a la izquierda
        for(int i = diffLeft; i > 0; i--) {
          charactersMatrix[initialY][initialX - i] = charactersList[diffLeft - i];
        }

        // colocar caracteres a la derecha
        for(int i = wordCoordinates.y + 1; i < currentWord.length; i++) {
          charactersMatrix[initialY][initialX + i - wordCoordinates.y] = charactersList[i];
        }

        

      } else {
        
        final diffTop = wordCoordinates.y;
        final diffBottom = currentWord.length - diffTop - 1;
        final matrixDiffTop = parentWordCoordinates.y - diffTop;
        final matrixDiffBottom = parentWordCoordinates.y + currentWord.length - diffTop - yLength;

        

        print("diffTop: $diffTop");
        print("diffBottom: $diffBottom");
        print("matrixDiffTop: $matrixDiffTop");
        print("matrixDiffBottom: $matrixDiffBottom");

        if(matrixDiffTop < 0) {
          for(int i = 0; i < matrixDiffTop.abs(); i++) {
            charactersMatrix.insert(0, List<String?>.filled(xLength, null, growable: true));
            parentWordCoordinates.y += 1;
          }
        }
        if(matrixDiffBottom > 0) {
          for(int i = 0; i < matrixDiffBottom.abs(); i++) {
            charactersMatrix.add(List<String?>.filled(xLength, null, growable: true));
          }
        }

        initialX = parentWordCoordinates.x + wordCoordinates.x;
        initialY = parentWordCoordinates.y; 

        finalX = initialX;
        finalY = parentWordCoordinates.y - diffTop;

        print("initialX: $initialX");
        print("initialY: $initialY");

        // colocar caracteres arriba
        for(int i = 1; i <= diffTop; i++) {
          charactersMatrix[initialY - i][initialX] = charactersList[diffTop - i];
        }

        // colocar caracteres abajo
        for(int i = 0; i <= diffBottom; i++) {
          charactersMatrix[initialY + i][initialX] = charactersList[currentWord.length - 1 - diffBottom + i];
        }

        
        
      }

      charactersMatrix.forEach((row) {
        print(row);
      });
      print("\n\n");


      wordCoordinatesInMatrix[currentWord] = Coordinates(x: finalX, y: finalY);
    }
  }

}
