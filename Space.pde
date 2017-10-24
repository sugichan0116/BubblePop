
class Space {
  ArrayList List;
  color[] Color;
  float x, y, r;
  float radiusRate;
  int AnimeTime;
  int AnimeMove;
  String comment;
  ArrayList Hint;
  Space() {
    List = new ArrayList();
    Color = new color[10];
    for(int n = 0; n < 10; n++) {
      Color[n] = color(map(n, 0, 10, 128, 0));
    }
    x = y = r = 0;
    radiusRate = 0.4f;
    AnimeTime = 10;
    AnimeMove = 0;
    comment = "";
    Hint = new ArrayList();
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
    radiusRate = 0.4f;
    AnimeTime = 10;
    AnimeMove = 0;
    comment = "";
    Hint = new ArrayList();
  }
  void setColor(color LowColor, color HighColor) {
    for(int n = 0; n < 10; n++) {
      Color[n] = color(map(n, 0, 10, red(LowColor), red(HighColor)),
        map(n, 0, 10, green(LowColor), green(HighColor)),
        map(n, 0, 10, blue(LowColor), blue(HighColor)));
    }
  }
  void setComment(String Text) {
    comment = Text;
  }
  void setHint(int hintX, int hintY, int hintDirection) {
    if(hintDirection == -1) return;
    Swipe Buf = new Swipe(hintX, hintY, hintDirection);
    Hint.add(Buf);
  }
  void Copy(Space origin) {
    if(origin == null) return;
    List.clear();
    for(int n = 0; n < origin.List.size(); n++) {
      Number Buf = new Number();
      Buf.Copy((Number) origin.List.get(n));
      List.add(Buf);
    }
    for(int n = 0; n < 10; n++) {
      Color[n] = origin.Color[n];
    }
    x = origin.x;
    y = origin.y;
    r = origin.r;
    comment = origin.comment;
    AnimeMove = 0;
    Hint.clear();
    for(int n = 0; n < origin.Hint.size(); n++) {
      Swipe Buf = new Swipe();
      Buf.Copy((Swipe) origin.Hint.get(n));
      Hint.add(Buf);
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
        AnimeMove += 4f * RateY;
        
        if(AnimeMove >= r) {
          AnimeMove = 0;
          ((Number) List.get(selectID)).x += directionX(MoveDirection);
          ((Number) List.get(selectID)).y += directionY(MoveDirection);
          
        }
        moveX = directionX(MoveDirection) * AnimeMove;
        moveY = directionY(MoveDirection) * AnimeMove;
        
        for(int i = 0; i < List.size(); i++) {
          if(i != n) {
            if(dist(moveX + ListX(n), moveY + ListY(n), ListX(i), ListY(i)) < 1f  * RateY) {
              Number Target = (Number) List.get(i);
              
              Buf.num = ((MoveDirection % 2 == 0) ^ Buf.isTurn) ? (Buf.num + Target.num) : (Buf.num * Target.num);
              Buf.AddedTime++; //Animation Process
              Buf.x = Target.x; Buf.y = Target.y; moveX = moveY = 0;
              Target.num = 0;
              List.set(i, (Number) Target);
              List.set(n, (Number) Buf);
              AnimeMove = 0;
              moveFlag = true;
              snd[3].play();
              snd[3].cue(100);
              if(currentHistory < History.size() && History.size() != 0) {
                for(int np = History.size(); np > currentHistory; np--) { 
                  History.remove(np - 1);
                }
              }
              Space HisBuf = new Space();
              HisBuf.Copy(space);
              HisBuf.afterProcess(); //一桁処理後を保存
              History.add((Space) HisBuf);
              currentHistory++;
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
  void afterProcess() {
    for(int n = 0; n < List.size(); n++) {
      ((Number) List.get(n)).afterProcess();
    }
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
  int ListNum (int id) {
    if(id < 0 || List.size() <= id) return 0;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.num;
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
  boolean ListIsLocked (int id) {
    if(id < 0 || List.size() <= id) return false;
    Number Buf;
    Buf = (Number) List.get(id);
    return (Buf.isLocked);
  }
  
  int Anime (int id) {
    if(id < 0 || List.size() <= id) return 0;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.Anime;
  }
  int directionX(int directID) {
    switch (directID) {
      case 0:
      case 1:
      case 7:
        return 1;
      case 3:
      case 4:
      case 5:
        return -1;
    }
    return 0;
  }
  int directionY(int directID) {
    switch (directID) {
      case 1:
      case 2:
      case 3:
        return 1;
      case 5:
      case 6:
      case 7:
        return -1;
    }
    return 0;
  }
  boolean direction(int directID, int id) {
    if(id < 0 || List.size() <= id) return false;
    
    Number Target = (Number) List.get(id), Buf;
    if((Target.isLocked)) return false;
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
  boolean isClear() {
    int element = List.size();
    for(int n = 0; n < List.size(); n++) {
      Number Buf = (Number) List.get(n);
      if(Buf.num % 10 == 0) {
        element--;
      }
    }
    return (element == 0);
  }
  boolean isFailed() {
    if(isClear()) return false;
    for(int n = 0; n < List.size(); n++) {
      for(int k = 0; k < 8; k++) {
        if(direction(k, n)) return false;
      }
    }
    return true;
  }
  void optimis() {
    if(List.size() == 0) return;
    Number Init;
    Init = (Number) List.get(0);
    int leftX = Init.x, rightX = Init.x;
    int topY = Init.y, bottomY = Init.y;
    
    for(int n = 0; n < List.size(); n++) {
      Number Buf = (Number) List.get(n);
      leftX = min(leftX, Buf.x);
      rightX = max(rightX, Buf.x);
      topY = min(topY, Buf.y);
      bottomY = max(bottomY, Buf.y);
    }
    
    x = width * .5f;
    y = height * .55f;
    r = 64f * RateY;
    if(64f * RateY * (rightX - leftX) > width * 0.8f ) {
      r = min( r, width * 0.8f / (rightX - leftX) );
    }
    
    if(64f * RateY * (bottomY - topY) > height * 0.6f ) {
      r = min( r, height * 0.6f / (bottomY - topY) );
    }
    
    x -= r * (rightX - leftX) / 2f;
    y -= r * (bottomY - topY) / 2f;
    
    for(int n = 0; n < List.size(); n++) {
      ((Number) List.get(n)).x -= leftX;
      ((Number) List.get(n)).y -= topY;
      
    }
    
  }
}