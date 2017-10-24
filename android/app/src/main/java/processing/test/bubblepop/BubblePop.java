package processing.test.bubblepop;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.io.FileWriter; 
import java.io.BufferedWriter; 
import java.io.IOException; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BubblePop extends PApplet {



ControlP5 cp5;












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
int seaColor[] = { color(0, 100, 200), color(0, 200, 60), color(200, 50, 20), color(50, 50, 50) };
int seaWideColor[] = { color(0, 40, 30), color(0, 30, 40), color(20, 20, 10), color(50, 50, 50) };
int selectSea = 0;
int seaSlide = 0;
boolean isOverSea = false;
int titleShift = 0;

Space Edit;
int LowColor, HighColor;
boolean whichColor = false;
int RedBar, GreenBar, BlueBar;
int BubbleMode = 0;
int BubbleNumber = 1;
String Title = "";
Space Board;
boolean isEdit = false;
boolean isTest = false;

public void setup() {
  
  
  //\u97f3\u58f0\u8aad\u307f\u8fbc\u307f
  String soundPath = "data/sound/";
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
  
  //GUI\u8aad\u307f\u8fbc\u307f
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
    .setSize( PApplet.parseInt(width * .6f), 24)
    .setFont(createFont("BookAntiqua", 18))
    .setFocus(true)
    .setColor(color(255))
    .hide()
    ;
  
  Edit = new Space(0f, 0f, 32f, color(0), color(0));
  Board = new Space(10 + width * .82f / 9f * 0.4f, height * .9f, width * .82f / 9f, color(0), color(0));
  for(int n = 1; n < 10; n++) Board.List.add( new Number(n, n - 1, 0, false, false));
  Board.List.add(new Number(1, 9, -4, false, false));
  Board.List.add(new Number(1, 0, -1, false, true));
  Board.List.add(new Number(1, 0, -2, true, false));
  Board.List.add(new Number(1, 0, -3, false, false));
  
  
  //\u30b9\u30c6\u30fc\u30b8\u8aad\u307f\u8fbc\u307f
  space = new Space();
  stage = new ArrayList();
  History = new ArrayList();
  currentHistory = 0;
  isValidHistory = false;
  
  fileOver = loadStrings("data/setting/data.dat");
  
  for(int fileNum = 0; fileNum < fileOver.length; fileNum++){
    //\uff11\u30d5\u30a1\u30a4\u30eb\u8aad\u307f\u8fbc\u307f
    if(fileOver[fileNum].equals("")) continue;
    reader = loadStrings("data/setting/" + fileOver[fileNum]);
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
          fileSpace.setColor(color(PApplet.parseInt(comp[0]), PApplet.parseInt(comp[1]), PApplet.parseInt(comp[2])),
            color(PApplet.parseInt(comp[3]), PApplet.parseInt(comp[4]), PApplet.parseInt(comp[5])));
          break;
        case 2:
          if(comp.length != 5) break;
          fileSpace.List.add(new Number(PApplet.parseInt(comp[0]), PApplet.parseInt(comp[1]), PApplet.parseInt(comp[2]),
            PApplet.parseBoolean(comp[3]), PApplet.parseBoolean(comp[4]) ));
          break;
        case 3:
          if(comp.length != 3) break;
          fileSpace.setHint(PApplet.parseInt(comp[0]), PApplet.parseInt(comp[1]), PApplet.parseInt(comp[2]));
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

public void draw() {
  background(255);
  switch(mode) {
    case 0:
      //\u30bf\u30a4\u30c8\u30eb
      for(int n = 0; n < height; n++) {
        stroke(0, 180, 255 - n, 70 + 10 * sin(radians(AnimeTitle * 2)));
        line(0, n, width, n);
      }
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
      //\u30bb\u30ec\u30af\u30c8
      int selectNumber = constrain(selectSea, 0, seaColor.length - 1);
      int primeColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * cos(radians(frameCount)));
      int secondColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * -cos(radians(frameCount)));
      
      fill(255);
      textSize(48);
      textAlign(CENTER, CENTER);
      button(width * .1f, height * .6f, 24f, primeColor, secondColor);
      text("<", width * .1f - 2f, height * .6f - 8f);
      button(width * .9f, height * .6f, 24f, primeColor, secondColor);
      text(">", width * .9f + 2f, height * .6f - 8f);
      if(button(width * .9f, height * .1f, 24f, primeColor, secondColor)) 
        boxText("Edit Mode", width * .83f, height * .20f, 12, 0, secondColor);
      noStroke();
      fill(255);
      note( width * .9f, height * .1f, 12f, 0f );
      capsule( "Sum of Stage : " + stage.size(), width * 0.8f, height * 0.95f, 12, primeColor );
        
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
            arc(width * ( arrayX[n] + PApplet.parseFloat(-selectSea + k) ) + seaSlide, height * arrayY[n],
              map(AnimeTitle, 0, 10, 12f, 24f), map(AnimeTitle, 0, 10, 12f, 24f), 0f, TAU);
            noFill();
            arc(width * ( arrayX[n] + PApplet.parseFloat(-selectSea + k) ) + seaSlide, height * arrayY[n], 24f + 4f, 24f + 4f, 0f, TAU);
            
            capsule(((Space)stage.get(n + k * 8)).comment, width * ( arrayX[n] - .5f) / 2f + width / 2f, height * arrayY[n] - 36,
              PApplet.parseInt(map(AnimeTitle, 0, 10, 1, 18)), secondColor);
            overMouse = true;
          } else {
            
            textSize(18);
            arc(width * ( arrayX[n] + PApplet.parseFloat(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f, 12f, 0f, TAU);
            noFill();
            arc(width * ( arrayX[n] + PApplet.parseFloat(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f + 2f, 12f + 2f, 0f, TAU);
            
          }
          fill(255);
          text("" + (n + 1 + k * 8), PApplet.parseFloat(width) * ( arrayX[n] + PApplet.parseFloat(-selectSea + k)) + seaSlide, PApplet.parseFloat(height) * arrayY[n] - 2);
          
        }
        
      }
      
      if(!isOverSea && overMouse) {
        //\u306a\u3089\u3059
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
      //\u30d7\u30ec\u30a4
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
      
      boxText(((isEdit) ? "TestPlay" : nf(playStage + 1, 2)) + " : " + space.comment, 8f, 8f, 24, width - 16, space.Color[0]);
      
      
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
      
      
      //\u30af\u30ea\u30a2\u5224\u5b9a
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
          fill(lerpColor(space.Color[0], space.Color[9], PApplet.parseFloat(abs(frameCount % 60 - 30)) / 30f), map(AnimeClear, 0, frameRate, 0f, 255f));
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
          isValidHistory = false;
          AnimeClear = 0;
          if(isEdit) {
            mode = 3;
            isTest = true;
            //hint\u751f\u6210
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
        Edit = new Space(0f, 0f, 48f, color(0), color(0));
      }
      Edit.setColor(LowColor, HighColor);
      Board.setColor(LowColor, HighColor);
      Edit.setComment(Title);
      
      fill(0);
      textSize(18);
      textAlign(RIGHT, TOP);
      text(((Title == "") ? "No Title (Input Name & Press Enter)" : "[ " + Title + " ]"), width - 10, 40);
      
      if(whichColor) HighColor = color(RedBar, GreenBar, BlueBar);
      else LowColor = color(RedBar, GreenBar, BlueBar);
      
      if(button(width * .05f, height * .25f, 12f, LowColor, LowColor) || !whichColor) 
        boxText("Lower Color", width * .09f, height * .25f - 6f, 12, 0, LowColor);
      
      if(button(width * .05f, height * .35f, 12f, HighColor, HighColor) || whichColor) 
        boxText("Higher Color", width * .09f, height * .35f - 6f, 12, 0, HighColor);
      
      Edit.Draw(-1, 0);
      Board.Draw(-1, 0);
      
      if(button(width * .9f, height * .9f, 24f, color(0), color(100))) 
        boxTextRight("Home", width * .8f, height * .9f, 12, 0, color(100));
      noStroke();
      fill(255);
      home( width * .9f, height * .9f, 12f, 0f );
      
      if(button(width * .9f, height * .73f, 24f, color(0), color(100))) {
        boxTextRight("Test Play", width * .8f, height * .73f, 12, 0, color(100));
        if(Edit.List.size() <= 1) boxTextRight("Deploy more Bubble", width * .8f, height * .73f + 20, 12, 0, color(100));
      }
      noStroke();
      fill(255);
      note( width * .9f, height * .73f, 12f, 0f );
      
      if(button(width * .9f, height * .56f, 24f, color(0), color(100))) { 
        boxTextRight("Save", width * .8f, height * .56f, 12, 0, color(100));
        if(!isTest) boxTextRight("Test didn't pass", width * .8f, height * .56f + 20, 12, 0, color(100));
      }
      noStroke();
      fill(255);
      cardBoard( width * .9f, height * .56f - 2f, 12f + 2f, 0f );
            
      capsule("Current Bubble", width * .8f, height * .25f, 12, Edit.Color[BubbleNumber%10]);
      if(Board.inRange(9)) boxTextRight("Camera will be optimized", Board.ListX(9) - 24, Board.ListY(9) - 6, 12, 0, Edit.Color[BubbleNumber%10]);
      
      
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

public void stop() {
  for(AudioPlayer Buf: snd) {
    Buf.close();
  }
  minim.stop();
  super.stop();
}

public void mousePressed() {
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
      if(dist(mouseX, mouseY, width * .9f, height * .6f) < 24f && selectSea != ceil((stage.size() - 1) / 8)) {
        selectSea = constrain(selectSea + 1, 0, ceil((stage.size() - 1) / 8));
        seaSlide = width;
        snd[9].play();
        snd[9].cue(100);
      }
      if(dist(mouseX, mouseY, width * .9f, height * .1f) < 24f) {
        mode = 3;
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
          if(dist(mouseX, mouseY, menuRadius / 2f, height - menuRadius * (PApplet.parseFloat(n) + 0.5f)) < menuRadius * 0.3f) {
            
            snd[7].play();
            snd[7].cue(50);
            
            //\u30dc\u30bf\u30f3\u306e\u6a5f\u80fd\u5b9f\u88c5\u90e8
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
          if(dist(mouseX, mouseY, width - menuRadius / 2f, height - menuRadius * (PApplet.parseFloat(n) + 0.5f)) < menuRadius * 0.3f) {
            
            snd[7].play();
            snd[7].cue(50);
            
            //\u30dc\u30bf\u30f3\u306e\u6a5f\u80fd\u5b9f\u88c5\u90e8
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
      if(distMouse(width * .9f, height * .9f, 24f)) {
        mode = 1;
        isEdit = false;
        isChanged = true;
      }
      
      if(distMouse(width * .9f, height * .73f, 24f)) {
        if(Edit.List.size() > 1) {
          mode = 2;
          isEdit = true;
          space.Copy(Edit);
          space.optimis();
        }
        isChanged = true;
      }
      
      if(distMouse(width * .9f, height * .56f, 24f)) {
        //\u4fdd\u5b58\u51e6\u7406
        if(isTest && !Edit.comment.equals("")) {
          Edit.optimis();
          //\u7d71\u62ec\u30d5\u30a1\u30a4\u30eb\u306b\u8ffd\u52a0
          try {
            BufferedWriter file = new BufferedWriter(new FileWriter(dataPath("") + "//setting/data.dat", true));
            file.write(Edit.comment + ".dat");
            file.newLine();
            file.close();
          } catch (IOException e) {
            e.printStackTrace();
          }
          //\u30b9\u30c6\u30fc\u30b8\u30d5\u30a1\u30a4\u30eb\u4f5c\u6210\uff06\u4fdd\u5b58
          try {
            BufferedWriter file = new BufferedWriter(new FileWriter(dataPath("") + "//setting/" + Edit.comment + ".dat"));
            
            file.write("[comment]"); file.newLine();
            file.write(Edit.comment); file.newLine();
            file.write("[color]"); file.newLine();
            file.write(PApplet.parseInt(red(Edit.Color[0])) + ", " + PApplet.parseInt(green(Edit.Color[0])) + ", " +
              PApplet.parseInt(blue(Edit.Color[0])) + ", " + PApplet.parseInt(red(Edit.Color[9])) + ", " + 
              PApplet.parseInt(green(Edit.Color[9])) + ", " + PApplet.parseInt(blue(Edit.Color[9]))); file.newLine();
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
      
      if(distMouse(width * .05f, height * .25f, 12f)) {
        whichColor = false;
        cp5.getController("RedBar").setValue(PApplet.parseInt(red(LowColor)));
        cp5.getController("GreenBar").setValue(PApplet.parseInt(green(LowColor)));
        cp5.getController("BlueBar").setValue(PApplet.parseInt(blue(LowColor)));
        isChanged = true;
      }
      if(distMouse(width * .05f, height * .35f, 12f)) {
        whichColor = true;
        cp5.getController("RedBar").setValue(PApplet.parseInt(red(HighColor)));
        cp5.getController("GreenBar").setValue(PApplet.parseInt(green(HighColor)));
        cp5.getController("BlueBar").setValue(PApplet.parseInt(blue(HighColor)));
        isChanged = true;
      }
      
      for(int n = 0; n < 9; n++) {
        if(Board.inRange(n)) {
          BubbleNumber = n + 1;
          isChanged = true;
        }
      }
      
      if(Board.inRange(9)) { Edit.optimis(); isChanged = true; }
      if(Board.inRange(10)) { BubbleMode = 2; isChanged = true; }
      if(Board.inRange(11)) { BubbleMode = 1; isChanged = true; }
      if(Board.inRange(12)) { BubbleMode = 0; isChanged = true; }
      
      for(int n = 0; n < 10; n++) {
        ((Number) Board.List.get(n)).isTurn = (BubbleMode == 1);
        ((Number) Board.List.get(n)).isLocked = (BubbleMode == 2);
        
      }
      ((Number) Board.List.get(9)).num = max(1, BubbleNumber);
      
      if(0 <= mouseX && 150 >= mouseX && 0 <= mouseY && mouseY <= 50) isChanged = true;
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

public void mouseDragged() {
  
}

public void mouseReleased() {
  if(space.direction(direction(dragX, dragY), selected) && dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate) {
    MoveDirection = direction(dragX, dragY);
    MoveID = selected;
    space.AnimeMove = 0;
    snd[0].play();
    snd[0].cue(200);
    
  } else MoveDirection = -1;
}
class Number {
  int num;
  int x, y;
  boolean isTurn, isLocked;
  int Anime; //\u30de\u30a6\u30b9\u30aa\u30fc\u30d0\u30fc\u7528
  int AddedTime; //\u6f14\u7b97\u6642\u7528
  float Rota; //\u6052\u5e38\u30a2\u30cb\u30e1\u7528
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
  public void Copy(Number origin) {
    num = origin.num;
    x = origin.x;
    y = origin.y;
    isTurn = origin.isTurn;
    isLocked = origin.isLocked;
    Anime = AddedTime = 0;
    Rota = 0f;
  }
  public void Draw(float X, float Y, float R, float L, int Color, int AnimeTime) {
    if (num < 1) return;
    if (num % 10 == 0) R = R * map(AddedTime, 0, AnimeTime * 2, 1.f, 0.f);
    else if (AddedTime > 0) R += -AddedTime * (AddedTime - AnimeTime * 2) / AnimeTime;
    pushStyle();
    pushMatrix();
    {
      translate((float)x * L + X, (float)y * L + Y);
      switch(PApplet.parseInt(isLocked)) {
      case 0:
        switch(PApplet.parseInt(isTurn)) {
        case 0: //\u4e38
          noStroke();
          fill(Color);
          ellipseMode(RADIUS);
          ellipse(0f, 0f, map(Anime, 0, AnimeTime, R, 0.f), map(Anime, 0, AnimeTime, R, 0.f));

          stroke(Color);
          noFill();
          ellipse(0f, 0f, map(Anime, 0, AnimeTime, 0.f, R * 0.8f), map(Anime, 0, AnimeTime, 0.f, R * 0.8f));

          for (int n = 0; n < 4; n++) {
            arc(0f, 0f, R + 2f + map(Anime, 0, AnimeTime, 0f, -4f), R + 2f + map(Anime, 0f, AnimeTime, 0f, -4f), 
              Rota + HALF_PI * PApplet.parseFloat(n - 1) + map(Anime, 0, AnimeTime, 0.f, QUARTER_PI), Rota + HALF_PI * PApplet.parseFloat(n));
          }

          fill(map(Anime, 0, AnimeTime, 255, red(Color)), 
            map(Anime, 0, AnimeTime, 255, green(Color)), 
            map(Anime, 0, AnimeTime, 255, blue(Color)));
          textSize(R);
          textAlign(CENTER, CENTER);
          text(num, 0f, - R * .1f);
          break;

        case 1: //\u56db\u89d2
          noStroke();
          fill(Color);
          square(0f, 0f, map(Anime, 0, AnimeTime, R, 0f), HALF_PI / 2f);

          stroke(Color);
          noFill();
          square(0f, 0f, map(Anime, 0, AnimeTime, R + 3f, 0f), HALF_PI / 2f);

          for (int n = 0; n < 4; n++) {
            fragment(R * cos(HALF_PI * PApplet.parseFloat(n) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f)) * 1.2f * map(Anime, 0, AnimeTime, 1f, .8f), 
              R * sin(HALF_PI * PApplet.parseFloat(n) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f)) * 1.2f * map(Anime, 0, AnimeTime, 1f, .8f), 
              R * 0.3f, HALF_PI * (1.5f + PApplet.parseFloat(n)) + map(Anime, 0, AnimeTime, 0f, PI * 3f / 4f));
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
      //\u6f14\u7b97\u306e\u6ce2\u7d0b\u30a2\u30cb\u30e1\u30fc\u30b7\u30e7\u30f3
      stroke(Color);//map(AddedTime, 0, AnimeTime * 2, 255f, 0f));
      noFill();
      ellipse(0f, 0f, map(AddedTime, 0, AnimeTime * 2, 0.f, L), map(AddedTime, 0, AnimeTime * 2, 0.f, L));
    }
    popMatrix();
    popStyle();
  }
  public void Update(int AnimeTime) {
    Rota += PI / 180.f;
    if (AddedTime > 0) AddedTime++;
    if (AddedTime >= AnimeTime * 2) { 
      num = num % 10;
      AddedTime = 0;
    }
  }
  public void afterProcess() {
    num = num % 10;
  }
  
}

class Space {
  ArrayList List;
  int[] Color;
  float x, y, r;
  float radiusRate;
  int AnimeTime;
  int AnimeMove;
  String comment;
  ArrayList Hint;
  Space() {
    List = new ArrayList();
    Color = new int[10];
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
  Space(float X, float Y, float R, int LowColor, int HighColor) {
    x = X;
    y = Y;
    r = R;
    List = new ArrayList();
    Color = new int[10];
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
  public void setColor(int LowColor, int HighColor) {
    for(int n = 0; n < 10; n++) {
      Color[n] = color(map(n, 0, 10, red(LowColor), red(HighColor)),
        map(n, 0, 10, green(LowColor), green(HighColor)),
        map(n, 0, 10, blue(LowColor), blue(HighColor)));
    }
  }
  public void setComment(String Text) {
    comment = Text;
  }
  public void setHint(int hintX, int hintY, int hintDirection) {
    if(hintDirection == -1) return;
    Swipe Buf = new Swipe(hintX, hintY, hintDirection);
    Hint.add(Buf);
  }
  public void Copy(Space origin) {
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
  public boolean Draw(int MoveDirection, int selectID) {
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
              HisBuf.afterProcess(); //\u4e00\u6841\u51e6\u7406\u5f8c\u3092\u4fdd\u5b58
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
  public void afterProcess() {
    for(int n = 0; n < List.size(); n++) {
      ((Number) List.get(n)).afterProcess();
    }
  }
  public boolean inRange(int id) {
    if(id < 0 || List.size() <= id) return false;
    return (dist(mouseX, mouseY, ListX(id), ListY(id)) < r * radiusRate);
  }
  public int inRange() {
    for(int n = 0; n < List.size(); n++) {
      if(inRange(n)) return n;
    }
    return -1;
  }
  public int ListNum (int id) {
    if(id < 0 || List.size() <= id) return 0;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.num;
  }
  public float ListX (int id) {
    if(id < 0 || List.size() <= id) return PApplet.parseFloat(0);
    Number Buf;
    Buf = (Number) List.get(id);
    return (float)Buf.x * r + x;
  }
  public float ListY (int id) {
    if(id < 0 || List.size() <= id) return PApplet.parseFloat(0);
    Number Buf;
    Buf = (Number) List.get(id);
    return (float)Buf.y * r + y;
  }
  public boolean ListIsTurn (int id) {
    if(id < 0 || List.size() <= id) return false;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.isTurn;
  }
  public boolean ListIsLocked (int id) {
    if(id < 0 || List.size() <= id) return false;
    Number Buf;
    Buf = (Number) List.get(id);
    return (Buf.isLocked);
  }
  
  public int Anime (int id) {
    if(id < 0 || List.size() <= id) return 0;
    Number Buf;
    Buf = (Number) List.get(id);
    return Buf.Anime;
  }
  public boolean direction(int directID, int id) {
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
  public boolean isClear() {
    int element = List.size();
    for(int n = 0; n < List.size(); n++) {
      Number Buf = (Number) List.get(n);
      if(Buf.num % 10 == 0) {
        element--;
      }
    }
    return (element == 0);
  }
  public boolean isFailed() {
    if(isClear()) return false;
    for(int n = 0; n < List.size(); n++) {
      for(int k = 0; k < 8; k++) {
        if(direction(k, n)) return false;
      }
    }
    return true;
  }
  public void optimis() {
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
    r = 64f;
    if(64f * (rightX - leftX) > width * 0.8f ) {
      r = min( r, width * 0.8f / (rightX - leftX) );
    }
    
    if(64f * (bottomY - topY) > height * 0.6f ) {
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
  public void Copy(Swipe origin) {
    x = origin.x;
    y = origin.y;
    d = origin.d;
  }
}
public void square(float x, float y, float r, float Angle) {
  polygon(4, x, y, r, Angle);
}

public void hexagon(float x, float y, float r, float Angle) {
  polygon(6, x, y, r, Angle);
}

public void polygon(int degree, float x, float y, float r, float Angle) {
  if(degree < 3) return;
  pushMatrix();
    translate(x, y);
    beginShape();
      for(int n = 0; n < degree; n++) {
        vertex(r * cos(TAU * PApplet.parseFloat(n) / PApplet.parseFloat(degree) + Angle), r * sin(TAU * PApplet.parseFloat(n) / PApplet.parseFloat(degree) + Angle));
      }
    endShape(CLOSE);
  popMatrix();
}

public void vectorArrow(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      scale(r);
      rotate(Angle);
      vertex(-.3f, 0f);
      vertex(0.6f * cos(radians(-5)), 0.6f * sin(radians(-5)));
      vertex(0.6f * cos(radians(-30)), 0.6f * sin(radians(-30)));
      vertex(1f, 0f);
      vertex(0.6f * cos(radians(30)), 0.6f * sin(radians(30)));
      vertex(0.6f * cos(radians(5)), 0.6f * sin(radians(5)));
      
    endShape(CLOSE);
  popMatrix();
}

public void capsule(float x, float y, float w, float h, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      rotate(Angle);
      for(int n = -9; n < 9; n++) {
        vertex(w / 2f - h / 2f + h / 2f * cos(radians(n * 10)), h / 2f * sin(radians(n * 10)));
      }
      for(int n = 9; n < 9 + 18; n++) {
        vertex(- w / 2f + h / 2f + h / 2f * cos(radians(n * 10)), h / 2f * sin(radians(n * 10)));
      }
      
    endShape(CLOSE);
  popMatrix();
}

public void capsule(String Text, float x, float y, int fontSize, int Color) {
  pushStyle();
    textSize(fontSize);
    fill(Color);
    noStroke();
    capsule(x, y, textWidth(Text) + fontSize * 2, fontSize, 0f);
    noFill();
    stroke(Color);
    capsule(x, y, textWidth(Text) + fontSize * 2 + 4, fontSize + 4, 0f);
    textAlign(CENTER, CENTER);
    fill(255);
    text(Text, x, y - fontSize * 0.1f);
  popStyle();
}



public void arrow(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      rotate(Angle);
      vertex(0f, -r * 2f / 3f);
      vertex(0f, -r);
      vertex(-r, -r / 2f);
      vertex(0f, 0f);
      vertex(0f, -r / 3f);
      for(int n = -9; n < 9; n++) {
        vertex(0f + r * 2f / 3f * cos(radians(10 * n)), r * 1f / 3f + r * 2f / 3f * sin(radians(10 * n)));
      }
      //vertex(0f, r);
      for(int n = 9; n > -9; n--) {
        vertex(0f + r * 5f / 6f * cos(radians(10 * n)), r * 1f / 6f + r * 5f / 6f * sin(radians(10 * n)));
      }
    endShape(CLOSE);
  popMatrix();
}

public void home(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      scale(r);
      rotate(Angle);
      vertex(0f, -1f);
      vertex(-1f, 0f);
      vertex(-.65f, 0f);
      vertex(-.65f, 1f);
      vertex(0f, 1f);
      vertex(.0f, .3f);
      vertex(.3f, .3f);
      vertex(.3f, 1f);
      vertex(.65f, 1f);
      vertex(.65f, 0f);
      vertex(1f, 0f);
      vertex(.6f, -.4f);
      vertex(.6f, -1f);
      vertex(.4f, -1f);
      vertex(.4f, -.6f);
      
    endShape(CLOSE);
  popMatrix();
}

public void note(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      scale(r);
      rotate(Angle);
      vertex(-.8f, -1f);
      vertex(-.8f, 1f);
      vertex(.8f, 1f);
      vertex(.8f, -.4f);
      vertex(.2f, -.4f);
      vertex(.2f, -1f);
      beginContour();
        vertex(-.6f, -.8f);
        vertex(0f, -.8f);
        vertex(0f, -.6f);
        vertex(-.6f, -.6f);
      endContour();
      beginContour();
        vertex(-.6f, -.3f);
        vertex(.6f, -.3f);
        vertex(.6f, -.1f);
        vertex(-.6f, -.1f);
      endContour();
      beginContour();
        vertex(-.6f, .15f);
        vertex(.6f, .15f);
        vertex(.6f, .35f);
        vertex(-.6f, .35f);
      endContour();
      beginContour();
        vertex(-.6f, .6f);
        vertex(.6f, .6f);
        vertex(.6f, .8f);
        vertex(-.6f, .8f);
      endContour();
      
    endShape(CLOSE);
    beginShape();
      vertex(.4f, -.6f);
      vertex(.8f, -.6f);
      vertex(.4f, -1f);
    endShape(CLOSE);
  popMatrix();
}

public void lamp(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      scale(r);
      rotate(Angle);
      vertex(0f, 1f);
      vertex(.15f, 1f);
      vertex(.2f, .9f);
      vertex(.3f, .9f);
      vertex(.3f, .7f);
      vertex(.4f, .6f);
      vertex(.3f, .5f);
      vertex(.3f, .4f);
      for(int n = 4; n >= -9 * 2 - 4; n--) {
        vertex(0f + .7f * cos(radians(PApplet.parseFloat(n * 10))), -.3f + .7f * sin(radians(PApplet.parseFloat(n * 10))));
      }
      vertex(-.3f, .4f);
      vertex(-.3f, .6f);
      vertex(-.4f, .7f);
      vertex(-.3f, .8f);
      vertex(-.3f, .9f);
      vertex(-.2f, .9f);
      vertex(-.15f, 1f);
      beginContour();
        vertex(-.15f, .4f);
        vertex(-.15f, .0f);
        for(int n = 9; n <= 9 + 9 * 4 * 2; n++) {
          vertex(-.15f + map(n, 9, 9 * 9, 0f, .3f) + .1f * cos(radians(PApplet.parseFloat(n * 10))), -.2f + .2f * sin(radians(PApplet.parseFloat(n * 10))));
        }
        vertex(.15f, .0f);
        vertex(.15f, .4f);
      endContour();
    endShape(CLOSE);
  popMatrix();
}

public void cardBoard(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      scale(r);
      rotate(Angle);
      vertex(-1f, 1f);
      vertex(.6f, 1f);
      vertex(.6f, -.2f);
      vertex(-.1f, -.2f);
      vertex(-.1f, .4f);
      vertex(-.2f, .3f);
      vertex(-.3f, .4f);
      vertex(-.3f, -.2f);
      vertex(-1f, -.2f);
      
    endShape(CLOSE);
    beginShape();
      vertex(.7f, 1f);
      vertex(.7f, -.2f);
      vertex(1f, -.5f);
      vertex(1f, .7f);
      
    endShape(CLOSE);
    beginShape();
      vertex(.6f, -.25f);
      vertex(1f, -.55f);
      vertex(.3f, -.75f);
      vertex(-.1f, -.45f);
      
    endShape(CLOSE);
    beginShape();
      vertex(-1f, -.25f);
      vertex(-.6f, -.55f);
      vertex(.1f, -.75f);
      vertex(-.3f, -.45f);
      
    endShape(CLOSE);
    
  popMatrix();
}

public void fragment(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      rotate(Angle);
      vertex(0f, 0f);
      vertex(r, 0f);
      vertex(r, r * .5f);
      vertex(r * .5f, r * .5f);
      vertex(r * .5f, r);
      vertex(0f, r);
    endShape(CLOSE);
  popMatrix();
}

public void rock(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      rotate(Angle);
      vertex(0f, 0f);
      vertex(r * .8f * cos(radians(15f)), r * .8f * sin(radians(15f)));
      vertex(r, 0f);
      vertex(r * .8f * cos(radians(-15f)), r * .8f * sin(radians(-15f)));
    endShape(CLOSE);
  popMatrix();
}

public void LeftMenu() {
  //\u5de6\u30e1\u30cb\u30e5\u30fc
  {
    String MenuText[] = {"Undo", "Reset", "Redo", "Hint"};
    
    pushStyle();
    for(int n = 0; n < 4; n++) {
      noStroke();
      fill(space.Color[n]);
      ellipseMode(CENTER);
      if(isOverMenuLeft) {
        if(dist(mouseX, mouseY, menuRadius / 2f, height - menuRadius * (PApplet.parseFloat(n) + 0.5f)) < menuRadius * 0.3f) {
          stroke(space.Color[9 - n]);
          noFill();
          arc(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
          height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.6f + 4f, menuRadius * 0.6f + 4f, 0f, TAU);
          noStroke();
          fill(space.Color[9 - n]);
          boxText(MenuText[n], menuRadius, mouseY, 12, 0, space.Color[9 - n]);
         
        }
      }
      ellipse(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
        height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.6f, menuRadius * 0.6f);
      
      noStroke();
      fill(255);
      switch(n) {
        case 0:
          arrow(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(0));
          break;
        case 1:
          
          square(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(45));
          break;
        case 2:
          arrow(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(180));
          break;
        case 3:
          if(isEdit) break;
          lamp(map(constrain(AnimeMenuLeft - space.AnimeTime / 4f * n, 0, space.AnimeTime / 4f), 0, space.AnimeTime / 4f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(0));
          break;
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

public void RightMenu() {
  //\u53f3\u30e1\u30cb\u30e5\u30fc
  {
    String MenuText[] = {"Back", "Home", "Next"};
    
    pushStyle();
    for(int n = 0; n < 3; n++) {
      noStroke();
      fill(space.Color[9 - n]);
      ellipseMode(CENTER);
      if(isOverMenuRight) {
        if(dist(mouseX, mouseY, width - menuRadius / 2f, height - menuRadius * (PApplet.parseFloat(n) + 0.5f)) < menuRadius * 0.3f) {
          stroke(space.Color[n]);
          noFill();
          arc(width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
          height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.6f + 4f, menuRadius * 0.6f + 4f, 0f, TAU);
          noStroke();
          fill(space.Color[n]);
          boxTextRight(MenuText[n], width - menuRadius * 1.0f, mouseY, 12, 0, space.Color[n]);
          
        }
      }
      ellipse(width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
        height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.6f, menuRadius * 0.6f);
      
      noStroke();
      fill(255);
      switch(n) {
        case 0:
          if(isEdit) break;
          polygon(3, width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(180));
          break;
        case 1:
          
          home(width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(0));
          break;
        case 2:
          if(isEdit) break;
          polygon(3, width - map(constrain(AnimeMenuRight - space.AnimeTime / 3f * n, 0, space.AnimeTime / 3f), 0, space.AnimeTime / 3f, - menuRadius / 2f, menuRadius / 2f),
            height - menuRadius * (PApplet.parseFloat(n) + 0.5f), menuRadius * 0.15f, radians(0));
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

public int direction(float startX, float startY) {
  float vectorX = mouseX - startX, vectorY = mouseY - startY;
  for(int n = 0; n < 8; n++) {
    if((cos(PI / 4f * PApplet.parseFloat(n)) * vectorX + sin(PI / 4f * PApplet.parseFloat(n)) * vectorY) / dist(0f, 0f, vectorX, vectorY) >= cos(PI / 8f)) {
      return n;
    }
  }
  return -1;
}

public boolean distMouse(float x, float y, float r) {
  return (dist(mouseX, mouseY, x, y) < r);
}

public boolean button(float x, float y, float r, int OutColor, int InColor) {
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

public void boxText(String Text, float x, float y, int fontSize, int maxWidth, int Color) {
  pushStyle();
  {
    textSize(fontSize);
    if(maxWidth > 0) {
      if(textWidth(Text) > maxWidth) {
        fontSize = PApplet.parseInt(maxWidth / textWidth(Text) * fontSize);
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

public void boxTextRight(String Text, float x, float y, int fontSize, int maxWidth, int Color) {
  pushStyle();
  {
    textSize(fontSize);
    if(maxWidth > 0) {
      if(textWidth(Text) > maxWidth) {
        fontSize = PApplet.parseInt(maxWidth / textWidth(Text) * fontSize);
        textSize(fontSize);
      }
    }
    float shift = textWidth(Text);
    noStroke();
    fill(Color);
    rect(x - shift, y, textWidth(Text), fontSize);
    stroke(Color);
    noFill();
    rect(x - 2f - shift, y - 2f, textWidth(Text) + 4f, fontSize + 3f);
    noStroke();
    fill(255);
    textAlign(LEFT, TOP);
    text(Text, x - shift, y - 2);
  }
  popStyle();
}


public void arcText(String c, float x, float y, float r, int Color) {
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
  public void settings() {  size(480, 320); }
}
