final int FPS = 30;

Gas[] gasGrid, calcGrid;
int offset = 0;

float totalMass = 0;

void setup() {
  size(420, 420);
  frameRate(FPS);

  gasGrid = new Gas[width * height];
  calcGrid = new Gas[width * height];

  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) 
      gasGrid[x_ + (y_ * width)] = new Gas();

  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_)
      /* 0 to 19, check 0 = 1/20 chance */
      if ( (int)random(0, 20) == 0) {
        // generate a value between 0 and 255 for rgb density
        // value is + or - 5 from max then constrained to make max and min values possible
        float randMass = constrain( (int)random(-5, 260*100) / 100.0, 1.0, 255.0 );
        totalMass += randMass;
        PVector randVel = new PVector( roundToTwo(random(-3.0, 3.1)), roundToTwo(random(-3.0, 3.1)) );
        calcGrid[x_ + (y_ * width)] = new Gas(randMass, randVel);
      } else {
        calcGrid[x_ + (y_ * width)] = new Gas();
      }
}

void draw() {
  background(0);
  println( );

  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) {
      PVector vel = calcGrid[x_ + (y_ * width)].vel;
      
      //gasGrid[x_ + (y_ * width)].zero();
    }

  loadPixels();

  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) {
      Gas cell = calcGrid[x_ + (y_ * width)];
      pixels[x_ + (y_ * width)] = color(cell.mass, cell.mass * cell.mass, cell.mass * cell.mass * cell.mass * 0.0001);
      // zero gas grid before next update after it has been displayed
      //gasGrid[x_ + (y_ * width)].zero();
    }

  updatePixels();
}

float roundToTwo(float val) {
  return Math.round(val * 100) / 100.0;
}

class Gas {
  float mass;
  PVector vel;

  Gas() {
    mass = 0;
    vel = new PVector();
  }

  Gas(float mass_, PVector vel_) {
    mass = mass_;
    vel = vel_.copy();
  }

  void zero() {
    mass = 0;
    vel.set(0, 0);
  }
}
