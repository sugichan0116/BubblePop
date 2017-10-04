
class Space {
  ArrayList List;
  color[] Color;
  float x, y, r;
  float radiusRate = 0.4f;
  int AnimeTime = 10;
  int AnimeMove = 0;
  Space() {
    List = new ArrayList();
    Color = new color[10];
    for(int n = 0; n < 10; n++) {
      Color[n] = color(map(n, 0, 10, 128, 0));
    }
  }
  Space(float X, float Y, float R, color LowColor, color HighColor) {
    x = X;
    y = Y;
    r = R;
    List = new ArrayList();
    Color = new color[10];
    for(int n = 0; n < 10; n++) {
      Color[n] = color(map(n, 0, 10, red(LowColor), red(HighColor)),
        map(n, 0, 10, green(LowColor), green(HighColor)),
        map(n, 0, 10, blue(LowColor), blue(HighColor)));
    }
  }
  boolean Draw(int MoveDirection, int selectID) {
    int moveX = 0, moveY = 0;
    boolean moveFlag = false;
    for(int n = List.size() - 1; n >= 0; n--) {
      Number Buf;
      Buf = (Number) List.get(n);
      if(inRange(n)) Buf.Anime = constrain(Buf.Anime + 1, 0, AnimeTime);
      else Buf.Anime = constrain(Buf.Anime - 1, 0, AnimeTime);
      Buf.Update(AnimeTime);
      moveX = moveY = 0;
      if(selectID == n) {
        AnimeMove += 4;
        switch(MoveDirection) {
          
          case 0:
            moveX = AnimeMove;
            moveY = 0;
            break;
          case 1:
            moveX = AnimeMove;
            moveY = AnimeMove;
            break;
          case 2:
            moveX = 0;
            moveY = AnimeMove;
            break;
          case 3:
            moveX = -AnimeMove;
            moveY = AnimeMove;
            break;
          case 4:
            moveX = -AnimeMove;
            moveY = 0;
            break;
          case 5:
            moveX = -AnimeMove;
            moveY = -AnimeMove;
            break;
          case 6:
            moveX = 0;
            moveY = -AnimeMove;
            break;
          case 7:
            moveX = AnimeMove;
            moveY = -AnimeMove;
            break;
          
        }
        for(int i = 0; i < List.size(); i++) {
          if(i != n) {
            if(dist(moveX + ListX(n), moveY + ListY(n), ListX(i), ListY(i)) < 1f) {
              Number Target = (Number) List.get(i);
              Target.num = ((MoveDirection % 2 == 0) ^ Buf.isTurn) ? (Buf.num + Target.num) : (Buf.num * Target.num);
              Target.AddedTime++; //Animation Process
              Buf.num = 0;
              List.set(i, (Number) Target);
              List.set(n, (Number) Buf);
              AnimeMove = 0;
              moveFlag = true;
            }
          }
        }
      }
      Buf.Draw(x + moveX, y + moveY, r * radiusRate, r, Color[Buf.num % 10], AnimeTime);
      //if(Buf.num == 0) List.remove(n);
    }
    for(int n = List.size() - 1; n >= 0; n--) {
      Number Buf = (Number) List.get(n);
      if(Buf.num == 0) List.remove(n);
    }
    return moveFlag;
  }
  boolean inRange(int id) {
    if(id < 0 || List.size() <= id) return false;
    return (dist(mouseX, mouseY, ListX(id), ListY(id)) < r * radiusRate);
  }
  int inRange() {
    for(int n = 0; n < List.size(); n++) {
      if(inRange(n)) return n;
    }
    return -1;
  }
  float ListX (int id) {
    if(id < 0 || List.size() <= id) return float(0);
    Number Buf;
    Buf = (Number) List.get(id);
    return (float)Buf.x * r + x;
  }
  float ListY (int id) {
    if(id < 0 || List.size() <= id) return float(0);
    Number Buf;
    Buf = (Number) List.get(id);
    return (float)Buf.y * r + y;
  }
  boolean ListIsTurn (int id) {
    if(id < 0 || List.size() <= id) return false;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.isTurn;
  }
  int Anime (int id) {
    if(id < 0 || List.size() <= id) return 0;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.Anime;
  }
  boolean direction(int directID, int id) {
    if(id < 0 || List.size() <= id) return false;
    
    Number Target = (Number) List.get(id), Buf;
    for(int n = 0; n < List.size(); n++) {
      if(n != id) {
        Buf = (Number) List.get(n);
        switch(directID) {
          case 0:
            if((Buf.x - Target.x) > 0 && Target.y == Buf.y) {
              return true;
            }
            break;
          case 5:
            if((Buf.x - Target.x) == (Buf.y - Target.y) && Target.x > Buf.x) {
              return true;
            }
            break;
          case 2:
            if((Buf.y - Target.y) > 0 && Target.x == Buf.x) {
              return true;
            }
            break;
          case 7:
            if((Buf.x - Target.x) == -(Buf.y - Target.y) && Target.x < Buf.x) {
              return true;
            }
            break;
          case 4:
            if((Buf.x - Target.x) < 0 && Target.y == Buf.y) {
              return true;
            }
            break;
          case 3:
            if((Buf.x - Target.x) == -(Buf.y - Target.y) && Target.x > Buf.x) {
              return true;
            }
            break;
          case 6:
            if((Buf.y - Target.y) < 0 && Target.x == Buf.x) {
              return true;
            }
            break;
          case 1:
            if((Buf.x - Target.x) == (Buf.y - Target.y) && Target.x < Buf.x) {
              return true;
            }
            break;
        }
      }
    }
    return false;
  }
}