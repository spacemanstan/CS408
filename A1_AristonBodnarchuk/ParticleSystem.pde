class ParticleSystem {
  final int cubeRange_s = 5, cubeRange_e = 30, minSpeed, maxSpeed;
  int red, green, blue, opacity, shapeSize, shapeParam, speed, angDeg, spawnRate;
  float rotX, mX;
  PVector pos, startVel;
  PShape PCube[];
  final int btmRow_count;
  final float btmRow_width, btmRow_height;
  boolean helpScreen = false, drawStroke = true;
  ButtonData btmRow[];
  PImage helpScreenImage;

  ArrayList<Particle> particles = new ArrayList<Particle>();

  ParticleSystem() {
    helpScreenImage = loadImage("./helpScreen.png");

    pos = new PVector(width/2, height/2, -width/2);

    // default values
    red = 50;
    green = 50;
    blue = 50;
    opacity = 50;
    shapeSize = 50;
    shapeParam = 5;
    angDeg = 270;
    speed = 5;
    minSpeed = 0; 
    maxSpeed = 50;

    // allocate pshape array
    PCube = new PShape[cubeRange_e - cubeRange_s + 1];
    // fill array with all possible shapes
    renderPCubeShapes();

    // setup some buttons
    btmRow_count = 11;
    btmRow_height = height * 0.1;
    btmRow_width = (width / btmRow_count) + 0.4;
    btmRow = new ButtonData[btmRow_count];
    innitBtmRowBtns();

    rotX = mX = 0;

    spawnRate = FPS;
  }

  void display() {
    if (helpScreen) {
      image(helpScreenImage, 0, 0);
      
      if (keyPressed) {
        buttonFunctions(key);
      }
      
      return;
    }

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    update_camera();
    rotateY(rotX);

    pushStyle();
    noStroke();
    sphereDetail(5);
    sphere(10);
    popStyle();

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);

      p.display();

      if (p.deceased) {
        particles.remove(i);
      }
    }

    popMatrix();

    for (ButtonData btn : btmRow)
      if (btn != null) 
        btn.display();

    btmRow[0].display();

    this.update();
  }

  void update_camera() {
    if (mouseButton == RIGHT)
      // not right clicking a button
      if ( !(mouseY > height - emitter.btmRow_height && mouseY < height) ) {
        rotX = map(mouseX - mX, 0, width, -PI, PI);
      }
  }

  void update() {
    if (keyPressed) {
      buttonFunctions(key);
    }

    btmRow[0].color_optional = btmRow[1].color_optional = btmRow[2].color_optional = color(red, green, blue);

    if (round(frameRate) >= 30)
      if (!helpScreen && frameCount % spawnRate == 0) addParticle();
  }

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

    // calc parameters 
    int red_, green_, blue_, opacity_, shapeSize_, shapeParam_, speed_, angDeg_;
    float x_, y_, z_;

    red_        = btmRow[0].rdm ? (int)random(0, 101) : red;
    green_      = btmRow[1].rdm ? (int)random(0, 101) : green;
    blue_       = btmRow[2].rdm ? (int)random(0, 101) : blue;
    opacity_    = btmRow[3].rdm ? (int)random(0, 101) : opacity;
    shapeSize_  = btmRow[4].rdm ? (int)random(12, 101) : shapeSize;
    shapeParam_ = btmRow[5].rdm ? (int)random(0, PCube.length) : shapeParam;

    speed_      = btmRow[6].rdm ? (int)random(minSpeed, maxSpeed + 1) : speed;
    angDeg_     = btmRow[7].rdm ? (int)random(0, 101) : angDeg;

    x_ = speed_ * cos( radians(angDeg_) );
    y_ = speed_ * sin( radians(angDeg_) );
    z_ = 0;

    if (btmRow[8].rdm || btmRow[9].rdm || btmRow[10].rdm) {
      pos.x = random(width/4, width/4*3);
      pos.y = random(height/4, height/4*3);
      pos.z = random(-5000, 50);
    }

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
   makes a cube of 6 sides 
   */
  void createPCube(int index, float sMod) {
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
    PVector center = new PVector(c0.x + c1.x + c2.x + c3.x, c0.y + c1.y + c2.y + c3.y, c0.z + c1.z + c2.z + c3.z);
    center.div(4);
    if (center.x != 0) center.x *= shapeMod;
    if (center.y != 0) center.y *= shapeMod;
    if (center.z != 0) center.z *= shapeMod;

    face.beginShape(TRIANGLES); // necessary
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
        if (key == 'H' && shapeParam < PCube.length) shapeParam++; // inc
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
