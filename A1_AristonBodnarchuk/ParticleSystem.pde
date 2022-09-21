/*
  ParticleSystem
 =================================
 Tracks user input (including random) for particle and spawns each particle accordinly
 
 Once a particle is spawned it cannot change shape or color.
 
 Manages and displays buttons on the bottom of the screen
 
 Also handles help screen 
 */
class ParticleSystem {
  // int constants for amount of cube variance, and speed
  final int cubeRange_s, cubeRange_e, minSpeed, maxSpeed;
  // particle parameters for generated particle
  int red, green, blue, opacity, shapeSize, shapeParam, speed, angDeg, spawnRate;
  // camera rotation variables
  float rotY, mX;
  // vectors for emiter position and start velocity (particle)
  PVector pos, startVel;
  // array of all possible particle shapes 
  PShape PCube[];
  // constants for on screen buttons at bottom of screen
  final int btmRow_count;
  final float btmRow_width, btmRow_height;
  // array of bottom row buttons
  ButtonData btmRow[];
  // help screen toggle variable
  boolean helpScreen = true;
  // variable to store help screen image
  PImage helpScreenImage;

  // create and initialize an empty array list to manage all particles 
  ArrayList<Particle> particles = new ArrayList<Particle>();

  // constructor
  ParticleSystem() {
    // load help screen image
    helpScreenImage = loadImage("./helpScreen.png");

    // default position centers emitter and moves it away from camera
    pos = new PVector(width/2, height/2, -width/2);

    // starting particle values 
    red = 50;
    green = 50;
    blue = 50;
    opacity = 50;
    shapeSize = 50;
    shapeParam = 5;
    angDeg = 270; // shoot up 
    speed = 5;
    // initialize speed constants
    minSpeed = 0; 
    maxSpeed = 50;

    // allocate pshape array
    cubeRange_s = 5;
    cubeRange_e = 30;
    PCube = new PShape[cubeRange_e - cubeRange_s + 1];

    renderPCubeShapes(); // generate every possible shape to reference later

    // setup some buttons
    btmRow_count = 11;
    btmRow_height = height * 0.1;
    btmRow_width = (width / btmRow_count) + 0.4;
    btmRow = new ButtonData[btmRow_count];
    innitBtmRowBtns();

    // initilize camera control variables
    rotY = mX = 0;

    //starting spawn rate of one particle a second
    spawnRate = FPS;
  }

  /*
    display
   ======================
   function used to render elements to screen
   
   if helpscreen is enabled dont render or update particles
   just check if helpscreen needs to close
   
   manages spawning new particles and keyboard button input
   */
  void display() {
    // if helpscreen display and exit
    if (helpScreen) {
      image(helpScreenImage, 0, 0);
      return;
    }

    // push matrix so matrix manipulations are not stacked 
    pushMatrix();
    translate(pos.x, pos.y, pos.z); // move emitter to correct position
    update_camera(); // get camera rotation value
    rotateY(rotY); // update camera rotation angle

    pushStyle(); // push style so changes to style dont affect other elements 
    noStroke(); // no lines around emiter sphere 
    sphereDetail(5); // emitter sphere is tiny so it doesn't need much detail
    sphere(10); // just a small size sphere 
    popStyle(); 

    // iterate through arrayList backwards to make deleting "dead" elements trivial
    for (int i = particles.size()-1; i >= 0; i--) {
      // store the current particle in a variable for readability
      Particle p = particles.get(i);

      p.display(); // render particle and calculate changes / updates

      // check if dead after updating and remove if so
      if (p.deceased) {
        particles.remove(i);
      }
    }

    popMatrix(); // restore matrix

    // iterate through and display each button
    for (ButtonData btn : btmRow)
      if (btn != null) 
        btn.display();

    // update the particle system (basically check keyboard input)
    this.update();
  }

