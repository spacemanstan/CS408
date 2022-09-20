class Particle {
  PShape cubeThing;
  PVector pos, vel, spin, gravity;
  int cubeSize, deathTimer;
  color rgb;
  boolean deceased;

  Particle(PShape shapeChoice) {
    cubeThing = shapeChoice;
    pos = new PVector (0, 0, 0);
    vel = new PVector (random(-25, 25), random(-45, -15), random(-5, 5));
    spin = new PVector(random(-PI, PI), random(-PI, PI), random(-PI, PI));
    rgb = color(random(100), random(100), random(100), random(40, 130));
    cubeSize = (int)random(10, 100);
    gravity = new PVector(0, map(cubeSize, 10, 100, 0.05, .6), 0);
    deceased = false; // it's alive!
    
    deathTimer = 5*FPS;
  }
  
  Particle(PShape shapeChoice, color rgba, int shpSize, PVector initVel) {
      cubeThing = shapeChoice;
      pos = new PVector (0, 0, 0);
      vel = initVel.copy();
      spin = new PVector(random(-PI, PI), random(-PI, PI), random(-PI, PI));
      rgb = rgba;
      cubeSize = shpSize;
      gravity = new PVector(0, map(cubeSize, 10, 100, 0.05, .6), 0);
      deceased = false; // it's alive!
      
      deathTimer = 5*FPS;
    }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(spin.x);
    rotateY(spin.y);
    rotateZ(spin.z);

    pushStyle();
    scale(cubeSize);
    strokeWeight(1/cubeSize);
    stroke(0);
    cubeThing.setFill(rgb);
    shape(cubeThing);
    popStyle();

    popMatrix();

    this.update();
  }

  void update() {
    --deathTimer;
    
    if(deathTimer < 0) {
      deceased = true;
      return;
    }
    
    int factor = 5;

    // dead?
    if (pos.x > factor*width || pos.x < -factor*width || pos.y > factor*height || pos.y < -factor*height || pos.z > factor*width || pos.z < -factor*width) {
      deceased = true;
      return;
    }
    
    pos.add(vel);
    vel.add(gravity);
    // add some friction to make better arcs than just using gravity 
    float fric = -100;
    PVector tion = new PVector(vel.x/fric, vel.y/fric, vel.z/fric);
    vel.add(tion);

    float spinSpeed = 0.01;
    spin.x = spin.x < 0 ? spin.x - spinSpeed : spin.x + spinSpeed;
    spin.y = spin.y < 0 ? spin.y - spinSpeed : spin.y + spinSpeed;
    spin.z = spin.z < 0 ? spin.z - spinSpeed : spin.z + spinSpeed;
  }
}
