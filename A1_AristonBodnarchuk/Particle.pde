/*
  Particle Class
 ============================
 Class used to create particle objects for the particle system
 
 The shape is passed by reference from the particle system as every shape is pre calculated
 */
class Particle {
  PShape cubeThing;
  // CREATIVE FEATURE - spin and gravity are creative features
  PVector pos, vel, spin, gravity;
  final int cubeSize;
  int deathTimer;
  final color rgb;
  boolean deceased; // used to determine if a particle should be removed 

  // randomized constructor 
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

  // parameter construcor 
  Particle(PShape shapeChoice, color rgba, int shpSize, PVector initVel) {
    cubeThing = shapeChoice;
    pos = new PVector (0, 0, 0);
    vel = initVel.copy();
    spin = new PVector(random(-PI, PI), random(-PI, PI), random(-PI, PI));
    rgb = rgba;
    cubeSize = shpSize;
    gravity = new PVector(0, map(cubeSize, 10, 100, 0.05, .6), 0);
    deceased = false; // it's alive!

    deathTimer = 5*FPS; // 5 second lifetime works better than 1 second
  }

  void display() {
    pushMatrix(); // push matrix to stack for matrix manipulation 
    translate(pos.x, pos.y, pos.z); // move particle to correct spot
    // apply spin
    rotateX(spin.x);
    rotateY(spin.y);
    rotateZ(spin.z);

    pushStyle(); // push style to prevent unintended  styling of different elements
    scale(cubeSize); // make shape correct size
    strokeWeight(1/cubeSize); // make black lines around shape correct size
    stroke(0); // make black lines black 
    cubeThing.setFill(rgb); // color cube appropriately 
    shape(cubeThing); // display the shape (passed from projectile system)
    popStyle(); // restore style

    popMatrix(); // restore matrix 

    this.update(); // update particle
  }

  void update() {
    --deathTimer; // death comes closer 

    // if it is dead, stop updating 
    if (deathTimer < 0) {
      deceased = true;
      return;
    }

    // value to affect out of bounds range for particles
    int factor = 5;

    // CREATIVE FEATURE: dead?
    // if the particle goes flying off screen then it might as well be dead because it can't really be seen anyway
    if (pos.x > factor*width || pos.x < -factor*width || pos.y > factor*height || pos.y < -factor*height || pos.z > factor*width || pos.z < -factor*width) {
      deceased = true;
      return;
    }

    // CREATIVE FEATURE
    // my code incorporates, gravity, air friction, and a random spin to each object
    pos.add(vel);
    vel.add(gravity);
    // add some friction to make better arcs than just using gravity 
    float fric = -100; // just a value to play with the friction tolerance 
    PVector tion = new PVector(vel.x/fric, vel.y/fric, vel.z/fric);
    vel.add(tion);

    float spinSpeed = 0.01;
    // sping slowly in the direction that is randomly generated
    spin.x = spin.x < 0 ? spin.x - spinSpeed : spin.x + spinSpeed;
    spin.y = spin.y < 0 ? spin.y - spinSpeed : spin.y + spinSpeed;
    spin.z = spin.z < 0 ? spin.z - spinSpeed : spin.z + spinSpeed;
  }
}