  // CREATIVE FEATURE
  /*
    this is a function used to rotate the camera using the right mouse button
   this allows the angle to be changed around the emiter without effecting the
   emit angle. I added this at the beginning to make sure my particles generated
   correctly.
   */
  void update_camera() {
    if (mouseButton == RIGHT)
      // not right clicking a button
      if ( !(mouseY > height - emitter.btmRow_height && mouseY < height) ) {
        // map the difference of the current mouse position to the starting one to a part of PI
        rotY = map(mouseX - mX, 0, width, -PI, PI);
      }
  }

  /*
    update function to manage keyboard functionality
   */
  void update() {
    // keyboard functionality
    if (keyPressed) {
      buttonFunctions(key);
    }

    // make rgb buttons match the current color 
    // does not update for random because it would be disorienting at higher spawn rates
    btmRow[0].color_optional = btmRow[1].color_optional = btmRow[2].color_optional = color(red, green, blue);

    // add a new particle based on spawn rate and performance (don't drop below 30fps)
    if (round(frameRate) >= 30)
      if (!helpScreen && frameCount % spawnRate == 0) addParticle();
  }

  /*
    addParticle
   ========================
   function used to add a partilce to the arrayList of particles
   
   particles are added based on spawn rate and if FPS at least 50% (30 FPS).
   
   if all buttons are random (except emitter pos) then a random constructor is
   used instead of passing all the random variables to save some processing power.
   */
  void addParticle() {
    // if all parameters are random except pos, use random constructor
    boolean allRandom = true;
    for (int i = 0; i < btmRow.length - 3; ++i)
      if (!btmRow[i].rdm) {
        allRandom = false;
        break;
      }

    // if all random, call randomized constructor
    if (allRandom) {
      particles.add(new Particle( PCube[ (int)random(0, PCube.length) ] ) );
      return;
    }

    // temporary parameters used to calculate value and handle random mode
    int red_, green_, blue_, opacity_, shapeSize_, shapeParam_, speed_, angDeg_;
    float x_, y_, z_;

    // ternary operators to handle conditional assingments
    red_        = btmRow[0].rdm ? (int)random(0, 101) : red;
    green_      = btmRow[1].rdm ? (int)random(0, 101) : green;
    blue_       = btmRow[2].rdm ? (int)random(0, 101) : blue;
    opacity_    = btmRow[3].rdm ? (int)random(0, 101) : opacity;
    shapeSize_  = btmRow[4].rdm ? (int)random(12, 101) : shapeSize;
    shapeParam_ = btmRow[5].rdm ? (int)random(0, PCube.length) : shapeParam;

    speed_      = btmRow[6].rdm ? (int)random(minSpeed, maxSpeed + 1) : speed;
    angDeg_     = btmRow[7].rdm ? (int)random(0, 101) : angDeg;

    // speed and angle used to calc a velocity 
    x_ = speed_ * cos( radians(angDeg_) );
    y_ = speed_ * sin( radians(angDeg_) );
    z_ = 0;

    // random position parameters
    if (btmRow[8].rdm || btmRow[9].rdm || btmRow[10].rdm) {
      pos.x = random(width/4, width/4*3);
      pos.y = random(height/4, height/4*3);
      pos.z = random(-5000, 50);
    }

    // create a temporary color and velocity vector to pass to particle constructor 
    color rgba_ = color(red_, green_, blue_, opacity_);
    PVector vel_ = new PVector(x_, y_, z_);

    particles.add( new Particle(PCube[shapeParam_], rgba_, shapeSize_, vel_) );
  }

  /*
    renderPCubeShapes
   ==================================
   fills array of every possible PShape
   
   saves processing time by calculating all shapes first
   */
  void renderPCubeShapes() {
    float shapeMod;

    for (int i = cubeRange_s; i <= cubeRange_e; ++i) {
      shapeMod = i / 10.0;
      createPCube(i - cubeRange_s, shapeMod);
    }
  }

