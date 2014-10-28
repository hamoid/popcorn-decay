class TimeFrame {
  private int nextStart;
  private int len;
  public int popCount;

  TimeFrame(int len) {
    this.len = len;
    this.popCount = 0;
  }
  
  public void start() {
    this.nextStart = millis();
    goNextFrame();
  }

  public boolean isNextFrameTime() {
    if (millis() > nextStart) {
      goNextFrame();
      return true;
    } else {
      return false;
    }
  }

  private void goNextFrame() {
    this.nextStart += this.len;
  }
}
