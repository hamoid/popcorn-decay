import javax.sound.sampled.*;
import java.nio.*;

PopcornAudio audioIn;
SoundPainter sp;

void setup() {
  size(1000, 400);
  background(0);
  colorMode(HSB);
  loadPixels();

  sp = new SoundPainter();  
  audioIn = new AudioLive();
}

void draw() {
  sp.setColor();
  audioIn.draw(sp);
  updatePixels();
}

void keyPressed() {
  audioIn.stop();
}
