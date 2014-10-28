class Kernel {

  // The Nature of Code
  // Daniel Shiffman
  // http://natureofcode.com

  // All the usual stuff
  PVector location;
  PVector rotation;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  PShape shp;
  float fillColor;

  Kernel(PVector pos) {
    location = pos;
    r = 18;
    maxspeed = 3;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(2, 1);

    shp = createShape();
    shp.beginShape();
    shp.noStroke();
    for(float a=0; a<TAU; a += random(0.2, 0.8)) {
      float r = random(10, 20);
      shp.vertex(r * cos(a), r * sin(a));
    }
    shp.endShape(CLOSE);
    fillColor = 100;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Separation
  // Method checks for nearby vehicles and steers away
  void separate (ArrayList<Kernel> vehicles) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Kernel other : vehicles) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }

    // Friction added for Popcorn Decay    
    float c = 0.1;
    PVector friction = velocity.get();
    friction.mult(-1); 
    friction.normalize();
    friction.mult(c);
    applyForce(friction);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void draw() {
    fillColor = lerp(fillColor, 15, 0.05); 
    shp.setFill(color(fillColor));
    blendMode(ADD);    
    pushMatrix();
    translate(location.x, location.y);
    rotate(20 * noise(location.x * 0.01, location.y * 0.01));
    shape(shp, 0, 0);
    popMatrix();
    blendMode(BLEND);
  }
  
}
