
void mousePressed() {
  switch(mode) {
    case 0:
      if(titleShift == 0) titleShift = 60;
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
      if(dist(mouseX, mouseY, width * .9f, height * .6f) < 24f * RateY && selectSea != max( 3, ceil((stage.size() - 1) / 8))) {
        selectSea = constrain(selectSea + 1, 0, max( 3, ceil((stage.size() - 1) / 8)));
        seaSlide = width;
        snd[9].play();
        snd[9].cue(100);
      }
      if(dist(mouseX, mouseY, width * .1f, height * .1f) < 24f * RateY) {
        StageAction = (++StageAction) % 5;
        snd[9].play();
        snd[9].cue(100);
      }
      if(dist(mouseX, mouseY, width * .9f, height * .1f) < 24f * RateY) {
        mode = 3;
        snd[9].play();
        snd[9].cue(100);
      }
      if(dist(mouseX, mouseY, width * .1f, height * .9f) < 18f * RateY) {
        mode = 4;
        snd[9].play();
        snd[9].cue(100);
      }
           
      
      for(int n = 0; n < 8; n++) {
        if(dist(mouseX, mouseY, width * arrayX[n], height * arrayY[n]) < 24f * RateY && n + selectSea * 8 < stage.size()) {
          playStage = n + selectSea * 8;
          String Buf;
          switch(StageAction) {
            case 0:
              space.Copy((Space) stage.get(playStage));
              mode = 2;
              snd[10].play();
              snd[10].cue(100);
              isValidHistory = false;
              break;
            case 1:
              mode = 3;
              isEdit = true;
              LowColor = ((Space) stage.get(playStage)).Color[0];
              HighColor = ((Space) stage.get(playStage)).Color[9];
              whichColor = false;
              setBarRGB(LowColor);
              Title = ((Space) stage.get(playStage)).comment;
              Edit.Copy((Space) stage.get(playStage));
              break;
            case 2:
              if(stage.size() - 1 <= playStage) break;
              Buf = ((Space) stage.get(playStage)).comment;
              ((Space) stage.get(playStage)).comment = ((Space) stage.get(playStage + 1)).comment;
              ((Space) stage.get(playStage + 1)).comment = Buf;
              IndexSort();
              break;
            case 3:
              if(0 >= playStage) break;
              Buf = ((Space) stage.get(playStage)).comment;
              ((Space) stage.get(playStage)).comment = ((Space) stage.get(playStage - 1)).comment;
              ((Space) stage.get(playStage - 1)).comment = Buf;
              IndexSort();
              break;
            case 4:
              //delete Process
              //統括ファイルに追加
              try {
                BufferedWriter file = new BufferedWriter(new FileWriter(dataPath("") + "//setting/data.dat", false));
                for(int k = 0; k < stage.size(); k++) {
                  if(k == playStage) continue;
                  file.write(((Space) stage.get(k)).comment + ".dat");
                  file.newLine();
                }
                file.close();
              } catch (IOException e) {
                e.printStackTrace();
              }
              
              FileLoad();
              break;
          }
        }
      }
      break;
    case 2:
    
      if(MoveID == -1) {
        selected = space.inRange();
        dragX = mouseX;
        dragY = mouseY;
        if(selected != -1) {
          snd[4].play();
          snd[4].cue(100);
        }
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
                  space.Hint.clear();
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
        snd[5].play(); snd[5].cue(100);
        mode = 1;
        isEdit = whichColor = false;
        setBarRGB(LowColor);
        isChanged = true;
        FileLoad();
      }
      
      if(distMouse(width * .9f, height * .73f, 24f * RateY)) {
        if(Edit.List.size() > 1) {
          mode = 2;
          isEdit = true;
          space.Copy(Edit);
          space.optimis();
          space.Hint.clear();
        }
        snd[5].play(); snd[5].cue(100);
        isChanged = true;
      }
      
      if(distMouse(width * .9f, height * .56f, 24f * RateY)) {
        //保存処理
        snd[5].play(); snd[5].cue(100);
        if(isTest && !Edit.comment.equals("")) {
          SavedAnime = int(frameRate) * 2;
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
            file.write("[hint]"); file.newLine();
            for(int n = 0; n < Edit.Hint.size(); n++) {
              file.write(((Swipe)Edit.Hint.get(n)).x + ", " + 
                ((Swipe)Edit.Hint.get(n)).y + ", " + 
                ((Swipe)Edit.Hint.get(n)).d); file.newLine();
            }
            file.close();
          } catch(IOException e) {
            e.printStackTrace();
          }
          
        }
        isChanged = true;
      }
      
      if(distMouse(width * .05f, height * .25f, 12f * RateY)) {
        snd[5].play(); snd[5].cue(50);
        whichColor = false;
        setBarRGB(LowColor);
        isChanged = true;
      }
      if(distMouse(width * .05f, height * .35f, 12f * RateY)) {
        snd[5].play(); snd[5].cue(50);
        whichColor = true;
        setBarRGB(HighColor);
        isChanged = true;
      }
      
      for(int n = 0; n < 9; n++) {
        if(Board.inRange(n)) {
          BubbleNumber = n + 1;
          isChanged = true;
          snd[0].play();
          snd[0].cue(50);
      
        }
      }
      
      if(Select.inRange(0)) { Edit.optimis(); isChanged = true; snd[10].play(); snd[10].cue(100); }
      if(Board.inRange(9)) { BubbleMode = 2; isChanged = true; snd[5].play(); snd[5].cue(100); }
      if(Board.inRange(10)) { BubbleMode = 1; isChanged = true; snd[5].play(); snd[5].cue(100); }
      if(Board.inRange(11)) { BubbleMode = 0; isChanged = true; snd[5].play(); snd[5].cue(100); }
      
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
      
      //deploy
      if(!isChanged) {
        isTest = false;
        
            snd[3].play();
            snd[3].cue(50);
            
        Edit.List.add(new Number(BubbleNumber, ceil((mouseX - Edit.x - Edit.r / 2f) / Edit.r), ceil((mouseY - Edit.y - Edit.r / 2f) / Edit.r),
          (BubbleMode == 1), (BubbleMode == 2)));
      }
      break;
    case 4:

      snd[0].play();
      snd[0].cue(50);
      
      if(++helpPoint == help.length) {
        helpPoint = 0;
        mode = 1;
      }
      
      break;
  }
}

void mouseDragged() {
  
}

void mouseReleased() {
  
  if(MoveID != -1) {
    return;
  }
  if((space.direction(direction(dragX, dragY), selected)) && (dist(mouseX, mouseY, dragX, dragY) >= space.r * space.radiusRate)) {
    MoveDirection = direction(dragX, dragY);
    MoveID = selected;
    //space.AnimeMove = 0;
    snd[0].play();
    snd[0].cue(200);
    if(isEdit) {
      if(space.Hint.size() >= currentHistory) {
        for(int n = space.Hint.size() - 1; n > currentHistory; n--) {
          space.Hint.remove(n);
        }
      }
      space.Hint.add(new Swipe(((Number) space.List.get(selected)).x, ((Number) space.List.get(selected)).y,MoveDirection));
    }
  } else MoveDirection = -1;
}