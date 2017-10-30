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
  
  //画像
  help = new PImage[7];
  for(int n = 0; n < 7; n++) {
    help[n] = loadImage(dataPath("") + "//help/00" + (n + 1) + ".png");
  }
  
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
  
  FileLoad();
  
}

boolean isChangedScreen() {
  boolean isChanged = ((screenPreWidth != width) || (screenPreHeight != height));
  screenPreWidth = width; screenPreHeight  = height;
  return isChanged;
}

void stop() {
  for(AudioPlayer Buf: snd) {
    Buf.close();
  }
  minim.stop();
  super.stop();
}