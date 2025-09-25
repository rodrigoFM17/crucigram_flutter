
import 'dart:math';

import 'package:pdf_test/src/features/crucigrams_v2/domain/model/coordinates.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/crucigram_tree.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/edge.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/enum/orientation.dart';
import 'package:pdf_test/src/features/crucigrams_v2/domain/model/node.dart';
import 'package:pdf_test/src/shared/utils/random.dart';

class CrucigramGenerator {

  late List<String> wordsForCrucigram;
  late Map<String, Map<String, List<Coordinates>>> relationsMatrix;
  late Map<String, Map<String, List<Coordinates>>> relationsMatrixForTree;
  late CrucigramTree crucigramTree;
  

  CrucigramGenerator(List<String> words) {

    wordsForCrucigram = words;
    relationsMatrix = {};
    words.forEach((w)  {
      relationsMatrix[w] = _getRelationsForWord(w, words);
    });
    relationsMatrixForTree = Map.from(relationsMatrix);
    print(relationsMatrix);

    crucigramTree = generateCrucigramTree();
  }

  CrucigramTree generateCrucigramTree() {

    final wordWithMoreRelations = getWordWithMoreRelations();

    final root = Node(
      value: wordWithMoreRelations, 
      orientation: Orientation.getRandomOrientation(),
      parent: null,
      edges: []
    );
    relationsMatrixForTree.remove(wordWithMoreRelations);

    String currentWord = wordWithMoreRelations;
    Node currentNode = root;

    while(relationsMatrixForTree.entries.isNotEmpty) {

      print("currentWord: $currentWord");

      final exclusiveWords = getWordsWithRelationOnlyWithCurrentWord(currentWord);
      if(exclusiveWords.isNotEmpty) {
        exclusiveWords.forEach((exclusiveWord) {
          print(exclusiveWord);
          setEdgeNode(currentNode, currentWord, exclusiveWord);
        });
      } else {

        int i = relationsMatrixForTree.entries.length > 1 ? getRandomInt() : 1;
        for(int j = 1; j <= i; j++) {
          print(i);
          final randomWord = getRandomWordFromRelationMatrix();
          print(randomWord);
          setEdgeNode(currentNode, currentWord, randomWord);
        }
      }

      final randomNode = root.getRandomLeaf();
      currentNode = randomNode;
      currentWord = randomNode.value;
    }

    return CrucigramTree(root: root);
  }

  void setEdgeNode(Node node, String currentWord, String word) {

    var randomCoordinates;
    do {
      randomCoordinates = getRandomListItem(relationsMatrix[currentWord]![word]!);
    } while( node.isCoordinatesBusy(randomCoordinates));
    final exclusiveWordNode = Node(
      parent: node,
      value: word,
      orientation: node.orientation.rotate(),
      edges: []
    );
    node.edges.add(Edge(
      edge: randomCoordinates, 
      node: exclusiveWordNode
    ));

    relationsMatrixForTree.remove(word);
  }

  String getRandomWordFromRelationMatrix() {

    return getRandomListItem(relationsMatrixForTree.entries.toList()).key;
  }

  List<String> getWordsWithRelationOnlyWithCurrentWord(String currentWord) {

    List<String> wordsWithOnlyRelation = [];
    relationsMatrixForTree.entries.forEach((relation) {

      bool exclusive = true;
      relation.value.entries.forEach((coordinates) {
        exclusive = exclusive && coordinates.value.isEmpty && (coordinates.key == currentWord || coordinates.key == relation.key);
      });
      if(exclusive) {
        wordsWithOnlyRelation.add(relation.key);
      }
    });

    return wordsWithOnlyRelation;
  }

  String getWordWithMoreRelations() {

    List<String> wordWithMoreRelations = [];
    int i = 0;

    relationsMatrixForTree.entries.forEach((wordRelations) {
      int j = 0;
      wordRelations.value.entries.forEach((relations) {
        j += relations.value.length;
      });

      if(i == j) {
        wordWithMoreRelations.add(wordRelations.key);
        i = j;
      } else if ( j > i) {
        wordWithMoreRelations = [wordRelations.key];
        i = j;
      }
    });

    return getRandomListItem(wordWithMoreRelations);
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

  int getRandomInt() {
    final random = Random();
    final randomInt = random.nextInt(100);
    return randomInt >= 70 ? 1 : 2;
  }
}

main() {
  final generator = CrucigramGenerator(["ana", "rana", "anastasia", "rama"]);

  print(generator.crucigramTree.root);

  final crucigramMatrix = generator.crucigramTree.getCharactersMatrix();

  crucigramMatrix.forEach((row) {
    print(row);
  });
}

