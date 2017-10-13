
void LeftMenu() {
  //左メニュー
  {
    String MenuText[] = {"Undo", "Reset", "Redo", "Hint"};
    
    pushStyle();
    for(int n = 0; n < 4; n++) {
      noStroke();
      fill(space.Color[n]);
      ellipseMode(CENTER);
      if(isOverMenuLeft) {
        if(dist(mouseX, mouseY, menuRadius / 2f, height - menuRadius * (float(n) + 0.5f)) < menuRadius * 0.3f) {
          stroke(space.Color[9 - n]);
          noFill();
          arc(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
          height - menuRadius * (float(n) + 0.5f), menuRadius * 0.6f + 4f, menuRadius * 0.6f + 4f, 0f, TAU);
          noStroke();
          fill(space.Color[9 - n]);
          boxText(MenuText[n], menuRadius, mouseY, 12, 0, space.Color[9 - n]);
         
        }
      }
      ellipse(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
        height - menuRadius * (float(n) + 0.5f), menuRadius * 0.6f, menuRadius * 0.6f);
      
      noStroke();
      fill(255);
      switch(n) {
        case 0:
          arrow(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(0));
          break;
        case 1:
          
          square(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(45));
          break;
        case 2:
          arrow(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(180));
          break;
        case 3:
          lamp(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(0));
      }
      
      
      pushStyle();
        textAlign(RIGHT, BOTTOM);
        textSize(18);
        fill(space.Color[0]);
        noStroke();
        text("History : " + currentHistory + " / " + History.size(), width + map(AnimeMenuLeft, 0, space.AnimeTime, width * .4f, 0), height);
      popStyle();
      
      if(AnimeMenuLeft == space.AnimeTime / 2f) {
        snd[6].play();
        snd[6].cue(100);
      }
    }
    popStyle();
    if(isOverMenuLeft) {
      if(mouseX > menuRadius) isOverMenuLeft = false;
      
      AnimeMenuLeft = constrain(AnimeMenuLeft + 1, 0, space.AnimeTime);
    } else {
      if(mouseX < menuRadius) {
        isOverMenuLeft = true;
      } else {
        AnimeMenuLeft = constrain(AnimeMenuLeft - 1, 0, space.AnimeTime);
      }
    }
    
  }
}

void RightMenu() {
  //右メニュー
  {
    String MenuText[] = {"Back", "Home", "Next"};
    
    pushStyle();
    for(int n = 0; n < 3; n++) {
      noStroke();
      fill(space.Color[9 - n]);
      ellipseMode(CENTER);
      if(isOverMenuRight) {
        if(dist(mouseX, mouseY, width - menuRadius / 2f, height - menuRadius * (float(n) + 0.5f)) < menuRadius * 0.3f) {
          stroke(space.Color[n]);
          noFill();
          arc(width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
          height - menuRadius * (float(n) + 0.5f), menuRadius * 0.6f + 4f, menuRadius * 0.6f + 4f, 0f, TAU);
          noStroke();
          fill(space.Color[n]);
          boxText(MenuText[n], width - menuRadius * 1.5f, mouseY, 12, 0, space.Color[n]);
          
        }
      }
      ellipse(width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
        height - menuRadius * (float(n) + 0.5f), menuRadius * 0.6f, menuRadius * 0.6f);
      
      noStroke();
      fill(255);
      switch(n) {
        case 0:
          polygon(3, width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(180));
          break;
        case 1:
          
          home(width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(0));
          break;
        case 2:
          polygon(3, width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (float(n) + 0.5f), menuRadius * 0.15f, radians(0));
          break;
      }
      
      if(AnimeMenuRight == space.AnimeTime / 2f) {
        snd[6].play();
        snd[6].cue(100);
      }
    }
    popStyle();
    if(isOverMenuRight) {
      if(mouseX < width - menuRadius) isOverMenuRight = false;
      
      AnimeMenuRight = constrain(AnimeMenuRight + 1, 0, space.AnimeTime);
    } else {
      if(mouseX > width - menuRadius) {
        isOverMenuRight = true;
      } else {
        AnimeMenuRight = constrain(AnimeMenuRight - 1, 0, space.AnimeTime);
      }
    }
  }
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

boolean distMouse(float x, float y, float r) {
  return (dist(mouseX, mouseY, x, y) < r);
}

boolean button(float x, float y, float r, color OutColor, color InColor) {
  boolean flag = false;
  pushMatrix();
  pushStyle();
    translate(x, y);
    ellipseMode(RADIUS);
    if(dist(mouseX, mouseY, x, y) < r) {
      noStroke();
      fill(InColor);
      arc( 0f, 0f, r, r, 0f, TAU );
      noFill();
      stroke(InColor);
      arc( 0f, 0f, r + PI * 0.75f, r + PI * 0.75f, 0f, TAU );
      flag = true;
    } else {
      noStroke();
      fill(OutColor);
      arc( 0f, 0f, r, r, 0f, TAU );
    }
  popStyle();
  popMatrix();
  return flag;
}

void boxText(String Text, float x, float y, int fontSize, int maxWidth, color Color) {
  pushStyle();
  {
    textSize(fontSize);
    if(maxWidth > 0) {
      if(textWidth(Text) > maxWidth) {
        fontSize = int(maxWidth / textWidth(Text) * fontSize);
        textSize(fontSize);
      }
    }
    noStroke();
    fill(Color);
    rect(x, y, textWidth(Text), fontSize);
    stroke(Color);
    noFill();
    rect(x - 2f, y - 2f, textWidth(Text) + 4f, fontSize + 3f);
    noStroke();
    fill(255);
    textAlign(LEFT, TOP);
    text(Text, x, y - 2);
  }
  popStyle();
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
    text(c, x, y - r * .15f);
  popStyle();
}