  /*
    createPCube
   ====================
   Utilizes 8 corners of cube to create 6 pyramid esque faces to create a cube
   like shape of varying shape modifier. 
   
   corners are named in a bitmask sort of way where the the letter position
   corresponds to the xyz position respecively.
   
   Cubes are generated at a small size and scaled appropiately later
   */
  void createPCube(int index, float sMod) {
    // define all corners
    // l = left, r = right, u = up, d= down, f =front, b = back
    PVector luf = new PVector(-1, -1, 1);
    PVector ruf = new PVector( 1, -1, 1);
    PVector lub = new PVector(-1, -1, -1);
    PVector rub = new PVector( 1, -1, -1);
    PVector ldf = new PVector(-1, 1, 1);
    PVector rdf = new PVector( 1, 1, 1);
    PVector ldb = new PVector(-1, 1, -1);
    PVector rdb = new PVector( 1, 1, -1);

    PShape top, bottom, front, back, left, right;

    // top
    top = createShape();
    createFace(top, luf, lub, rub, ruf, sMod);
    // bottom
    bottom = createShape();
    createFace(bottom, ldf, ldb, rdb, rdf, sMod);
    // left
    left = createShape();
    createFace(left, luf, lub, ldb, ldf, sMod);
    // right
    right = createShape();
    createFace(right, ruf, rub, rdb, rdf, sMod);
    // front
    front = createShape();
    createFace(front, luf, ruf, rdf, ldf, sMod);
    // back
    back = createShape();
    createFace(back, lub, rub, rdb, ldb, sMod);

    // combine faces into one shape
    PCube[index] = createShape(GROUP);
    PCube[index].addChild(top);
    PCube[index].addChild(bottom);
    PCube[index].addChild(left);
    PCube[index].addChild(right);
    PCube[index].addChild(front);
    PCube[index].addChild(back);

    // clear support shapes
    // idk if this will actually improve memory but it is worth a shot 
    top = null;
    bottom = null;
    left = null;
    right = null;
    front = null;
    back = null;
  }

  /*
    createFace
   ====================
   utility function for create createPCube
   */
  void createFace(PShape face, PVector c0, PVector c1, PVector c2, PVector c3, float shapeMod) {
    // get center position from 
    PVector center = new PVector(c0.x + c1.x + c2.x + c3.x, c0.y + c1.y + c2.y + c3.y, c0.z + c1.z + c2.z + c3.z);
    center.div(4); // make value 1 to match corners
    // now change center value to match shape parameter
    if (center.x != 0) center.x *= shapeMod;
    if (center.y != 0) center.y *= shapeMod;
    if (center.z != 0) center.z *= shapeMod;

    // create pyramid shape without bottom out of 4 polygons
    // store polygons into a custom shape provided by the first function arguement 
    face.beginShape(TRIANGLES); // TRIANGLES is EXTREMELY important for generation to work properly
    face.vertex(center.x, center.y, center.z);
    face.vertex(c0.x, c0.y, c0.z);
    face.vertex(c1.x, c1.y, c1.z);

    face.vertex(center.x, center.y, center.z);
    face.vertex(c1.x, c1.y, c1.z);
    face.vertex(c2.x, c2.y, c2.z);

    face.vertex(center.x, center.y, center.z);
    face.vertex(c2.x, c2.y, c2.z);
    face.vertex(c3.x, c3.y, c3.z);

    face.vertex(center.x, center.y, center.z);
    face.vertex(c3.x, c3.y, c3.z);
    face.vertex(c0.x, c0.y, c0.z);
    face.endShape();
  }

