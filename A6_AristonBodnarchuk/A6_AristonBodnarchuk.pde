/*
  Name:  Ariston Bodnarchuk
 Id:    200285478
 Prof:  Alain Maubert Crotte
 Class: CS 408-001: Animation Software Design
 
 Assignment 5: Gas Simulation Program
 ############################################################
 
 Descrition:
 
 i have an exam tomorrow, this is the best I can do
 
 */

final int FPS = 30;
final int DIM = (1 << 6) ; // 2^5 --> 32 --> 32 x 32 grid = 1024 points
final int LENGTH = DIM * DIM;

float unit;
PVector[] points;
ArrayList<Particle> particles;

PImage sandTexture;

void setup() {
  size(1280, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(FPS);
  surface.setTitle("A6 - Falling Sand"); // name the window better

  unit = (float)width / (float)DIM;
  points = new PVector[LENGTH];

  float start = -width/2;
  float stop = width/2;

  for (int zz_ = 0; zz_ < DIM; ++zz_) {
    for (int xx_ = 0; xx_ < DIM; ++xx_) {
      float xPos = map(xx_, 0, DIM, start, stop);
      float zPos = map(zz_, 0, DIM, start, stop);
      float startHeight = unit/2;

      points[ getIndex( xx_, zz_) ] = new PVector(xPos, startHeight, zPos);
    }
  }

  println(DIM);
  println(LENGTH);

  sandTexture = loadImage("./textures/sand.png");
  particles = new ArrayList<Particle>();
}

void draw() {
  background(69); // nice

  pushMatrix();
  translate(width/2, height*3/4, -width);

  // always tilt the sand grid a bit towards the camera for better visibility
  float rotAng =  map(mouseX, 0, width, -TWO_PI, TWO_PI);
  rotateY(rotAng);
  // other angles based on rotation angle
  rotateX( cos(rotAng) * radians(-15) );
  rotateZ( sin(rotAng) * radians(-15) );

  noStroke();

  for (PVector point : points) {
    pushMatrix();
    translate(point.x, -point.y/2, point.z);
    fill(46, 20 + 20 * noise(point.x, point.z), 97);
    stroke(46, 20 + 20 * noise(point.x, point.z), 60);
    box(unit, point.y, unit);
    popMatrix();
  }

  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.show();
    p.update();
    if (p.lifespan <= 0) {
      particles.remove(i);
    }
  }

  popMatrix();
  lights();
}

int getIndex(int x_, int z_) {
  int xVal = constrain(x_, 0, DIM);
  int zVal = constrain(z_, 0, DIM);

  return xVal + (zVal * DIM);
}

//void distribute(int index) {
void distribute(int x_, int z_) {
  //z_ = DIM;

  int index = getIndex(x_, z_);
  float thres = 1*unit;

  IntList dirs = new IntList();

  int up = getIndex(x_, z_ - 1); 
  int down = getIndex(x_, z_ + 1); 
  int left = getIndex(x_ - 1, z_);
  int right = getIndex(x_ + 1, z_);

  if (z_ > 0)
    dirs.append(up);
  if (z_ < DIM - 1)
    dirs.append(down);
  if (x_ > 0)
    dirs.append(left);
  if (x_ < DIM - 1)
    dirs.append(right); 

  dirs.shuffle();

  println("index: " + index + " [" + x_ + "," + z_ + "]");

  for (int dir = 0; dir < dirs.size(); ++dir) {
    if (points[ dirs.get(dir) ].y + thres < points[index].y) {
      float diff = points[ dirs.get(dir) ].y + thres - points[index].y;
      float amt = diff > unit ? diff / 4.0 : unit;
      points[ dirs.get(dir) ].y += amt;
      points[index].y -= amt;

      if (up == dirs.get(dir))
        distribute(x_, z_ - 1); 
      if (down == dirs.get(dir))
        distribute(x_, z_ + 1); 
      if (left == dirs.get(dir))
        distribute(x_ - 1, z_);
      if (right == dirs.get(dir))
        distribute(x_ + 1, z_);
    }
  }
}

void mousePressed() {
  for (int i = 0; i < 50; ++i) {
    int index_x = (int)random(0, DIM);
    int index_z = (int)random(0, DIM);

    index_x = (int)random(DIM/2 - 3, DIM/2 + 3);
    index_z = (int)random(DIM/2 - 3, DIM/2 + 3);

    points[ getIndex(index_x, index_z) ].y += unit;
    distribute( index_x, index_z );
    
    particles.add(new Particle());
  }
}

class Particle {
  PVector pos = new PVector(random(-width/6, width/6), -height, random(-width/6, width/6));
  PVector vel = new PVector( random(-1, 1), random(1, 3), random(-1, 1) );
  float thicc = 10*random(1, 4);
  float grav = 0.8;
  int lifespan = FPS/2 * 3;
  PShape sand = createShape(SPHERE, thicc);

  Particle() {
    sand.setStroke(false);
    sand.setFill(color(46, 20 + 20 + random(-11, 15), 97));
  }

  void update() {
    pos.add(vel);
    vel.y += grav;

    --lifespan;
  }

  void show() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    shape(sand);
    popMatrix();
    popStyle();
  }
}
