void square(float x, float y, float r, float Angle) {
  pushMatrix();
    translate(x, y);
    beginShape();
      for(int n = 0; n < 4; n++) {
        vertex(r * cos(HALF_PI * float(n) + Angle), r * sin(HALF_PI * float(n) + Angle));
      }
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