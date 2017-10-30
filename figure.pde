void square(float x, float y, float r, float Angle) {
  polygon(4, x, y, r, Angle);
}

void hexagon(float x, float y, float r, float Angle) {
  polygon(6, x, y, r, Angle);
}

void polygon(int degree, float x, float y, float r, float Angle) {
  if(degree < 3) return;
  pushMatrix();
    translate(x, y);
    beginShape();
      for(int n = 0; n < degree; n++) {
        vertex(r * cos(TAU * float(n) / float(degree) + Angle), r * sin(TAU * float(n) / float(degree) + Angle));
      }
    endShape(CLOSE);
  popMatrix();
}

void vectorArrow(float x, float y, float r, float Angle) {
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

void capsule(float x, float y, float w, float h, float Angle) {
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

void capsule(String Text, float x, float y, int fontSize, color Color) {
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

void DeleteIcon(float x, float y, float r, float Angle) {

    for(int n = 0; n < 8; n++) {
      capsule( x + r * .8f * cos(radians(45 * n)), y + r * .8f * sin(radians(45 * n)), r * .8f, r * .2f, Angle + radians(45 * n));
    }
}

void arrow(float x, float y, float r, float Angle) {
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

void home(float x, float y, float r, float Angle) {
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

void note(float x, float y, float r, float Angle) {
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

void lamp(float x, float y, float r, float Angle) {
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
        vertex(0f + .7f * cos(radians(float(n * 10))), -.3f + .7f * sin(radians(float(n * 10))));
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
          vertex(-.15f + map(n, 9, 9 * 9, 0f, .3f) + .1f * cos(radians(float(n * 10))), -.2f + .2f * sin(radians(float(n * 10))));
        }
        vertex(.15f, .0f);
        vertex(.15f, .4f);
      endContour();
    endShape(CLOSE);
  popMatrix();
}

void cardBoard(float x, float y, float r, float Angle) {
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

void fragment(float x, float y, float r, float Angle) {
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

void rock(float x, float y, float r, float Angle) {
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