import 'dart:math';

enum Orientation {
  vertical,
  horizontal;

  Orientation rotate() {
    return this == Orientation.vertical ? Orientation.horizontal : Orientation.vertical;
  }

  static Orientation getRandomOrientation() {
    return Random().nextInt(100) >= 50 ? Orientation.vertical : Orientation.horizontal;
  }
}