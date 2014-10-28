int bands = 20;
void setup() {
  size(600, 600);
}

void draw() {
  background(0);
  float L = map(mouseY, 0, height, 0, bands);

  for (int x = 0; x< bands; x++) {
    float y = exp(-L) * pow(L, x) / factorial(x);
        
    ellipse(
    map(x, 0, bands, 0, width), 
    map(y, 0, 1, height, 0), 20, 20
      );
  }
  println(L);
}

long factorial(int n) {
  long fact = 1;
  for (int i = 1; i <= n; i++) {
    fact *= i;
  }
  return fact;
}

