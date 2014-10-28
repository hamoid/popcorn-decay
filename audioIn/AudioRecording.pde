class AudioRecording extends PopcornAudio {  
  private SourceDataLine dataline;

  AudioRecording() {
    File soundFile = new File(sketchPath + "/popcorn.wav");

    try {
      in = AudioSystem.getAudioInputStream(soundFile);
      audioFormat = in.getFormat();
      order = audioFormat.isBigEndian() ? ByteOrder.BIG_ENDIAN : ByteOrder.LITTLE_ENDIAN;
      println("Play input audio format=" + audioFormat);

      DataLine.Info info = new DataLine.Info(SourceDataLine.class, audioFormat);
      if (!AudioSystem.isLineSupported(info)) {
        println("Play.playAudioStream does not handle this type of audio on this system.");
        return;
      }
      dataline = (SourceDataLine) AudioSystem.getLine(info);
      dataline.open(audioFormat);
      dataline.start();
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  @Override
  public void draw(SoundPainter sp) {
    try {
      if (in.available() >= bufSizeInBytes) {
        super.processBuffer(sp);
        dataline.write(bbuf, 0, bufSizeInBytes);
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
