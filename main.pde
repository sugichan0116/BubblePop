
void draw() {
  if(mouseStopX == mouseX && mouseStopY == mouseY) mouseStop++;
  else { 
    mouseStop = 0;
    mouseStopX = mouseX;
    mouseStopY = mouseY;
  }
  
  if(isChangedScreen()) {
    RateX = float(width) / 480f;
    RateY = float(height) / 320f;
    menuRadius = 64f * RateY;
    space.optimis();
    for(Object Buf :stage) {
      ((Space) Buf).optimis();
    }
    for(Object Buf :History) {
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
      
      //make color
      int selectNumber = constrain(selectSea, 0, seaColor.length - 1);
      color primeColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * cos(radians(frameCount)));
      color secondColor = color(red(seaColor[selectNumber]) + red(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        green(seaColor[selectNumber]) + green(seaWideColor[selectNumber]) * -cos(radians(frameCount)),
        blue(seaColor[selectNumber]) + blue(seaWideColor[selectNumber]) * -cos(radians(frameCount)));
      
      //buttons
      fill(255);
      textSize(48 * RateY);
      textAlign(CENTER, CENTER);
      button(width * .1f, height * .6f, 24f * RateY, primeColor, secondColor);
      text("<", width * .1f - 2f * RateY, height * .6f - 8f * RateY);
      button(width * .9f, height * .6f, 24f * RateY, primeColor, secondColor);
      text(">", width * .9f + 2f * RateY, height * .6f - 8f * RateY);
      
      if(button(width * .1f, height * .9f, 18f * RateY, primeColor, secondColor)) 
        boxText("Help Me!", width * .05f, height * .75f, int(12 * RateY), 0, secondColor);
      textSize(24 * RateY);
      text("?", width * .1f, height * .9f - 2f * RateY);
      
      fill(primeColor);
      noStroke();
      polygon(3, width * 0.1f + 24f * RateY * cos(radians(frameCount)), height * 0.90f + 24f * RateY * sin(radians(frameCount)),
        4f * RateY, radians(frameCount + 180));
      noFill();
      stroke(primeColor);
      arc(width * 0.1f, height * 0.90f,
        22f * RateY, 22f * RateY, radians(10 + frameCount), radians(360 - 10 + frameCount));
      
      if(isDebug || selectNumber > 2) {
        if(button(width * .9f, height * .1f, 24f * RateY, primeColor, secondColor)) 
          boxTextRight("Make New Stage", width * .99f, height * .20f, int(12 * RateY), 0, secondColor);
        noStroke();
        fill(255);
        note( width * .9f, height * .1f, 12f * RateY, 0f );
        
        if(button(width * .1f, height * .1f, 24f * RateY, primeColor, secondColor)) 
          boxText(StageActionDescription[StageAction], width * .05f, height * .20f, int(12 * RateY), 0, secondColor);
        noStroke();
        fill(255);
        switch(StageAction) {
          case 0:
            polygon( 3, width * .1f, height * .1f, 12f * RateY, 0f );
            break;
          case 1:
            note( width * .1f, height * .1f, 12f * RateY, 0f );
            break;
          case 2:
            arrow( width * .1f, height * .1f, 12f * RateY, PI );
            break;
          case 3:
            arrow( width * .1f, height * .1f, 12f * RateY, 0f );
            break;
          case 4:
            DeleteIcon( width * .1f, height * .1f, 12f * RateY, 0f );
            break;
        }
      }
      
      capsule( "Sum of Stage : " + stage.size(), width * 0.8, height * 0.95, int(12 * RateY), primeColor );
        
      boolean overMouse;
      overMouse = false;
      for(int k = 0; k <= max( 3, ceil((stage.size() - 1) / 8)); k++) {
        
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
          boolean isCleared = ((Space) stage.get(k * 8 + n)).isClear;
          fill(secondColor);
          strokeWeight(1 * RateY);
          stroke(secondColor);
          ellipseMode(RADIUS);
          textAlign(CENTER, CENTER);
          if(dist(mouseX, mouseY, width * arrayX[n], height * arrayY[n]) < 24f * RateY && k == selectSea) {
            
            if(isCleared) fill(((Space) stage.get(k * 8 + n)).Color[0]);
            if(isCleared) stroke(((Space) stage.get(k * 8 + n)).Color[0]);
            textSize(map(AnimeTitle, 0, 10, 18, 36) * RateY);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n],
              map(AnimeTitle, 0, 10, 12f, 24f) * RateY, map(AnimeTitle, 0, 10, 12f, 24f) * RateY, 0f, TAU);
            noFill();
            stroke(secondColor);
            if(isCleared) stroke(((Space) stage.get(k * 8 + n)).Color[0]);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 24f * RateY + 4f, 24f * RateY + 4f, 0f, TAU);
            
            capsule(((Space)stage.get(n + k * 8)).comment, width * ( arrayX[n] - .5f) / 2f + width / 2f, height * arrayY[n] - 36 * RateY,
              int(map(AnimeTitle, 0, 10, 1, 18) * RateY), (isCleared) ? ((Space) stage.get(k * 8 + n)).Color[0] : secondColor);
            overMouse = true;
          } else {
            
            textSize(18 * RateY);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide, height * arrayY[n], 12f * RateY, 12f * RateY, 0f, TAU);
            noFill();
            stroke(secondColor);
            if(isCleared) stroke(((Space) stage.get(k * 8 + n)).Color[0]);
            arc(width * ( arrayX[n] + float(-selectSea + k) ) + seaSlide,
              height * arrayY[n], 12f * RateY + 3f + ((isCleared) ? 4f : 0f), 12f * RateY + 3f + ((isCleared) ? 4f : 0f), 0f, TAU);
            
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
      if(AnimeSlide > 0 && selected > -1) { //selected >= 0) {
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
            vectorArrow(Hint.x * space.r + space.x, Hint.y * space.r + space.y, int((64f + 8f) * RateY), radians(45 * Hint.d));
            fill(space.Color[9]);
            noStroke();
            vectorArrow(Hint.x * space.r + space.x, Hint.y * space.r + space.y, int((64f) * RateY), radians(45 * Hint.d));
            capsule("One More Tap will show More Hint!", width * .5f, height * .15f, int(12 * RateY), space.Color[9]);
            popStyle();
          }
        } else {
          capsule("Show Hint to Reset or Hint doesn't exsist.", width * .5f, height * .15f, int(12 * RateY), 0);
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
            Edit.CopyHint(space);
            //hint生成
          } else {
            ((Space) stage.get(playStage)).isClear = true;
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
        if(Edit.List.size() <= 1) boxTextRight("Deploy more Bubble", width * .8f, height * .73f + 20 * RateY, int(8 * RateY), 0, color(100));
      }
      noStroke();
      fill(255);
      note( width * .9f, height * .73f, int(12f * RateY), 0f );
      
      if(button(width * .9f, height * .56f, int(24f * RateY), color(0), color(100))) { 
        boxTextRight("Save", width * .8f, height * .56f, int(12 * RateY), 0, color(100));
        if(!isTest) boxTextRight("Test didn't pass", width * .8f, height * .56f + 20 * RateY, int(8 * RateY), 0, color(100));
        if(Edit.comment.equals("")) boxTextRight("Name this Stage", width * .8f, height * .60f + 20 * RateY, int(8 * RateY), 0, color(100));
        
      }
      noStroke();
      fill(255);
      cardBoard( width * .9f, height * .56f - 2f, int((12f + 2f) * RateY), 0f );
      
      capsule("Current Bubble", Select.ListX(0) - 30 * RateX, Select.ListY(0) - 24 * RateY, int(12 * RateY), Edit.Color[BubbleNumber%10]);
      if(Select.inRange(0)) boxTextRight("Camera will be optimized", Select.ListX(0) - 28 * RateX, Select.ListY(0) - 6 * RateY, int(12 * RateY), 0, Select.Color[BubbleNumber%10]);
      
      if(SavedAnime > 0) {
        SavedAnime--;
        capsule("Saved !", width * .5f, height * .5f, int(32 * RateY), color(0));
      }
        
      break;
    case 4:
      pushMatrix();
        scale(min(float(height) / float(help[3].height), float(width) / float(help[3].width)));
        image(help[helpPoint], 0f, 0f);
      popMatrix();
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