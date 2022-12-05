/*
  Name:  Ariston Bodnarchuk
 Id:    200285478
 Prof:  Alain Maubert Crotte
 Class: CS 408-001: Animation Software Design
 
 Assignment 5: Gas Simulation Program
 ############################################################
 
 Descrition:
 
 I struggled super hard with the initial intent of this assignemnt following the given instructions
 I'm not sure why, I just couldn't get it to work properly with mass and velocity so I took a different approach.
 
 I found this work on fluid simulations by Jos Stam, who is way smarter than me and figured out a lot of complex math.
 That led me to finding Mike Ash and his work based on what Jos Stam did. The math going on here is extremely complex
 and I can't image the dedication it took Jos Stam to figure all this out. I found following the work of Stam and Ash
 easier than going with the assignment simulation code and am happier with the final results
 
 https://www.dgp.toronto.edu/public_user/stam/reality/Research/pdf/GDC03.pdf
 https://mikeash.com/pyblog/fluid-simulation-for-dummies.html
 
 The basic structure of the density solver is:
 intiial density --> add forces --> diffuse --> move
 
 1. vector field
 2. dye
 
 */

final int DIM = 128; // dimenstions of sqaure grid (2 power works best)
final int iterations = 8; // # of iterations
final int SCALE = 5; // how big you want to scale up the simulation

Simulation gasSim;

void settings() {
  size(DIM * SCALE, DIM * SCALE);
}

void setup() {  
  gasSim = new Simulation(0.3, 0, 0);
  surface.setTitle("Assignment 5: Gas Simulation Program");

  noCursor();
}

void draw() {
  background(0);

  gasSim.draw_();

  pushStyle();
  rectMode(CENTER);
  noStroke();
  
  fill(255);
  circle(width*2/3, height*2/3, width*0.2);
  rect(width*2/3, height, width*0.05, height*2/3);

  if (mouseButton == LEFT) {
    // mouth
    fill(0);
    circle(width*2/3, height*2/3 + width*0.05, width*0.05);
  } else {
    // mouth
    fill(0);
    rect(width*2/3, height*2/3 + width*0.05, width*0.05, width*0.01);
  }


  popStyle();
}
