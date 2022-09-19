class ParticleSystem {
  final int cubeRange_s = 5, cubeRange_e = 30, minSpeed, maxSpeed;
  int red, green, blue, opacity, shapeSize, shapeParam, angDeg, speed;
  PVector pos, startVel;
  PShape PCube[];
  final int btmRow_count;
  final float btmRow_width, btmRow_height;
  boolean helpScreen = true, drawStroke = true;
  ButtonData btmRow[];

  ArrayList<Particle> particles = new ArrayList<Particle>();

  ParticleSystem() {
    pos = new PVector(width/2, height/2, -500);

    // default values
    red = 50;
    green = 50;
    blue = 50;
    opacity = 50;
    shapeSize = 50;
    shapeParam = 9;
    angDeg = 0;
    speed = 5;
    minSpeed = 0; 
    maxSpeed = 10;

    // allocate pshape array
    PCube = new PShape[cubeRange_e - cubeRange_s + 1];
    // fill array with all possible shapes
    renderPCubeShapes();

    // starting particle
    addParticle();

    // setup some buttons
    btmRow_count = 11;
    btmRow_height = height * 0.1;
    btmRow_width = (width / btmRow_count) + 0.4;
    btmRow = new ButtonData[btmRow_count];
    innitBtmRowBtns();
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

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

  void update() {
    if (keyPressed && frameCount % (FPS/10) == 0) {
      buttonFunctions(key);
    }

    btmRow[0].color_optional = btmRow[1].color_optional = btmRow[2].color_optional = color(red, green, blue);

    if (round(frameRate) >= 30)
      if (!helpScreen && frameCount % FPS == 0) addParticle();
  }

  void addParticle() {
    //particles.add(new Particle(red, green, blue, opacity, size, shapeParam, startVel));
    particles.add(new Particle( PCube[ (int)random(0, PCube.length) ] ) );
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
        if (key == 'H' && shapeParam < 100) shapeParam++; // inc
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
        if ((key == 'a' || key == 'A') && pos.x < width) pos.x++; // inc
        if ((key == 'D' || key == 'D') && pos.x > 0) pos.x--;   // dec
        //btmRow[8].value = shapeSize;
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
        //btmRow[9].value = shapeSize;
      }
      break;
      // z pos
    case 's':
    case 'S':
    case 'w':
    case 'W':
      if (btmRow[10].rdm == false) {
        if ((key == 'w' || key == 'W') && pos.y < height) pos.y++; // inc
        if ((key == 's' || key == 'S') && pos.y > 0) pos.y--;   // dec
        //btmRow[10].value = shapeSize;
      }
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
