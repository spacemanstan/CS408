final int FPS = 1;
int len = 0;

Gas[] gasGrid, calcGrid;
int offset = 0;

float totalMass = 0;

void setup() {
  size(420, 420);
  frameRate(FPS);

  // calc length of all arrys once
  len = width * height;

  gasGrid = new Gas[len];
  calcGrid = new Gas[len];

  // init gas to 0 vals to start
  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) 
      gasGrid[x_ + (y_ * width)] = new Gas();

  // get some random gas (1/20 chance per cell)
  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_)
      /* 0 to 19, check 0 = 1/20 chance */
      if ( (int)random(0, 20) == 0) {
        /*
          0 to 100 with 2 decimals means 0 to 10000 / 100.0 
         random(-5, 10010) constrained to 1, 10000 lets max and min values be possible to generate
         
         same applies for the velocities 
         -3 to 3 with 2 decimals means -300 to 300 / 100.0 
         */
        int randMass = constrain( (int)random(-5, 10010), 1, 10000);
        int randVelX = constrain( (int)random(-310, 310), -300, 300);
        int randVelY = constrain( (int)random(-310, 310), -300, 300);
        calcGrid[x_ + (y_ * width)] = new Gas(randMass, randVelX, randVelY);
        
        totalMass += calcGrid[x_ + (y_ * width)].getMass();
      } else {
        calcGrid[x_ + (y_ * width)] = new Gas();
      }
}

void draw() {
  background(0);
  
  println(totalMass);

  //int randMass = constrain( (int)random(-5, 10010), 1, 10000);
  //int randVelX = constrain( (int)random(-310, 310), -300, 300);
  //int randVelY = constrain( (int)random(-310, 310), -300, 300);
  //Gas temp = new Gas(randMass, randVelX, randVelY);

  //println("\n\n\n" + temp.getVelX());
  //println(Math.floor( temp.getVelX() ));
  //println(Math.ceil( temp.getVelX() ));

  // calculate uniform distribution
  //for (int x_ = 0; x_ < width; ++x_)
  //  for (int y_ = 0; y_ < height; ++y_) {
  //    Gas cCell = calcGrid[x_ + (y_ * width)];

  //    if (cCell.mass == 0)
  //      break;

  //    // index modifiers for uniform distribuition
  //    int xf = (int)(Math.floor( cCell.getVelX() ));
  //    int xc = (int)(Math.ceil( cCell.getVelX() ));
  //    int yf = (int)(Math.floor( cCell.getVelY() ));
  //    int yc = (int)(Math.ceil( cCell.getVelY() ));

  //    int indexFC = len + (x_ + xf) + ((y_ + yc) * width);
  //    indexFC %= len;
  //    int massFC = (int)( cCell.mass * (1 - cCell.getVelX_dec()) * cCell.getVelY_dec() );
  //    gasGrid[indexFC].mass =  constrain(massFC, 0, 10000);

  //    int indexCC = len + (x_ + xc) + ((y_ + yc) * width);
  //    indexCC %= len;
  //    int massCC = (int)( cCell.mass * cCell.getVelX_dec() * cCell.getVelY_dec() );
  //    gasGrid[indexCC].mass =  constrain(massCC, 0, 10000);

  //    int indexFF = len + (x_ + xf) + ((y_ + yf) * width);
  //    indexFF %= len;
  //    int massFF = (int)( cCell.mass * (1 - cCell.getVelX_dec()) * (1 - cCell.getVelY_dec()) );
  //    gasGrid[indexFF].mass =  constrain(massFF, 0, 10000);

  //    int indexCF = len + (x_ + xc) + ((y_ + yf) * width);
  //    indexCF %= len;
  //    int massCF = (int)( cCell.mass * cCell.getVelX_dec() * (1 - cCell.getVelY_dec()) );
  //    gasGrid[indexCF].mass =  constrain(massCF, 0, 10000);
  //  }

  // prepare to display gas
  loadPixels();

  // display gas + update calc gas and reset display gas grid
  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) {
      pixels[x_ + (y_ * width)] = gasGrid[x_ + (y_ * width)].calcColor();
      // update calculation grid
      //calcGrid[x_ + (y_ * width)].cop_e( gasGrid[x_ + (y_ * width)] );
      //// reset display gas grid
      //gasGrid[x_ + (y_ * width)].zero();
    }

  updatePixels();
}

class Gas {
  // use ints and convert to floats for better control of precision with quick performance
  int mass; // 0 to 100 with 2 decimals means 0 to 10000 / 100.0 
  int xVel, yVel; // -3 to 3 with 2 decimals means -300 to 300 / 100.0 

  Gas() {
    mass = 0;
    xVel = 0;
    yVel = 0;
  }

  Gas(int mass_, int xVel_, int yVel_) {
    mass = constrain(mass_, 0, 10000);
    xVel = constrain(xVel_, -300, 300);
    yVel = constrain(yVel_, -300, 300);
  }

  // copy is reserved so cop_e lol
  void cop_e(Gas tar) {
    this.mass = tar.mass;
    this.xVel = tar.xVel;
    this.yVel = tar.yVel;
  }

  color calcColor() {
    return color( map(mass, 0, 10000, 0, 255) );
  }

  float getMass() {
    return constrain(mass, 0, 10000) / 100.0;
  }

  int getMass_int() {
    return (int)this.getMass();
  }

  float getMass_dec() {
    return (mass - getMass_int() * 100) / 100.0;
  }

  float getVelX() {
    return constrain(xVel, -300, 300) / 100.0;
  }

  int getVelX_int() {
    return (int)this.getVelX();
  }

  float getVelX_dec() {
    return (xVel - getVelX_int() * 100) / 100.0;
  }

  float getVelY() {
    return constrain(yVel, -300, 300) / 100.0;
  }

  int getVelY_int() {
    return (int)this.getVelY();
  }

  float getVelY_dec() {
    return (yVel - getVelY_int() * 100) / 100.0;
  }

  void zero() {
    mass = 0;
    xVel = 0;
    yVel = 0;
  }
}
