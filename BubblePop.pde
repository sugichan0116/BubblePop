import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer snd[];

ArrayList stage;
ArrayList History;
int currentHistory;
boolean isValidHistory;
String[] reader;
String[] fileOver;

int playStage = 0;
int mode = 0;
int stageRank = 0;

Space space;
int selected = -1;
float dragX, dragY;
int AnimeSlide = 0;
int AnimeClear = 0;
int MoveID = 0, MoveDirection = -1;
boolean mouseOver = false;
int HintTime = 0;
int HintID = 0;

int AnimeMenuLeft = 0, AnimeMenuRight = 0;
float menuRadius = 64f;
boolean isOverMenuLeft = false, isOverMenuRight = false;

int AnimeTitle = 0;
float arrayX[] = { .2f, .5f, .8f, .35f, .65f, .2f, .5f, .8f };
float arrayY[] = { .4f, .4f, .4f, .6f, .6f, .8f, .8f, .8f };
String seas[] = { "Blue Sea", "Green Sea", "Red Sea", "Black Sea" };
String seasDescription[] = { "For Beginner & Normal Bubble", "A Little Difficult & Turned Bubble Join!", "Complex Puzzle & Locked Bubble Join!", "Extra Stage & Free Edit" };
color seaColor[] = { color(0, 100, 200), color(0, 200, 60), color(200, 50, 20), color(50, 50, 50) };
color seaWideColor[] = { color(0, 40, 30), color(0, 30, 40), color(20, 20, 10), color(50, 50, 50) };
int selectSea = 0;
int seaSlide = 0;
boolean isOverSea = false;
int titleShift = 0;

void setup() {
  size(480, 320);
  
  //音声読み込み
  minim = new Minim(this);
  snd = new AudioPlayer[16];
  snd[0] = minim.loadFile("sound/swipe.mp3");
  snd[1] = minim.loadFile("sound/clear.mp3");
  snd[2] = minim.loadFile("sound/failed.mp3");
  snd[3] = minim.loadFile("sound/marge.mp3");
  snd[4] = minim.loadFile("sound/pop.mp3");
  snd[5] = minim.loadFile("sound/select.mp3");  snd[5].setGain(-5);
  snd[6] = minim.loadFile("sound/menu.mp3");
  snd[7] = minim.loadFile("sound/menupress.mp3");
  snd[8] = minim.loadFile("sound/seaselect.mp3");  snd[8].setGain(-10);
  snd[9] = minim.loadFile("sound/seaswitch.mp3");
  snd[10] = minim.loadFile("sound/title.mp3"); snd[10].cue(200);
  snd[11] = minim.loadFile("sound/stageselect.mp3");
  
  //ステージ読み込み
  space = new Space();
  stage = new ArrayList();
  History = new ArrayList();
  currentHistory = 0;
  isValidHistory = false;
  
  fileOver = loadStrings("setting/data.dat");
  
  for(int fileNum = 0; fileNum < fileOver.length; fileNum++){
    //１ファイル読み込み
    if(fileOver[fileNum].equals("")) continue;
    reader = loadStrings("setting/" + fileOver[fileNum]);
    String lineString;
    Space fileSpace = new Space();
    int lineNum = 0;
    int entry = -1;
    String[] heading = { "[comment]", "[color]", "[number]", "[hint]" };
    boolean isChanged = false;
    
    while(true) {
      lineString = reader[lineNum];
      isChanged = false;
      
      for(int n = 0; n < heading.length; n++) {
        if(lineString.equals(heading[n])) { entry = n; lineNum++; isChanged = true; break; }
      }
      if(isChanged) {
        continue;
      }
      
      //println(lineString);
      String[] comp = split(lineString, ", ");
      switch(entry) {
        case 0:
          if(comp.length != 1) break;
          fileSpace.setComment(comp[0]);
          break;
        case 1:
          if(comp.length != 6) break;
          fileSpace.setColor(color(int(comp[0]), int(comp[1]), int(comp[2])),
            color(int(comp[3]), int(comp[4]), int(comp[5])));
          break;
        case 2:
          if(comp.length != 5) break;
          fileSpace.List.add(new Number(int(comp[0]), int(comp[1]), int(comp[2]),
            boolean(comp[3]), boolean(comp[4]) ));
          break;
        case 3:
          if(comp.length != 3) break;
          fileSpace.setHint(int(comp[0]), int(comp[1]), int(comp[2]));
          //println(lineString + "/" + comp[0] + "/" + comp[2]);
          break;
      }
      lineNum++;
      if(lineNum == reader.length) break;
    }
    fileSpace.optimis();
    stage.add(fileSpace);
  }
  
  //初期データ
  //space.Copy((Space) stage.get(playStage));
}

