class PopcornAudio {
  // http://www.rwalter.de/process-any-sound-that-is-played-through-your-sound-card-in-java-processing/
  // http://jan.newmarch.name/LinuxSound/Sampled/JavaSound/
  // https://docs.oracle.com/javase/6/docs/api/javax/sound/sampled/AudioFormat.html
  // https://stackoverflow.com/questions/6235016/convert-wav-audio-format-byte-array-to-floating-point

  protected AudioInputStream in;
  protected byte[] bbuf;  
  protected short[] sbuf;
  protected ByteOrder order;
  protected AudioFormat audioFormat;

  static final int bufSizeInSamples = 1024;
  static final int bufSizeInShorts = 2 * bufSizeInSamples; 
  static final int bufSizeInBytes = 4 * bufSizeInSamples;

  PopcornAudio() {
    //int bufSizeInBytes = (int) audioFormat.getSampleRate() * audioFormat.getFrameSize();
    bbuf = new byte[bufSizeInBytes];
    sbuf = new short[bufSizeInShorts];
  }
  public void draw(SoundPainter sp) {
  }
  protected void processBuffer(SoundPainter sp) {
    try {
      in.read(bbuf, 0, bufSizeInBytes);
      ShortBuffer sb = ByteBuffer.wrap(bbuf).order(order).asShortBuffer();
      sb.get(sbuf, 0, bufSizeInShorts);
      for (int i=0; i<bufSizeInShorts; i++) {
        sp.set(i, sbuf[i] / 32768.0);
      }
    }
    catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
  public void stop() {
  }
}
