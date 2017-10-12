class Number {
  int num;
  int x, y;
  boolean isTurn, isLocked;

  int Anime; //マウスオーバー用
  int AddedTime; //演算時用
  float Rota; //恒常アニメ用
  Number() {
    num = 0;
    x = y = 0;
    isTurn = isLocked = false;

    Anime = 0;
    AddedTime = 0;
  }
  Number(int Num, int X, int Y) {
    num = Num;
    x = X;
    y = Y;
    isTurn = isLocked = false;

    Anime = 0;
    AddedTime = 0;
  }
  Number(int Num, int X, int Y, boolean IsTurn, boolean IsLocked) {
    num = Num;
    x = X;
    y = Y;
    isTurn = IsTurn;
    isLocked = IsLocked;

    Anime = 0;
    AddedTime = 0;
  }
  void Copy(Number origin) {
    num = origin.num;
    x = origin.x;
    y = origin.y;
    isTurn = origin.isTurn;
    isLocked = origin.isLocked;
    Anime = AddedTime = 0;
    Rota = 0f;
  }
  void Draw(float X, float Y, float R, float L, color Color, int AnimeTime) {
    if (num < 1) return;
    if (num % 10 == 0) R = R * map(AddedTime, 0, AnimeTime * 2, 1.f, 0.f);
    else if (AddedTime > 0) R += -AddedTime * (AddedTime - AnimeTime * 2) / AnimeTime;
    pushStyle();
    pushMatrix();
    {
      translate((float)x * L + X, (float)y * L + Y);
      switch(int(isLocked)) {
      case 0:
        switch(int(isTurn)) {
        case 0: //丸
          noStroke();
          fill(Color);
          ellipseMode(RADIUS);
          ellipse(0f, 0f, map(Anime, 0, AnimeTime, R, 0.f), map(Anime, 0, AnimeTime, R, 0.f));

          stroke(Color);
          noFill();
          ellipse(0f, 0f, map(Anime, 0, AnimeTime, 0.f, R * 0.8f), map(Anime, 0, AnimeTime, 0.f, R * 0.8f));

          for (int n = 0; n < 4; n++) {
            arc(0f, 0f, R + 2f + map(Anime, 0, AnimeTime, 0f, -4f), R + 2f + map(Anime, 0f, AnimeTime, 0f, -4f), 
              Rota + HALF_PI * float(n - 1) + map(Anime, 0, AnimeTime, 0.f, QUARTER_PI), Rota + HALF_PI * float(n));
          }

          fill(map(Anime, 0, AnimeTime, 255, red(Color)), 
            map(Anime, 0, AnimeTime, 255, green(Color)), 
            map(Anime, 0, AnimeTime, 255, blue(Color)));
          textSize(R);
          textAlign(CENTER, CENTER);
          text(num, 0f, - R * .1f);
          break;

        case 1: //四角
          noStroke();
          fill(Color);
          square(0f, 0f, map(Anime, 0, AnimeTime, R, 0f), HALF_PI / 2f);

          stroke(Color);
          noFill();
          square(0f, 0f, map(Anime, 0, AnimeTime, R + 3f, 0f), HALF_PI / 2f);

          for (int n = 0; n < 4; n++) {
            fragment(R * cos(HALF_PI * float(n) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f)) * 1.2f * map(Anime, 0, AnimeTime, 1f, .8f), 
              R * sin(HALF_PI * float(n) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f)) * 1.2f * map(Anime, 0, AnimeTime, 1f, .8f), 
              R * 0.3f, HALF_PI * (1.5f + float(n)) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f));
          }
          fill(map(Anime, 0, AnimeTime, 255, red(Color)), 
            map(Anime, 0, AnimeTime, 255, green(Color)), 
            map(Anime, 0, AnimeTime, 255, blue(Color)));
          textSize(R);
          textAlign(CENTER, CENTER);
          text(num, - R * .05f, - R * .1f);
          break;
        }
        break;
      case 1:
        noStroke();
        fill(Color);
        hexagon(0f, 0f, map(Anime, 0, AnimeTime, R, 0f), 0f);

        stroke(Color);
        noFill();
        hexagon(0f, 0f, map(Anime, 0, AnimeTime, R + 3f, 0f), 0f);

        for (int n = 0; n < 12; n++) {
          //fragment(R * cos(HALF_PI * float(n) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f)) * 1.2f * map(Anime, 0, AnimeTime, 1f, .8f), 
          //  R * sin(HALF_PI * float(n) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f)) * 1.2f * map(Anime, 0, AnimeTime, 1f, .8f), 
          //  R * 0.3f, HALF_PI * (1.5f + float(n)) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f));
          stroke(Color, map(Anime, 0, AnimeTime, 0f, 255f));
          
          fill(Color, map(Anime, 0, AnimeTime, 0f, 255f));
          rock(R * ( 1f - pow( map(constrain(Anime - AnimeTime * (n % 2) / 2.7f, 0, AnimeTime / 1.5f), 0, AnimeTime / 1.5f, 0f, 1f), 4f ) ) * cos(radians(30) * n + map(Anime, 0, AnimeTime, radians(30), 0f)),
               R * ( 1f - pow( map(constrain(Anime - AnimeTime * (n % 2) / 2.7f, 0, AnimeTime / 1.5f), 0, AnimeTime / 1.5f, 0f, 1f), 4f ) ) * sin(radians(30) * n + map(Anime, 0, AnimeTime, radians(30), 0f)),
               R, radians(30) * n  + map(Anime, 0, AnimeTime, radians(30), 0f));
        }
        fill(255);
        textSize(R);
        textAlign(CENTER, CENTER);
        text(num, - R * .05f, - R * .1f);
        break;
      }
      //演算の波紋アニメーション
      stroke(Color);//map(AddedTime, 0, AnimeTime * 2, 255f, 0f));
      noFill();
      ellipse(0f, 0f, map(AddedTime, 0, AnimeTime * 2, 0.f, L), map(AddedTime, 0, AnimeTime * 2, 0.f, L));
    }
    popMatrix();
    popStyle();
  }
  void Update(int AnimeTime) {
    Rota += PI / 180.f;
    if (AddedTime > 0) AddedTime++;
    if (AddedTime >= AnimeTime * 2) { 
      num = num % 10;
      AddedTime = 0;
    }
  }
  void afterProcess() {
    num = num % 10;
  }
  
}