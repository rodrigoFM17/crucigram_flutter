class Coordinates {

  int x; // indice del caracter de la palabra de origen
  int y; // indice del caracter de la palabra relacionada

  Coordinates({
    required this.x,
    required this.y
  });

  @override
  String toString() {
    return "{x:$x, y:$y}";
  }
  
}

