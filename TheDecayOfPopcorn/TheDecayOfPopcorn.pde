import ddf.minim.Minim;
// write m.winkler@laydrop.com

import ddf.minim.*;
PopcornAudio audioIn;

final static int FREQUENCY_BANDS = 20;
final static int MODE_UNDECIDED = 0;
final static int MODE_AUDIO_LIVE = 1;
final static int MODE_AUDIO_RECORDING = 2;
int programMode;
int startTime;
int experimentTime;
final int experimentDurationMs = 240 * 1000;
int[] popTimes;
int popCounter;
int[] popFrequenciesReal;
float[] popFrequenciesCurrent;
TimeFrame timeFrame;
Poisson poisson;
ArrayList<Kernel> kernels;
final int maxKernels = 400;
PrintWriter output;

void setup() {
  prepareGraphics();
  resetData();
}
void resetData() {
  programMode = MODE_UNDECIDED;
  startTime = 0;
  experimentTime = 0;
  popCounter = 0;
  popTimes = new int[1000];
  popFrequenciesReal = new int[FREQUENCY_BANDS];
  popFrequenciesCurrent = new float[FREQUENCY_BANDS];
  timeFrame = new TimeFrame(1000);
  poisson = new Poisson(FREQUENCY_BANDS);  
  kernels = new ArrayList<Kernel>();
  if (output != null) {
    output.flush();
    output.close();
  }
  output = createWriter("pop_" + System.currentTimeMillis() / 1000 + ".log");
}

void draw() {
  drawBackground();

  if (programMode == MODE_UNDECIDED) {
    drawQuestion();
    return;
  } 

  experimentTime = millis() - startTime;

  for (Kernel k : kernels) {
    k.separate(kernels);
    k.update();
    k.draw();
  }  

  boolean pop = audioIn.containsPop();

  if (pop) {
    popTimes[popCounter++] = experimentTime;
    output.println(experimentTime);
    if (timeFrame.isNextFrameTime()) {
      if (timeFrame.popCount > FREQUENCY_BANDS) {
        println("You're going crazy making popcorn!", timeFrame.popCount, "per second!");
      } else {
        // don't start counting low frequencies until
        // we got 2 pops per second
        if (timeFrame.popCount > 1 || popFrequenciesReal[2] > 0) {          
          popFrequenciesReal[timeFrame.popCount]++;
        }
        timeFrame.popCount = 0;
        poisson.calcClosestL(popFrequenciesReal);
      }
    } else {
      timeFrame.popCount++;
    }
  }

  // Animate bar heights from current height to desired height
  for (int i=0; i<FREQUENCY_BANDS; i++) {
    popFrequenciesCurrent[i] = lerp(popFrequenciesCurrent[i], popFrequenciesReal[i], 0.1);
  }

  drawFrequencyBands(popFrequenciesCurrent);
  poisson.draw();
  PVector lastCurvePoint = drawTimeCurve(popTimes, popCounter);
  drawClock(experimentTime / 1000);
  drawRecButton(audioIn.enabled);

  if (pop) {
    kernels.add(new Kernel(lastCurvePoint));
  }
}

void mousePressed() {
  if (experimentTime > 1000) {
    audioIn.threshold = map(mouseY, height, 0, 0, 1);
    println(audioIn.threshold);
  }
}

void keyPressed() {
  if (key == ESC) {
    println("Shutting down");
    output.flush();
    output.close();
    exit();
  }
  if(key == ENTER) {
    resetData();
    audioIn.stop();
  }
  if (key == ' ') {
    audioIn.enabled = !audioIn.enabled;
  }
  if (key == 'l' || key == 'L') {
    audioIn = new AudioLive(this);
    programMode = MODE_AUDIO_LIVE;
    startTime = millis();
    timeFrame.start();
  }
  if (key == 'r' || key == 'R') {
    audioIn = new AudioRecording(this);
    programMode = MODE_AUDIO_RECORDING;
    startTime = millis();
    timeFrame.start();
  }
}
