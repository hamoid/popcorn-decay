public class SoundPainter {
  int x = 0;
  int c = 0;
  public void setColor() {
    c = color(frameCount % 256, 255, 255);
  }
  public void set(int sampleId, float v) {
    final int y = (int)(height/2 + 180 * v);
    final int p = x + y * width;
    pixels[p] = c;
    if (sampleId % 128 == 0) {
      x = (x+1) % width;
    }
  }
}
