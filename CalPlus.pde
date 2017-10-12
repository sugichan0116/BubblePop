Space space;
int selected = -1;
float dragX, dragY;
int AnimeSlide = 0;
int AnimeClear = 0;
int MoveID = 0, MoveDirection = -1;

void setup() {
  size(480, 320);
  space = new Space(72.f, 72.f, 64.f, color(255, 255, 0), color(0, 128, 0));
  space.List.add(new Number(3, 0, 1, false, false));
  space.List.add(new Number(5, 0, 0, true, false));
  space.List.add(new Number(4, 1, 1, false, false));
  space.List.add(new Number(2, 5, 1, true, false));
  space.List.add(new Number(7, 3, 3, false, false));
  
}

void draw() {
  background(255);
  if(space.Draw(MoveDirection, MoveID)) MoveDirection = MoveID = -1;
  if(AnimeSlide > 0) { //selected >= 0) {
    for(int n = 0; n < 4; n++) {
      arcText(((space.ListIsTurn(selected)) ? "x" : "+"), space.ListX(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * cos(HALF_PI * n),
        space.ListY(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * sin(HALF_PI * n),
        16f * ((direction(dragX, dragY) == n * 2 && dist(mouseX, mouseY, dragX, dragY) >= space.r * 0.4f) ? 2f : 1f),
        (space.direction(n * 2, selected)) ? ((space.ListIsTurn(selected)) ? color(0, 100, 200) : color(200, 100, 0)) : color(128));
      arcText(((space.ListIsTurn(selected)) ? "+" : "x"), space.ListX(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * cos(PI / 4f + HALF_PI * n),
        space.ListY(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * sin(PI / 4f + HALF_PI * n),
        16f * ((direction(dragX, dragY) == n * 2 + 1 && dist(mouseX, mouseY, dragX, dragY) >= space.r * 0.4f) ? 2f : 1f),
        (space.direction(n * 2 + 1, selected)) ? ((space.ListIsTurn(selected)) ? color(200, 100, 0) : color(0, 100, 200)) : color(128));
    }
  }
  if(selected != -1) {
    if(mousePressed == true) AnimeSlide = constrain(AnimeSlide + 1, 0, space.AnimeTime);
    else AnimeSlide = constrain(AnimeSlide - 1, 0, space.AnimeTime);
  }
  if(AnimeSlide == 0) selected = -1;
  
  pushStyle();
  {
    float textX = 10f, textY = 10f;
    String Text = "Clear all bubble !";
    noStroke();
    fill(space.Color[0]);
    rect(textX, textY, textWidth(Text), 24f);
    stroke(space. Color[0]);
    noFill();
    rect(textX - 2f, textY - 2f, textWidth(Text) + 3f, 24f + 3f);
    noStroke();
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    text(Text, textX + 6, textY);
  }
  popStyle();
  
  if(space.List.size() == 0) {
    AnimeClear++;
    pushStyle();
    {
      float textX = width / 2f, textY = height / 2f;
      String Text = "Clear!";
      
      noStroke();
      fill(space.Color[9], map(AnimeClear, 0, frameRate, 0f, 255f));
      textSize(48);
      textAlign(CENTER, CENTER);
      for(int n = 0; n < Text.length(); n++) {
        text(Text.charAt(n), textX + map( n, 0, Text.length(), -textWidth(Text) / 2f, textWidth(Text) / 2f),
          textY - max( 0f, ( AnimeClear - n * 5 ) * (frameRate - ( AnimeClear - n * 5 )) / frameRate));
      }
    }
    popStyle();
  }
}

void mousePressed() {
  selected = space.inRange();
  dragX = mouseX;
  dragY = mouseY;
}

void mouseDragged() {
  
}

void mouseReleased() {
  if(space.direction(direction(dragX, dragY), selected)) {
    MoveDirection = direction(dragX, dragY);
    MoveID = selected;
    space.AnimeMove = 0;
  } else MoveDirection = -1;
}

int direction(float startX, float startY) {
  float vectorX = mouseX - startX, vectorY = mouseY - startY;
  for(int n = 0; n < 8; n++) {
    if((cos(PI / 4f * float(n)) * vectorX + sin(PI / 4f * float(n)) * vectorY) / dist(0f, 0f, vectorX, vectorY) >= cos(PI / 8f)) {
      return n;
    }
  }
  return -1;
}

void arcText(String c, float x, float y, float r, color Color) {
  pushStyle();
    noStroke();
    fill(Color);
    ellipseMode(CENTER);
    ellipse(x, y, r, r);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(r);
    text(c, x, y - r * .2f);
  popStyle();
}