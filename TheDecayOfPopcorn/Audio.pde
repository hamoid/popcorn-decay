class PopcornAudio {
  public boolean enabled = false; 
  protected Minim minim;
  
  public float threshold = 0.5;
  
  // current sample Id
  protected long absoluteSampleId = 0;
  // how many samples must pass before next pop
  protected int popSampleDelay = 1000;
  protected long waitUntilSampleId = 0;
  protected int bufferSize = 1024;

  public boolean containsPop() {
    if (enabled) {
      for (int i = 0; i < bufferSize - 1; i++) {
        if (absoluteSampleId++ > waitUntilSampleId && getSample(i) > threshold) {
          waitUntilSampleId = absoluteSampleId + popSampleDelay;
          return true;
        }
      }
    }
    return false;
  }
  public void stop() {
    minim.stop();
  }
  protected float getSample(int i) {
    println("You must override getSample()!");
    noLoop();
    return 0;
  }
}

class AudioLive extends PopcornAudio {
  private AudioInput in;

  AudioLive(PApplet context) {
    minim = new Minim(context);
    in = minim.getLineIn();
    bufferSize = in.bufferSize();
    threshold = 0.93;
  }
  @Override protected float getSample(int i) {
    return abs(in.left.get(i));
  }
}

class AudioRecording extends PopcornAudio {
  private AudioPlayer in;

  AudioRecording(PApplet context) {
    minim = new Minim(context);   
    in = minim.loadFile("popcorn.mp3", 1024);
    in.play();
    bufferSize = in.bufferSize();
    threshold = 0.17;
  }
  @Override protected float getSample(int i) {
    return abs(in.left.get(i));
  }
}