  // simple function to initialize each bottom row button with correct information to display at bottom of screen
  void innitBtmRowBtns() {
    int current = 0;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Red", red, 'r', 'R');
    current = 1;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Green", green, 'g', 'G');
    current = 2;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Blue", blue, 'b', 'B');
    current = 3;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Transparency", opacity, 't', 'T');
    current = 4;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Size", shapeSize, '-', '+');
    current = 5;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Shape", shapeParam, 'h', 'H');
    current = 6;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Speed", shapeParam, '↓', '↑');
    current = 7;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Degrees", angDeg, '←', '→');
    current = 8;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "X Pos", -1, 'A', 'D');
    current = 9;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Y Pos", -1, 'Q', 'E');
    current = 10;
    btmRow[current] = new ButtonData(btmRow_width/2 + btmRow_width*current, height - btmRow_height/2, btmRow_width, btmRow_height, "Z Pos", -1, 'S', 'W');
  }

  // a large switch statement that takes an input char (usually a key) and performs the appropriate action
  void buttonFunctions(char input) {
    switch(input) {
      // help screen handled in main
      // red
    case 'r':
    case 'R':
      if (btmRow[0].rdm == false) {
        if (key == 'R' && red < 100) red++; // inc
        if (key == 'r' && red > 0) red--;   // dec
        btmRow[0].value = red;
      }
      break;
      // green
    case 'g':
    case 'G':
      if (btmRow[1].rdm == false) {
        if (key == 'G' && green < 100) green++; // inc
        if (key == 'g' && green > 0) green--;   // dec
        btmRow[1].value = green;
      }
      break;
      // blue
    case 'b':
    case 'B':
      if (btmRow[2].rdm == false) {
        if (key == 'B' && blue < 100) blue++; // inc
        if (key == 'b' && blue > 0) blue--;   // dec
        btmRow[2].value = blue;
      }
      break;
      // transparency / opacity
    case 't':
    case 'T':
    case 'o':
    case 'O':
      if (btmRow[3].rdm == false) {
        if ((key == 'T' || key == 'O') && opacity < 100) opacity++; // inc
        if ((key == 't' || key == 'o') && opacity > 0) opacity--;   // dec
        btmRow[3].value = opacity;
      }
      break;
      // size
    case '-':
    case '=':
    case '_':
    case '+':
      if (btmRow[4].rdm == false) {
        if ((key == '+' || key == '=') && shapeSize < 100) shapeSize++; // inc
        if ((key == '_' || key == '-') && shapeSize > 0) shapeSize--;   // dec
        btmRow[4].value = shapeSize;
      }
      break;
      // shape
    case 'h':
    case 'H':
      if (btmRow[5].rdm == false) {
        if (key == 'H' && shapeParam < PCube.length - 1) shapeParam++; // inc
        if (key == 'h' && shapeParam > 0) shapeParam--;   // dec
        btmRow[5].value = shapeParam;
      }
      break;
      // x pos
    case 'a':
    case 'A':
    case 'd':
    case 'D':
      if (btmRow[8].rdm == false) {
        if ((key == 'd' || key == 'D') && pos.x < width) pos.x++; // inc
        if ((key == 'a' || key == 'A') && pos.x > 0) pos.x--;   // dec
      }
      break;
      // y pos
    case 'q':
    case 'Q':
    case 'e':
    case 'E':
      if (btmRow[9].rdm == false) {
        if ((key == 'q' || key == 'Q') && pos.z < height) pos.z++; // inc
        if ((key == 'E' || key == 'e') && pos.z > 0) pos.z--;   // dec
      }
      break;
      // z pos
    case 's':
    case 'S':
    case 'w':
    case 'W':
      if (btmRow[10].rdm == false) {
        if ((key == 's' || key == 'S') && pos.y < width) pos.y++; // inc
        if ((key == 'w' || key == 'W') && pos.y > 0) pos.y--;   // dec
      }
      break;
      // degrees + speed
    case '.':
    case '>':
    case ',':
    case '<':
      if ((key == '.' || key == '>') && spawnRate < FPS) spawnRate++; // inc
      if ((key == ',' || key == '<') && spawnRate > 1) spawnRate--;   // dec
      break;
      // degrees + speed
    default:
      if (key == CODED) {
        if (keyCode == UP && speed < maxSpeed) {
          ++speed;
          btmRow[6].value = speed;
        }
        if (keyCode == DOWN  && speed > minSpeed) {
          --speed;
          btmRow[6].value = speed;
        }
        if (keyCode == LEFT) {
          --angDeg;
          if (angDeg < 0) angDeg = 359;
          btmRow[7].value = angDeg;
        }
        if (keyCode == RIGHT) {
          ++angDeg;
          if (angDeg >= 360) angDeg = 0;
          btmRow[7].value = angDeg;
        }
      }
      break;
    }
  }
}
