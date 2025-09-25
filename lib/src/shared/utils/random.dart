
import 'dart:math';

T getRandomListItem<T>(List<T> list) {

  var random = Random();
  final length = list.length; 

  if(length > 1) {
    final randomIndex = random.nextInt(length);
    return list[randomIndex];
  } else {
    return list[0];
  }
}