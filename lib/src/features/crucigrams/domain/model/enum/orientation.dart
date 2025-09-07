
enum Orientation {

  horizontal,
  vertical;

  Orientation rotate() {

    if(this == horizontal) {
      return vertical;
    } else {
      return horizontal;
    }
  }

  static Orientation getRandomOrientation() {
    throw UnimplementedError();
  }
}