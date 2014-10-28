// gfx
PGraphics bg;
PFont font1;
int displayMargin = 30;

void prepareGraphics() {
  size(1024, 700, P3D);
  hint(DISABLE_DEPTH_TEST);
  font1 = loadFont("FreeSansOblique-48.vlw");
  textFont(font1);
}
void drawClock(int sec) {
  textAlign(RIGHT, CENTER);
  fill(#BFB792);
  text(nf(sec / 60, 2) + ":" + nf(sec % 60, 2), width - 40, height/2 - 20);
}
void drawRecButton(boolean enabled) {
  stroke(#6C6750);
  fill(enabled ? #F74B11 : #C1B996);
  ellipse(width-200, height/2 - 20, 30, 30);
}
void drawQuestion() {
  fill(255);
  textAlign(CENTER, CENTER);
  text("Live audio input (L) or recording (R)?", width/2, height/2);
}
void drawBackground() {
  // this should not be necessary, but fails when in setup
  if (bg == null) {
    bg = createBackground();
  }
  image(bg, 0, 0);
}
PGraphics createBackground() {
  PImage logo = loadImage("logo.png");
  PGraphics bg = createGraphics(width, height, P3D);
  bg.beginDraw();
  bg.lights();
  bg.noStroke();
  bg.fill(#4B462F);
  bg.pushMatrix();
  bg.translate(width/2, height/2);
  bg.sphere(800);
  bg.popMatrix();
  bg.noLights();
  bg.image(logo, width - displayMargin - logo.width * 0.5, displayMargin * 0.5, 
  logo.width * 0.5, logo.height * 0.5);
  bg.endDraw();
  return bg;
}
void drawFrequencyBands(float[] v) {
  int bandWidth = (width - displayMargin * 2) / v.length;
  for (int i=0; i<v.length; i++) {
    float h = v[i] * 20;
    float x = displayMargin + i*bandWidth;
    float y = height - h - displayMargin;
    fill(225);
    noStroke();
    rect(x, y, bandWidth- 5, h);

    int numCount = 9;
    if (i < numCount) {
      textAlign(LEFT, BOTTOM);
      fill(#8B8156);
      textSize(36);
      text(1 + i, x + 12, y);
    } else if (i == numCount) {
      textAlign(LEFT, BOTTOM);
      fill(#8B8156);
      text("pop/s", x + 12, y);
    }
  }
}
PVector drawTimeCurve(int[] timesMs, int popCount) {  
  noFill();
  stroke(#C0F052);

  float x = 0;
  float y = 0; 
  final float yOffset = 50;

  beginShape();
  for (int i=1; i<popCount-1; i++) {
    x = map(timesMs[i-1], 0, experimentDurationMs, 0, width);
    y = i / (float)maxKernels * (height * 0.7);
    vertex(x, y + yOffset);

    x = map(timesMs[i], 0, experimentDurationMs, 0, width);
    vertex(x, y + yOffset);
  }
  x = map(experimentTime, 0, experimentDurationMs, 0, width);
  vertex(x, y+1 + yOffset);
  endShape();

  fill(255);
  textAlign(LEFT);
  text(popCount + " pop" + (popCount > 1 ? "s" : ""), x + 5, y + 70);
  if (x > width * 0.70) {
    stop();
  }

  return new PVector(x + random(-2, 2), y+1 + yOffset + random(-2, 2));
}
