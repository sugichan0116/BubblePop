class Swipe {
  int x, y, d;
  Swipe() {
    x = y = 0;
    d = -1;
  }
  Swipe(int X, int Y, int Direction) {
    x = X;
    y = Y;
    d = Direction;
  }
  void Copy(Swipe origin) {
    x = origin.x;
    y = origin.y;
    d = origin.d;
  }
}