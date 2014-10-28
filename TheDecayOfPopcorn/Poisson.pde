class Poisson {
  float[] normalized;
  float[] poisson;
  long[] factorial;
  float L = 2;
  float currL = 2;

  Poisson(int frequencyBands) {
    normalized = new float[frequencyBands];
    poisson = new float[frequencyBands];
    buildFactorialLookupTable();
  }
  private void buildFactorialLookupTable() {
    // We can only fit factorial(20) into a long.
    // For larger values we should work in logarithmic space.
    factorial = new long[21];
    factorial[0] = 1;
    for (int i=1; i<factorial.length; i++) {
      factorial[i] = i * factorial[i-1];
      println(i, factorial[i]);
    }
  }

  public void calcClosestL(int[] freqs) {
    float sum = 0;
    for (int i=0; i<freqs.length; i++) {
      sum += freqs[i];
    }
    for (int i=0; i<freqs.length; i++) {
      normalized[i] = freqs[i] / sum;
    }

    float minDist = Integer.MAX_VALUE;
    // We are only searching between 0 and 8
    // I know we don't get more than 8 per second average
    for (float currL = 0; currL < 8; currL += 0.09371) {
      populatePoisson(currL);
      float d = arrayDist(normalized, poisson);
      if (d < minDist) {
        minDist = d;
        L = currL;
      }
    }
  }

  private float arrayDist(float[] a, float[] b) {
    float d = 0;
    for (int i=0; i<a.length; i++) {
      d += abs(a[i] - b[i]);
    }
    return d;
  }

  private void populatePoisson(float L) {
    for (int x = 0; x< this.poisson.length; x++) {
      this.poisson[x] = exp(-L) * pow(L, x) / factorial[x];
    }
  }
  public void draw() {
    populatePoisson(currL);
    stroke(#F5941E);
    strokeWeight(3);
    float wi = (width - displayMargin * 2) / poisson.length;
    float lasty = height - displayMargin;
    for (int x=0; x<poisson.length; x++) {
      float y = height - (height - displayMargin * 2) * poisson[x] - displayMargin;
      stroke(0, 15);
      line(displayMargin + x * wi, lasty * 1.01, 
      displayMargin + (x+1) * wi, y * 1.01);
      stroke(#F2CE56);
      line(displayMargin + x * wi, lasty, 
      displayMargin + (x+1) * wi, y);
      lasty = y;
    }    
    fill(#F2CE56);

    textSize(24);
    textAlign(RIGHT, BOTTOM);
    text("Closest Poisson distribution:\nLambda = " + nf(L, 1, 2), width - displayMargin - 2, height - displayMargin - 5);
    textSize(48);
    currL = lerp(currL, L, 0.05);
  }
}