void draw() {
  background(255);
  switch(mode) {
    case 0:
      //タイトル
      for(int n = 0; n < height; n++) {
        stroke(0, 180, 255 - n, 70 + 10 * sin(radians(AnimeTitle * 2)));
        line(0, n, width, n);
      }
      stroke(0, 60 + 30 * cos(radians(AnimeTitle)), 150 + 100 * cos(radians(AnimeTitle * 2)), map(constrain(AnimeTitle, 0, 600), 0, 600, 0, 255));
      strokeWeight(2);
      noFill();
      ellipseMode(RADIUS);
      for(int n = 0; n < 2; n++) {
        if(n == 1) stroke(100, 100, 255);
        arc(width * 0.6f + 12 * cos(radians(AnimeTitle)) + 6 * cos(radians(AnimeTitle * 4)),
          map(constrain(AnimeTitle, 0, 120), 0, 120, height * 1.0f, height * 0.5f) + 4 * cos(radians(AnimeTitle * 5)),
          height * map(constrain(AnimeTitle, 0, 60), 0, 60, .0f, .2f) + n, height * map(constrain(AnimeTitle, 0, 60) + n, 0, 60, .0f, .2f), 0, TAU);
      }
      noStroke();
      fill(0, 60, 200, map(constrain(AnimeTitle, 0, 60), 0, 60, 0, 255));
      textSize(48);
      textAlign(CENTER, CENTER);
      text("Bubble", width * 0.4f, height * 0.4f);
      textSize(60);
      fill(0, 120, 250, map(constrain(AnimeTitle, 0, 60), 0, 60, 0, 255));
      text("Pop", width * 0.5f, height * 0.5f);
      fill(255);
      textSize(16);
      text(">> Click to Start <<", width * .5f, height * .8f);
      AnimeTitle++;
      if(titleShift > 0) {
        titleShift--;
        if(titleShift == 0) {
          mode = 1;
          AnimeTitle = 0;
          isValidHistory = false;
        }
      }
      
      break;
    case 1:
      //セレクト
      fill(128);
      
      int selectNumber = constrain(selectSea, 0, seaColor.length - 1);
      color primeColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * cos(radians(frameCount)));
      color secondColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * -cos(radians(frameCount)));
      
      arcText( "<", width * .1f, height * .6f, 48, primeColor);
      arcText( ">", width * .9f, height * .6f, 48, primeColor);
      capsule( "Sum of Stage : " + stage.size(), width * 0.8, height * 0.95, 12, primeColor );
        
      boolean overMouse;
      overMouse = false;
      for(int k = 0; k <= ceil(stage.size() / 8); k++) {
        
        selectNumber = constrain(k, 0, seaColor.length - 1);
        primeColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * cos(radians(frameCount)),
          green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * cos(radians(frameCount)),
          blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * cos(radians(frameCount)));
        secondColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
          green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
          blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * -cos(radians(frameCount)));
        
        capsule( seas[selectNumber], width * ( .5f + -selectSea + k) + seaSlide, height * .1f, 48, primeColor);
        capsule( seasDescription[selectNumber], width * ( .5f + -selectSea + k) + seaSlide, height * .22f, 12, primeColor);
        
        
        for(int n = 0; n < 8; n++) {
          if(k * 8 + n >= stage.size()) break;
          fill(secondColor);
          strokeWeight(1);
          stroke(secondColor);
          ellipseMode(RADIUS);
          textAlign(CENTER, CENTER);
          if(dist(mouseX, mouseY, width * arrayX[n], height * arrayY[n]) < 24f && k == selectSea) {
            
            textSize(map(AnimeTitle, 0, 10, 18, 36));
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n],
              map(AnimeTitle, 0, 10, 12f, 24f), map(AnimeTitle, 0, 10, 12f, 24f), 0f, TAU);
            noFill();
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 24f + 4f, 24f + 4f, 0f, TAU);
            
            capsule(((Space)stage.get(n + k * 8)).comment, width * ( arrayX[n] - .5f) / 2f + width / 2f, height * arrayY[n] - 36,
              int(map(AnimeTitle, 0, 10, 1, 18)), secondColor);
            overMouse = true;
          } else {
            
            textSize(18);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f, 12f, 0f, TAU);
            noFill();
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f + 2f, 12f + 2f, 0f, TAU);
            
          }
          fill(255);
          text("" + (n + 1 + k * 8), float(width) * ( arrayX[n] + float(-selectSea + k)) + seaSlide, float(height) * arrayY[n] - 2);
          
        }
        
      }
      
      if(!isOverSea && overMouse) {
        //ならす
        snd[8].play();
        snd[8].cue(100);
      }
      isOverSea = overMouse;
      
      if(seaSlide < 0) seaSlide += abs(seaSlide / 8) + 1;
      else if(seaSlide > 0) seaSlide -= abs(seaSlide / 8) + 1;
      
      if(overMouse) AnimeTitle = constrain(AnimeTitle + 1, 0, 10);
      else AnimeTitle = constrain(AnimeTitle - 1, 0, 10);
        
      break;
    case 2:
      //プレイ
      if(isValidHistory == false) {
        isValidHistory = true;
        History.clear();
        currentHistory = 0;
        
        Space HisBuf = new Space();
        HisBuf.Copy(space);
        HisBuf.afterProcess();
        History.add((Space) HisBuf);
        currentHistory++;
        HintID = 0;
      }
      
      if(space.Draw(MoveDirection, MoveID)) MoveDirection = MoveID = -1;
      if(AnimeSlide > 0) { //selected >= 0) {
        for(int n = 0; n < 4; n++) {
          arcText(((space.ListIsLocked(selected)) ? "" : ((space.ListIsTurn(selected)) ? "x" : "+")),
            space.ListX(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * cos(HALF_PI * n),
            space.ListY(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * sin(HALF_PI * n),
            16f * ((direction(dragX, dragY) == n * 2 && dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate) ? 2f : 1f),
            (space.direction(n * 2, selected)) ? ((space.ListIsTurn(selected)) ? color(0, 100, 200) : color(200, 100, 0)) : color(128));
          arcText(((space.ListIsLocked(selected)) ? "" : ((space.ListIsTurn(selected)) ? "+" : "x")),
            space.ListX(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * cos(PI / 4f + HALF_PI * n),
            space.ListY(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * sin(PI / 4f + HALF_PI * n),
            16f * ((direction(dragX, dragY) == n * 2 + 1 && dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate) ? 2f : 1f),
            (space.direction(n * 2 + 1, selected)) ? ((space.ListIsTurn(selected)) ? color(200, 100, 0) : color(0, 100, 200)) : color(128));
        }
      }
      if(selected != -1) {
        if(mousePressed == true) AnimeSlide = constrain(AnimeSlide + 1, 0, space.AnimeTime);
        else AnimeSlide = constrain(AnimeSlide - 1, 0, space.AnimeTime);
      }
      if(AnimeSlide == 0) selected = -1;
      
      boxText(nf(playStage + 1, 2) + " : " + space.comment, 8f, 8f, 24, width - 16, space.Color[0]);
      
      
      if(HintTime > 0) {
        HintTime--;
        if(currentHistory == 1 && space.Hint.size() != 0) {
          for(int n = 0; n <= min(HintID - 1, min( space.Hint.size() - 1, floor((( space.Hint.size() ) * 30 - HintTime) / 30))); n++) {
            pushStyle();
            stroke(255);
            strokeWeight(5);
            noFill();
            
            Swipe Hint = (Swipe) space.Hint.get(n);
            arc(Hint.x * space.r + space.x, Hint.y * space.r + space.y, space.r * 0.5f + 3f, space.r * 0.5f + 3f, 0f, TAU);
            strokeWeight(1);
            stroke(space.Color[9]);
            noFill();
            arc(Hint.x * space.r + space.x, Hint.y * space.r + space.y, space.r * 0.5f, space.r * 0.5f, 0f, TAU);
            fill(255);
            noStroke();
            vectorArrow(Hint.x * space.r + space.x, Hint.y * space.r + space.y, 64f + 8f, radians(45 * Hint.d));
            fill(space.Color[9]);
            noStroke();
            vectorArrow(Hint.x * space.r + space.x, Hint.y * space.r + space.y, 64f, radians(45 * Hint.d));
            capsule("One More Tap will show More Hint!", width * .5f, height * .15f, 12, space.Color[9]);
            popStyle();
          }
        } else {
          capsule("Show Hint to Reset or Hint doesn't exsist.", width * .5f, height * .15f, 12, 0);
        }
      }
      
      
      //クリア判定
      if(space.isClear() || space.isFailed()) {
        if(AnimeClear == 1) {
          if(space.isClear()) {
            snd[1].play();
            snd[1].rewind();
          }
          else if(space.isFailed()) {
            snd[2].play();
            snd[2].rewind();
          }
          isValidHistory = false;
        }
        AnimeClear++;
        pushStyle();
        {
          float textX = width / 2f, textY = height / 2f;
          String Text = ((space.isClear()) ? "Clear!" : "Failed...");
          float widthBuf = 0;
          
          noStroke();
          fill(lerpColor(space.Color[0], space.Color[9], float(abs(frameCount % 60 - 30)) / 30f), map(AnimeClear, 0, frameRate, 0f, 255f));
          textSize(48);
          textAlign(LEFT, CENTER);
          for(int n = 0; n < Text.length(); n++) {
            
            text(Text.charAt(n), textX - textWidth(Text) / 2f + widthBuf,
              textY - max( 0f, ( AnimeClear - n * 5 ) * (frameRate - ( AnimeClear - n * 5 )) / frameRate));
              
            widthBuf += textWidth(Text.charAt(n));
          }
        }
        popStyle();
        
        if(AnimeClear > frameRate * 4) {
          if(space.isClear()) playStage++;
          playStage %= stage.size();
          space.Copy((Space) stage.get(playStage));
          isValidHistory = false;
          AnimeClear = 0;
        }
      }
      
      if(space.inRange() != -1) {
        if(mouseOver == false) {
          snd[5].play();
          snd[5].cue(150);
        }
        mouseOver = true;
      } else mouseOver = false;
      
      LeftMenu();
      RightMenu();
      break;
    
  }
}

void stop() {
  for(AudioPlayer Buf: snd) {
    Buf.close();
  }
  minim.stop();
  super.stop();
}

void mousePressed() {
  switch(mode) {
    case 0:
      titleShift = 60;
      snd[10].play();
      snd[10].cue(100);
      break;
    case 1:
      if(dist(mouseX, mouseY, width * .1f, height * .6f) < 24f && selectSea != 0) {
        selectSea = constrain(selectSea - 1, 0, floor(stage.size() / 8));
        seaSlide = -width;
        snd[9].play();
        snd[9].cue(100);
        
      }
      if(dist(mouseX, mouseY, width * .9f, height * .6f) < 24f && selectSea != floor(stage.size() / 8)) {
        selectSea = constrain(selectSea + 1, 0, floor(stage.size() / 8));
        seaSlide = width;
        snd[9].play();
        snd[9].cue(100);
      }
      
      for(int n = 0; n < 8; n++) {
        if(dist(mouseX, mouseY, width * arrayX[n], height * arrayY[n]) < 24f && n + selectSea * 8 < stage.size()) {
            playStage = n + selectSea * 8;
            space.Copy((Space) stage.get(playStage));
            mode = 2;
            snd[10].play();
            snd[10].cue(100);
            isValidHistory = false;
        }
      }
      break;
    case 2:
      selected = space.inRange();
      dragX = mouseX;
      dragY = mouseY;
      if(selected != -1) {
        snd[4].play();
        snd[4].cue(100);
      }
      
      for(int n = 0; n < 4; n++) {
        if(isOverMenuLeft) {
          if(dist(mouseX, mouseY, menuRadius / 2f, height - menuRadius * (float(n) + 0.5f)) < menuRadius * 0.3f) {
            
            snd[7].play();
            snd[7].cue(50);
            
            //ボタンの機能実装部
            switch(n) {
              case 0:
                if(History.size() != 0) {
                  //if(currentHistory == History.size()) {
                  //  Space Buf = new Space();
                  //  Buf.Copy(space);
                  //  History.add((Space) Buf);
                  //  currentHistory++;
                  //}
                  currentHistory = constrain(currentHistory - 1, 1, History.size());
                  space.Copy((Space) History.get(currentHistory - 1));
                }
                break;
              case 1:
                space.Copy((Space) stage.get(playStage));
                isValidHistory = false;
                break;
              case 2:
                if(History.size() != 0) {
                  currentHistory = constrain(currentHistory + 1, 1, History.size());
                  space.Copy((Space) History.get(currentHistory - 1));
                }
                break;
              case 3:
                HintTime = 30 * ( space.Hint.size() + 1);
                HintID++;
            }
          }
        }
        
        if(isOverMenuRight) {
          if(dist(mouseX, mouseY, width - menuRadius / 2f, height - menuRadius * (float(n) + 0.5f)) < menuRadius * 0.3f) {
            
            snd[7].play();
            snd[7].cue(50);
            
            //ボタンの機能実装部
            switch(n) {
              case 0:
                playStage = playStage + stage.size() - 1;
                playStage %= stage.size();
                space.Copy((Space) stage.get(playStage));
                isValidHistory = false;
                break;
              case 1:
                mode = 1;
                isValidHistory = false;
                break;
              case 2:
                playStage++;
                playStage %= stage.size();
                space.Copy((Space) stage.get(playStage));
                isValidHistory = false;
                break;
            }
          }
        }
      }
      break;
  }
}

void mouseDragged() {
  
}

void mouseReleased() {
  if(space.direction(direction(dragX, dragY), selected) && dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate) {
    MoveDirection = direction(dragX, dragY);
    MoveID = selected;
    space.AnimeMove = 0;
    snd[0].play();
    snd[0].cue(200);
    
  } else MoveDirection = -1;
}