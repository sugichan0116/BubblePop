import controlP5.*;
ControlP5 cp5;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;

import ddf.minim.*;

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
String seasDescription[] = { "For Beginner & Normal Bubble",
  "A Little Difficult & Turned Bubble Join!",
  "Complex Puzzle & Locked Bubble Join!",
  "Extra Stage & Free Edit" };
color seaColor[] = { color(0, 100, 200), color(0, 200, 60), color(200, 50, 20), color(50, 50, 50) };
color seaWideColor[] = { color(0, 40, 30), color(0, 30, 40), color(20, 20, 10), color(50, 50, 50) };
int selectSea = 0;
int seaSlide = 0;
boolean isOverSea = false;
int titleShift = 0;

Space Edit;
color LowColor, HighColor;
boolean whichColor = false;
int RedBar, GreenBar, BlueBar;
int BubbleMode = 0;
int BubbleNumber = 1;
String Title = "";
Space Board;
Space Select;
boolean isEdit = false;
boolean isTest = false;

float RateX, RateY;
int screenPreWidth = 0, screenPreHeight = 0;

void setup() {
  //size(480, 320);
  size(960, 640);
  //fullScreen(P2D, 2);
  RateX = float(width) / 480f;
  RateY = float(height) / 320f;
  
  
  frame.setResizable(true);
  frame.addComponentListener(new ComponentAdapter() {
    public void componentResized(ComponentEvent e) {
      if (e.getSource()==frame) {
        redraw();
      }
    }
  }
  );
  
  //音声読み込み
  String soundPath = dataPath("") + "//sound/";
  minim = new Minim(this);
  snd = new AudioPlayer[16];
  snd[0] = minim.loadFile(soundPath + "swipe.mp3");
  snd[1] = minim.loadFile(soundPath + "clear.mp3");
  snd[2] = minim.loadFile(soundPath + "failed.mp3");
  snd[3] = minim.loadFile(soundPath + "marge.mp3");
  snd[4] = minim.loadFile(soundPath + "pop.mp3");
  snd[5] = minim.loadFile(soundPath + "select.mp3");  snd[5].setGain(-5);
  snd[6] = minim.loadFile(soundPath + "menu.mp3");
  snd[7] = minim.loadFile(soundPath + "menupress.mp3");
  snd[8] = minim.loadFile(soundPath + "seaselect.mp3");  snd[8].setGain(-10);
  snd[9] = minim.loadFile(soundPath + "seaswitch.mp3");
  snd[10] = minim.loadFile(soundPath + "title.mp3"); snd[10].cue(200);
  snd[11] = minim.loadFile(soundPath + "stageselect.mp3");
  
  //GUI読み込み
  cp5 = new ControlP5(this);
  
  cp5.addSlider("RedBar")
    .setLabel("R")
    .setPosition(10, 10)
    .setSize(128, 10)
    .setRange(0, 255)
    .setValue(0)
    .setColorActive(color(128, 0, 0))
    .setColorBackground(color(32, 0, 0))
    .setColorForeground(color(128))
    .setColorLabel(color(0))
    .setColorValue(color(255))
    .hide()
    ;
  cp5.addSlider("GreenBar")
    .setLabel("G")
    .setPosition(10, 25)
    .setSize(128, 10)
    .setRange(0, 255)
    .setValue(0)
    .setColorActive(color(128, 0, 0))
    .setColorBackground(color(32, 0, 0))
    .setColorForeground(color(128))
    .setColorLabel(color(0))
    .setColorValue(color(255))
    .hide()
    ;
  cp5.addSlider("BlueBar")
    .setLabel("B")
    .setPosition(10, 40)
    .setSize(128, 10)
    .setRange(0, 255)
    .setValue(0)
    .setColorActive(color(128, 0, 0))
    .setColorBackground(color(32, 0, 0))
    .setColorForeground(color(128))
    .setColorLabel(color(0))
    .setColorValue(color(255))
    .hide()
    ;
  
  cp5.addTextfield("Title")
    .setLabelVisible(false)
    .setLabel("")
    .setText("")
    .setPosition(width * .4f - 10, 10)
    .setSize( int(width * .6f), 24)
    .setFont(createFont("BookAntiqua", 18))
    .setFocus(true)
    .setColor(color(255))
    .hide()
    ;
  
  Edit = new Space(0f, 0f, 32f, color(0), color(0));
  Board = new Space(width * 0.02f + width * .82 / 9f * 0.4f, height * .9f, width * .82f / 9f, color(0), color(0));
  for(int n = 1; n < 10; n++) Board.List.add( new Number(n, n - 1, 0, false, false));
  Select = new Space(width - 32 * RateX, 60 * RateY, width * .82f / 9f, color(0), color(0));
  Select.List.add(new Number(1, 0, 0, false, false));
  Board.List.add(new Number(1, 0, -1, false, true));
  Board.List.add(new Number(1, 0, -2, true, false));
  Board.List.add(new Number(1, 0, -3, false, false));
  
  
  //ステージ読み込み
  space = new Space();
  stage = new ArrayList();
  History = new ArrayList();
  currentHistory = 0;
  isValidHistory = false;
  
  fileOver = loadStrings(dataPath("") + "//setting/data.dat");
  
  for(int fileNum = 0; fileNum < fileOver.length; fileNum++){
    //１ファイル読み込み
    if(fileOver[fileNum].equals("")) continue;
    reader = loadStrings(dataPath("") + "//setting/" + fileOver[fileNum]);
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
  
}

boolean isChangedScreen() {
  boolean isChanged = ((screenPreWidth != width) || (screenPreHeight != height));
  screenPreWidth = width; screenPreHeight  = height;
  return isChanged;
}

void draw() {
  if(isChangedScreen()) {
    RateX = float(width) / 480f;
    RateY = float(height) / 320f;
    menuRadius = 64f * RateY;
    space.optimis();
    for(Object Buf :stage) {
      ((Space) Buf).optimis();
    }
    Edit.optimis();
    cp5.getController("RedBar").setSize(int(128 * RateX), int(10 * RateY));
    cp5.getController("RedBar").setPosition(int(10 * RateX), int(10 * RateY));
    cp5.getController("GreenBar").setSize(int(128 * RateX), int(10 * RateY));
    cp5.getController("GreenBar").setPosition(int(10 * RateX), int(25 * RateY));
    cp5.getController("BlueBar").setSize(int(128 * RateX), int(10 * RateY));
    cp5.getController("BlueBar").setPosition(int(10 * RateX), int(40 * RateY));
    cp5.getController("Title").setSize(int(width * .6f), int(24 * RateY));
    cp5.getController("Title").setPosition(int(width * .4f - 10 * RateX), int(10 * RateY));
    cp5.getController("Title").setFont(createFont("BookAntiqua", 18 * RateY));
    Board.x = width * 0.02f + width * .82 / 9f * 0.4f;
    Board.y = height * .9f;
    Board.r = min(width * .82f / 9f, height * .5f / 4f);
    Select.x = width - 32 * RateX;
    Select.y = 120 * RateY;
    Select.r = min(width * .82f / 9f, height * .5f / 4f);
  }
  
  background(255);
  switch(mode) {
    case 0:
      //タイトル
      
      stroke(0, 60 + 30 * cos(radians(AnimeTitle)), 150 + 100 * cos(radians(AnimeTitle * 2)),
        map(constrain(AnimeTitle, 0, 600), 0, 600, 0, 255));
      strokeWeight(2);
      noFill();
      ellipseMode(RADIUS);
      for(int n = 0; n < 2; n++) {
        if(n == 1) stroke(100, 100, 255);
        arc(width * 0.6f + 12 * cos(radians(AnimeTitle)) + 6 * cos(radians(AnimeTitle * 4)),
          map(constrain(AnimeTitle, 0, 120), 0, 120, height * 1.0f, height * 0.5f) + 4 * cos(radians(AnimeTitle * 5)),
          height * map(constrain(AnimeTitle, 0, 60), 0, 60, .0f, .2f) + n,
          height * map(constrain(AnimeTitle, 0, 60) + n, 0, 60, .0f, .2f), 0, TAU);
      }
      noStroke();
      fill(0, 60, 200, map(constrain(AnimeTitle, 0, 60), 0, 60, 0, 255));
      textSize(48 * RateX);
      textAlign(CENTER, CENTER);
      text("Bubble", width * 0.4f, height * 0.4f);
      textSize(60 * RateX);
      fill(0, 120, 250, map(constrain(AnimeTitle, 0, 60), 0, 60, 0, 255));
      text("Pop", width * 0.5f, height * 0.5f);
      fill(255);
      textSize(16 * RateX);
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
      int selectNumber = constrain(selectSea, 0, seaColor.length - 1);
      color primeColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * cos(radians(frameCount)));
      color secondColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * -cos(radians(frameCount)));
      
      fill(255);
      textSize(48 * RateY);
      textAlign(CENTER, CENTER);
      button(width * .1f, height * .6f, 24f * RateY, primeColor, secondColor);
      text("<", width * .1f - 2f * RateY, height * .6f - 8f * RateY);
      button(width * .9f, height * .6f, 24f * RateY, primeColor, secondColor);
      text(">", width * .9f + 2f * RateY, height * .6f - 8f * RateY);
      if(button(width * .9f, height * .1f, 24f * RateY, primeColor, secondColor)) 
        boxText("Edit Mode", width * .83f, height * .20f, int(12 * RateY), 0, secondColor);
      noStroke();
      fill(255);
      note( width * .9f, height * .1f, 12f * RateY, 0f );
      capsule( "Sum of Stage : " + stage.size(), width * 0.8, height * 0.95, int(12 * RateY), primeColor );
        
      boolean overMouse;
      overMouse = false;
      for(int k = 0; k <= ceil((stage.size() - 1) / 8); k++) {
        
        selectNumber = constrain(k, 0, seaColor.length - 1);
        primeColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * cos(radians(frameCount)),
          green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * cos(radians(frameCount)),
          blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * cos(radians(frameCount)));
        secondColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
          green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
          blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * -cos(radians(frameCount)));
        
        capsule( seas[selectNumber], width * ( .5f + -selectSea + k) + seaSlide, height * .1f, int(48 * RateY), primeColor);
        capsule( seasDescription[selectNumber], width * ( .5f + -selectSea + k) + seaSlide, height * .22f, int(12 * RateY), primeColor);
        
        
        for(int n = 0; n < 8; n++) {
          if(k * 8 + n >= stage.size()) break;
          fill(secondColor);
          strokeWeight(1 * RateY);
          stroke(secondColor);
          ellipseMode(RADIUS);
          textAlign(CENTER, CENTER);
          if(dist(mouseX, mouseY, width * arrayX[n], height * arrayY[n]) < 24f * RateY && k == selectSea) {
            
            textSize(map(AnimeTitle, 0, 10, 18, 36) * RateY);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n],
              map(AnimeTitle, 0, 10, 12f, 24f) * RateY, map(AnimeTitle, 0, 10, 12f, 24f) * RateY, 0f, TAU);
            noFill();
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 24f * RateY + 4f, 24f * RateY + 4f, 0f, TAU);
            
            capsule(((Space)stage.get(n + k * 8)).comment, width * ( arrayX[n] - .5f) / 2f + width / 2f, height * arrayY[n] - 36 * RateY,
              int(map(AnimeTitle, 0, 10, 1, 18) * RateY), secondColor);
            overMouse = true;
          } else {
            
            textSize(18 * RateY);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f * RateY, 12f * RateY, 0f, TAU);
            noFill();
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f * RateY + 2f, 12f * RateY + 2f, 0f, TAU);
            
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
            space.ListX(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * RateY * cos(HALF_PI * n),
            space.ListY(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * RateY * sin(HALF_PI * n),
            16f * RateY * ((direction(dragX, dragY) == n * 2 && dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate) ? 2f : 1f),
            (space.direction(n * 2, selected)) ? ((space.ListIsTurn(selected)) ? color(0, 100, 200) : color(200, 100, 0)) : color(128));
          arcText(((space.ListIsLocked(selected)) ? "" : ((space.ListIsTurn(selected)) ? "+" : "x")),
            space.ListX(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * RateY * cos(PI / 4f + HALF_PI * n),
            space.ListY(selected) + map(AnimeSlide, 0, space.AnimeTime, 0f, 1.f) * 38f * RateY * sin(PI / 4f + HALF_PI * n),
            16f * RateY * ((direction(dragX, dragY) == n * 2 + 1 && dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate) ? 2f : 1f),
            (space.direction(n * 2 + 1, selected)) ? ((space.ListIsTurn(selected)) ? color(200, 100, 0) : color(0, 100, 200)) : color(128));
        }
      }
      if(selected != -1) {
        if(mousePressed == true) AnimeSlide = constrain(AnimeSlide + 1, 0, space.AnimeTime);
        else AnimeSlide = constrain(AnimeSlide - 1, 0, space.AnimeTime);
      }
      if(AnimeSlide == 0) selected = -1;
      
      boxText(((isEdit) ? "TestPlay" : nf(playStage + 1, 2)) + " : " + space.comment, 8f, 8f, int(24 * RateY), width - 16, space.Color[0]);
      
      
      if(HintTime > 0) {
        HintTime--;
        if(currentHistory == 1 && space.Hint.size() != 0) {
          for(int n = 0; n <= min(HintID - 1, min( space.Hint.size() - 1, floor((( space.Hint.size() ) * 30 - HintTime) / 30))); n++) {
            pushStyle();
            stroke(255);
            strokeWeight(5 * RateY);
            noFill();
            
            Swipe Hint = (Swipe) space.Hint.get(n);
            arc(Hint.x * space.r + space.x, Hint.y * space.r + space.y, space.r * 0.5f + 3f, space.r * 0.5f + 3f, 0f, TAU);
            strokeWeight(1 * RateY);
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
          textSize(48 * RateY);
          textAlign(LEFT, CENTER);
          for(int n = 0; n < Text.length(); n++) {
            
            text(Text.charAt(n), textX - textWidth(Text) / 2f + widthBuf,
              textY - max( 0f, ( AnimeClear - n * 5 ) * (frameRate - ( AnimeClear - n * 5 )) / frameRate));
              
            widthBuf += textWidth(Text.charAt(n));
          }
        }
        popStyle();
        
        if(AnimeClear > frameRate * 4) {
          isValidHistory = false;
          AnimeClear = 0;
          if(isEdit) {
            mode = 3;
            isTest = true;
            //hint生成
          } else {
            if(space.isClear()) playStage++;
            playStage %= stage.size();
            space.Copy((Space) stage.get(playStage));
          }
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
    case 3:
      if(!isEdit) {
        isEdit = true;
        Edit = new Space(0f, 0f, 48f * RateY, color(0), color(0));
      }
      Edit.setColor(LowColor, HighColor);
      Board.setColor(LowColor, HighColor);
      Select.setColor(LowColor, HighColor);
      Edit.setComment(Title);
      
      fill(0);
      textSize(18 * RateX);
      textAlign(RIGHT, TOP);
      text(((Title == "") ? "No Title (Input Name & Press Enter)" : "[ " + Title + " ]"), width - 10 * RateX, 40 * RateY);
      
      if(whichColor) HighColor = color(RedBar, GreenBar, BlueBar);
      else LowColor = color(RedBar, GreenBar, BlueBar);
      
      if(button(width * .05f, height * .25f, 12f * RateY, LowColor, LowColor) || !whichColor) 
        boxText("Lower Color", width * .09f, height * .25f - 6f * RateY, int(12 * RateY), 0, LowColor);
      
      if(button(width * .05f, height * .35f, 12f * RateY, HighColor, HighColor) || whichColor) 
        boxText("Higher Color", width * .09f, height * .35f - 6f * RateY, int(12 * RateY), 0, HighColor);
      
      Edit.Draw(-1, 0);
      Board.Draw(-1, 0);
      Select.Draw(-1, 0);
      
      if(button(width * .9f, height * .9f, 24f * RateY, color(0), color(100))) 
        boxTextRight("Home", width * .8f, height * .9f, int(12 * RateY), 0, color(100));
      noStroke();
      fill(255);
      home( width * .9f, height * .9f, int(12f * RateY), 0f );
      
      if(button(width * .9f, height * .73f, int(24f * RateY), color(0), color(100))) {
        boxTextRight("Test Play", width * .8f, height * .73f, int(12 * RateY), 0, color(100));
        if(Edit.List.size() <= 1) boxTextRight("Deploy more Bubble", width * .8f, height * .73f + 20 * RateY, int(12 * RateY), 0, color(100));
      }
      noStroke();
      fill(255);
      note( width * .9f, height * .73f, int(12f * RateY), 0f );
      
      if(button(width * .9f, height * .56f, int(24f * RateY), color(0), color(100))) { 
        boxTextRight("Save", width * .8f, height * .56f, int(12 * RateY), 0, color(100));
        if(!isTest) boxTextRight("Test didn't pass", width * .8f, height * .56f + 20 * RateY, int(12 * RateY), 0, color(100));
      }
      noStroke();
      fill(255);
      cardBoard( width * .9f, height * .56f - 2f, int((12f + 2f) * RateY), 0f );
      
      capsule("Current Bubble", Select.ListX(0) - 30 * RateX, Select.ListY(0) - 24 * RateY, int(12 * RateY), Edit.Color[BubbleNumber%10]);
      if(Select.inRange(0)) boxTextRight("Camera will be optimized", Select.ListX(0) - 28 * RateX, Select.ListY(0) - 6 * RateY, int(12 * RateY), 0, Select.Color[BubbleNumber%10]);
      
      
      break;
  }
  if(mode == 3) {
    cp5.getController("RedBar").show();
    cp5.getController("RedBar")
      .setColor(new CColor(color(RedBar, 0, 0), color(200),
      color(RedBar, 0, 0), color(0), color(255)));
    
    cp5.getController("GreenBar").show();
    cp5.getController("GreenBar")
      .setColor(new CColor(color(0, GreenBar, 0), color(200),
      color(0, GreenBar, 0), color(0), color(255)));
    
    cp5.getController("BlueBar").show();
    cp5.getController("BlueBar")
      .setColor(new CColor(color(0, 0, BlueBar), color(200),
      color(0, 0, BlueBar), color(0), color(255)));
    cp5.getController("Title").show();
    
    
  } else {
    cp5.getController("RedBar").hide();
    cp5.getController("GreenBar").hide();
    cp5.getController("BlueBar").hide();
    cp5.getController("Title").hide();
    
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
      if(dist(mouseX, mouseY, width * .1f, height * .6f) < 24f * RateY && selectSea != 0) {
        selectSea = constrain(selectSea - 1, 0, floor(stage.size() / 8));
        seaSlide = -width;
        snd[9].play();
        snd[9].cue(100);
        
      }
      if(dist(mouseX, mouseY, width * .9f, height * .6f) < 24f * RateY && selectSea != ceil((stage.size() - 1) / 8)) {
        selectSea = constrain(selectSea + 1, 0, ceil((stage.size() - 1) / 8));
        seaSlide = width;
        snd[9].play();
        snd[9].cue(100);
      }
      if(dist(mouseX, mouseY, width * .9f, height * .1f) < 24f * RateY) {
        mode = 3;
      }
      
      for(int n = 0; n < 8; n++) {
        if(dist(mouseX, mouseY, width * arrayX[n], height * arrayY[n]) < 24f * RateY && n + selectSea * 8 < stage.size()) {
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
          if(dist(mouseX, mouseY, menuRadius / 2f, height - menuRadius * (float(n) + 0.5f)) < menuRadius * 0.3f * RateY) {
            
            snd[7].play();
            snd[7].cue(50);
            
            //ボタンの機能実装部
            switch(n) {
              case 0:
                if(History.size() != 0) {
                  
                  currentHistory = constrain(currentHistory - 1, 1, History.size());
                  space.Copy((Space) History.get(currentHistory - 1));
                }
                break;
              case 1:
                if(isEdit) {
                  space.Copy(Edit);
                  space.optimis();
                } else {
                  space.Copy((Space) stage.get(playStage));
                }
                isValidHistory = false;
                break;
              case 2:
                if(History.size() != 0) {
                  currentHistory = constrain(currentHistory + 1, 1, History.size());
                  space.Copy((Space) History.get(currentHistory - 1));
                }
                break;
              case 3:
                if(isEdit) break;
                HintTime = 30 * ( space.Hint.size() + 1);
                HintID++;
                break;
            }
          }
        }
        
        if(isOverMenuRight) {
          if(dist(mouseX, mouseY, width - menuRadius / 2f, height - menuRadius * (float(n) + 0.5f)) < menuRadius * 0.3f * RateY) {
            
            snd[7].play();
            snd[7].cue(50);
            
            //ボタンの機能実装部
            switch(n) {
              case 0:
                if(isEdit) break;
                playStage = playStage + stage.size() - 1;
                playStage %= stage.size();
                space.Copy((Space) stage.get(playStage));
                isValidHistory = false;
                break;
              case 1:
                mode = 1;
                if(isEdit) mode = 3;
                isValidHistory = false;
                break;
              case 2:
                if(isEdit) break;
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
    case 3:
      boolean isChanged = false;
      if(distMouse(width * .9f, height * .9f, 24f * RateY)) {
        mode = 1;
        isEdit = false;
        isChanged = true;
      }
      
      if(distMouse(width * .9f, height * .73f, 24f * RateY)) {
        if(Edit.List.size() > 1) {
          mode = 2;
          isEdit = true;
          space.Copy(Edit);
          space.optimis();
        }
        isChanged = true;
      }
      
      if(distMouse(width * .9f, height * .56f, 24f * RateY)) {
        //保存処理
        if(isTest && !Edit.comment.equals("")) {
          Edit.optimis();
          //統括ファイルに追加
          try {
            BufferedWriter file = new BufferedWriter(new FileWriter(dataPath("") + "//setting/data.dat", true));
            file.write(Edit.comment + ".dat");
            file.newLine();
            file.close();
          } catch (IOException e) {
            e.printStackTrace();
          }
          //ステージファイル作成＆保存
          try {
            BufferedWriter file = new BufferedWriter(new FileWriter(dataPath("") + "//setting/" + Edit.comment + ".dat"));
            
            file.write("[comment]"); file.newLine();
            file.write(Edit.comment); file.newLine();
            file.write("[color]"); file.newLine();
            file.write(int(red(Edit.Color[0])) + ", " + int(green(Edit.Color[0])) + ", " +
              int(blue(Edit.Color[0])) + ", " + int(red(Edit.Color[9])) + ", " + 
              int(green(Edit.Color[9])) + ", " + int(blue(Edit.Color[9]))); file.newLine();
            file.write("[number]"); file.newLine();
            for(int n = 0; n < Edit.List.size(); n++) {
              file.write(((Number)Edit.List.get(n)).num + ", " + 
                ((Number)Edit.List.get(n)).x + ", " + 
                ((Number)Edit.List.get(n)).y + ", " + 
                ((Number)Edit.List.get(n)).isTurn + ", " + 
                ((Number)Edit.List.get(n)).isLocked); file.newLine();
            }
            
            file.close();
          } catch(IOException e) {
            e.printStackTrace();
          }
          
        }
        isChanged = true;
      }
      
      if(distMouse(width * .05f, height * .25f, 12f * RateY)) {
        whichColor = false;
        cp5.getController("RedBar").setValue(int(red(LowColor)));
        cp5.getController("GreenBar").setValue(int(green(LowColor)));
        cp5.getController("BlueBar").setValue(int(blue(LowColor)));
        
        isChanged = true;
      }
      if(distMouse(width * .05f, height * .35f, 12f * RateY)) {
        whichColor = true;
        cp5.getController("RedBar").setValue(int(red(HighColor)));
        cp5.getController("GreenBar").setValue(int(green(HighColor)));
        cp5.getController("BlueBar").setValue(int(blue(HighColor)));
        isChanged = true;
      }
      
      for(int n = 0; n < 9; n++) {
        if(Board.inRange(n)) {
          BubbleNumber = n + 1;
          isChanged = true;
        }
      }
      
      if(Select.inRange(0)) { Edit.optimis(); isChanged = true; }
      if(Board.inRange(9)) { BubbleMode = 2; isChanged = true; }
      if(Board.inRange(10)) { BubbleMode = 1; isChanged = true; }
      if(Board.inRange(11)) { BubbleMode = 0; isChanged = true; }
      
      for(int n = 0; n < 9; n++) {
        ((Number) Board.List.get(n)).isTurn = (BubbleMode == 1);
        ((Number) Board.List.get(n)).isLocked = (BubbleMode == 2);
        
      }
      ((Number) Select.List.get(0)).isTurn = (BubbleMode == 1);
      ((Number) Select.List.get(0)).isLocked = (BubbleMode == 2);
      ((Number) Select.List.get(0)).num = max(1, BubbleNumber);
      
      if(0 <= mouseX && 150 * RateX >= mouseX && 0 <= mouseY && mouseY <= 50 * RateX) isChanged = true;
      if(cp5.getController("RedBar").isMouseOver()) isChanged = true;
      if(cp5.getController("GreenBar").isMouseOver()) isChanged = true;
      if(cp5.getController("BlueBar").isMouseOver()) isChanged = true;
      
      for(int n = Edit.List.size() - 1; n >= 0; n--) {
        Number Buf = (Number) Edit.List.get(n);
        if(Buf.x == ceil((mouseX - Edit.x - Edit.r / 2f) / Edit.r) &&
          Buf.y == ceil((mouseY - Edit.y - Edit.r / 2f) / Edit.r)) {
            isChanged = true;
            Edit.List.remove(n);
        }
      }
      
      if(cp5.getController("Title").isMouseOver()) {
        
        isChanged = true;
      }
      
      if(!isChanged) {
        
        Edit.List.add(new Number(BubbleNumber, ceil((mouseX - Edit.x - Edit.r / 2f) / Edit.r), ceil((mouseY - Edit.y - Edit.r / 2f) / Edit.r),
          (BubbleMode == 1), (BubbleMode == 2)));
      }
      
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