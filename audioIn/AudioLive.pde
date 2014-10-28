class AudioLive extends PopcornAudio {
  private TargetDataLine dataline;

  AudioLive() {
    order = ByteOrder.BIG_ENDIAN;

    AudioFormat audioFormat = new AudioFormat(44100, 16, 1, true, true);
    println("Play input audio format=" + audioFormat);

    try {
      DataLine.Info info = new DataLine.Info(TargetDataLine.class, audioFormat);

      dataline = (TargetDataLine) AudioSystem.getLine(info);
      dataline.open(audioFormat);
      in = new AudioInputStream(dataline);
      dataline.start();
    } 
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  @Override
    public void draw(SoundPainter sp) {
    try {
      while (in.available () >= bufSizeInBytes) {
        super.processBuffer(sp);
      }
    }
    catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
  public void stop() {
    dataline.drain();
    dataline.close();
  }  
}
