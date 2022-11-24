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
 
 https://www.dgp.toronto.edu/public_user/stam/reality/Research/pdf/GDC03.pdf
 https://mikeash.com/pyblog/fluid-simulation-for-dummies.html
 
 The basic structure of the density solver is:
 intiial density --> add forces --> diffuse --> move
 
 1. vector field
 2. dye
 
 */

final int N = 128;
final int iter = 8; // # of iterations
final int SCALE = 5;

Simulation gasSim;

void settings() {
  size(N * SCALE, N * SCALE);
}

void setup() {
  gasSim = new Simulation(0.3, 0, 0);
  surface.setTitle("Assignment 5: Gas Simulation Program");
}

void draw() {
  background(0);

  gasSim.draw_();
}
