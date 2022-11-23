final int FPS = 1;
int len = 0;

Gas[] gasGrid, calcGrid;
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

  //println( 11 % 10);
}

void draw() {
  background(0);

  for (int i_ = 0; i_ < len; ++i_)
    gasGrid[i_].zero();

  // calculate uniform distribution
  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) {
      int startIndex = x_ + (y_ * width);
      Gas startCell = calcGrid[startIndex];

      if (startCell.mass == 0)
        continue;

      // index modifiers for uniform distribuition
      int fx = startCell.getVelX_int();
      int fy = startCell.getVelY_int();
      int cx = startCell.getVelX_int() + 1;
      int cy = startCell.getVelY_int() - 1;

      // all this math is for edge wrapping the indices 
      int indexFF = ((width + x_ + fx) % width) + (((height + y_ + fy) % height) * width);
      int indexCF = ((width + x_ + cx) % width) + (((height + y_ + fy) % height) * width);
      int indexFC = ((width + x_ + fx) % width) + (((height + y_ + cy) % height) * width);
      int indexCC = ((width + x_ + cx) % width) + (((height + y_ + cy) % height) * width);

      // set velocites
      gasGrid[indexFF].xVel += ((1 - startCell.getVelX_dec()) * (1 - startCell.getVelY_dec())) * 300;
      gasGrid[indexFF].yVel += ((1 - startCell.getVelX_dec()) * (1 - startCell.getVelY_dec())) * 300;
      gasGrid[indexCF].xVel += ((1 - startCell.getVelX_dec()) * (startCell.getVelY_dec())) * 300;
      gasGrid[indexCF].yVel += ((1 - startCell.getVelX_dec()) * (startCell.getVelY_dec())) * 300;
      gasGrid[indexFC].xVel += ((startCell.getVelX_dec()) * (1 - startCell.getVelY_dec())) * 300;
      gasGrid[indexFC].yVel += ((startCell.getVelX_dec()) * (1 - startCell.getVelY_dec())) * 300;
      gasGrid[indexCC].xVel += ((startCell.getVelX_dec()) * (startCell.getVelY_dec())) * 300;
      gasGrid[indexCC].yVel += ((startCell.getVelX_dec()) * (startCell.getVelY_dec())) * 300;

      // add mass into the calculated indices  
      gasGrid[indexFF].mass += (int)(calcGrid[indexFF].mass * (1 - startCell.getVelX_dec()) * (1 - startCell.getVelY_dec()) );
      gasGrid[indexCF].mass += (int)(calcGrid[indexCF].mass * (startCell.getVelX_dec()) * (1 - startCell.getVelY_dec()) );
      gasGrid[indexFC].mass += (int)(calcGrid[indexFC].mass * (1 - startCell.getVelX_dec()) * (startCell.getVelY_dec()) );
      gasGrid[indexCC].mass += (int)(calcGrid[indexCC].mass * (startCell.getVelX_dec()) * (startCell.getVelY_dec()) );

      //println(startIndex + " [" + startCell.getVelX() + ", " + startCell.getVelY() + " ]" + " [" + startCell.getVelX_int() + ", " + startCell.getVelY_int() + " ]" );
      //println(indexFC + " | " + indexCC);
      //println(indexFF + " | " + indexCF);
      //println(startCell.getVelX_dec() + " | " + startCell.getVelY_dec());
      //println(((1 - startCell.getVelX_dec()) * (startCell.getVelY_dec())) + " | " + ((startCell.getVelX_dec()) * (startCell.getVelY_dec())));
      //println(((1 - startCell.getVelX_dec()) * (1 - startCell.getVelY_dec())) + " | " + ((startCell.getVelX_dec()) * (1 - startCell.getVelY_dec())));
    }

  // constrain values
  for (int i_ = 0; i_ < len; ++i_)
    gasGrid[i_].cnstrn();

  // prepare to display gas
  loadPixels();

  // display gas + update calc gas and reset display gas grid
  for (int x_ = 0; x_ < width; ++x_)
    for (int y_ = 0; y_ < height; ++y_) 
      pixels[x_ + (y_ * width)] = gasGrid[x_ + (y_ * width)].calcColor();


  updatePixels();

  for (int i_ = 0; i_ < len; ++i_)
    calcGrid[i_].cop_e(gasGrid[i_]);
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

  void cnstrn() {
    mass = constrain(mass, 0, 10000);
    xVel = constrain(xVel, -300, 300);
    yVel = constrain(yVel, -300, 300);
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
