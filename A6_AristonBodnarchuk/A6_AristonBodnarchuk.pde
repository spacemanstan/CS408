/*
  Name:  Ariston Bodnarchuk
 Id:    200285478
 Prof:  Alain Maubert Crotte
 Class: CS 408-001: Animation Software Design
 
 Assignment 5: Gas Simulation Program
 ############################################################
 
 Descrition:
 
 i hate my life
 
 */

final int FPS = 30;
final int DIM = 32;

float extent;

PVector[] points;

PImage sandTexture;
PShape sandObject;

void setup() {
  size(1280, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(FPS);
  surface.setTitle("A6 - Falling Sand"); // name the window better

  points = new PVector[DIM * DIM];

  extent = (float)width / (float)DIM;

  for (int z_ = 0; z_ < DIM; ++z_) {
    for (int x_ = 0; x_ < DIM; ++x_) {
      points[ getIndex(x_, z_) ] = new PVector(extent * x_, height, extent * z_);
    }
  }

  sandTexture = loadImage("./textures/sand.png");
  
  sandObject = createShape(BOX, extent, extent*0.15, extent);
  sandObject.setTexture(sandTexture);
  sandObject.setStroke(false);
}

void draw() {
  background(69); // nice
  
  translate(0, 0, -width);

  for (PVector point : points) {
    pushMatrix();
    translate(point.x, point.y, point.z);
    shape( sandObject );
    popMatrix();
  }
}

int getIndex(int xxx, int zzz) {
  return xxx + zzz * DIM;
}
