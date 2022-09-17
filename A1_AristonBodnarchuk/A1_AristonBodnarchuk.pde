// shape size and shape modifier
float shapeSize = 50, shapeMod = 1, zoom = 0;
// convex or concave cube
boolean incDecTog = false;
int choice = 0;

int cubeRange_s = 5, cubeRange_e = 30;
PShape PCube[], top, bottom, front, back, left, right;
// l = left, r = right, u = up, d= down, f =front, b = back
PVector luf, ruf, lub, rub, ldf, rdf, ldb, rdb;

// camera rotation things 
float xRot, yRot = 0;
// new camera rotation things from update
float xRot_, yRot_ = 0;

void setup() {
  size(1280, 720, P3D);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);
  
  choice = (cubeRange_e - cubeRange_s) / 2;
  
  // l = left, r = right, u = up, d= down, f =front, b = back
  luf = new PVector(-1, -1,  1);
  ruf = new PVector( 1, -1,  1);
  lub = new PVector(-1, -1, -1);
  rub = new PVector( 1, -1, -1);
  ldf = new PVector(-1,  1,  1);
  rdf = new PVector( 1,  1,  1);
  ldb = new PVector(-1,  1, -1);
  rdb = new PVector( 1,  1, -1);
  
  PCube = new PShape[cubeRange_e - cubeRange_s + 1];
  
  for(int i = cubeRange_s; i <= cubeRange_e; ++i) {
    shapeMod = i / 10.0;
    createPCube(i - cubeRange_s);
  }
}

void draw() {
  background(69); // nice

  // push matrix to not effect other drawings after
  pushMatrix(); 
  // translate to screen center and push back 
  translate(width/2, height/2, zoom); 
 
  if ((mouseButton == RIGHT)) {
    // grab new screen angles
    xRot_ = mouseX/float(width) * TWO_PI;
    yRot_ = mouseY/float(height) * TWO_PI;
  
    // check new mouse angles and update 
    float diff = xRot - xRot_;
    if (abs(diff) >  0.01) { 
      xRot -= diff / 4.0;
    }
  
    diff = yRot - yRot_;
    if (abs(diff) >  0.01) { 
      yRot -= diff / 4.0;
    }
  }
  
  rotateX(-yRot); 
  rotateY(-xRot); 

  // make shape correct size 
  scale(shapeSize);
  // make lines not massive
  strokeWeight(1/ shapeSize);
  stroke(255); // white line color
  
  // bala bing bala bom bom bom
  shape(PCube[choice]);

  popMatrix();
  
  //println(frameRate);
}

void createFace(PShape face, PVector c0, PVector c1, PVector c2, PVector c3) {
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

  void createPCube(int index) {
    // top
    top = createShape();
    createFace(top, luf, lub, rub, ruf);
    // bottom
    bottom = createShape();
    createFace(bottom, ldf, ldb, rdb, rdf);
    // left
    left = createShape();
    createFace(left, luf, lub, ldb, ldf);
    // right
    right = createShape();
    createFace(right, ruf, rub, rdb, rdf);
    // front
    front = createShape();
    createFace(front, luf, ruf, rdf, ldf);
    // back
    back = createShape();
    createFace(back, lub, rub, rdb, ldb);

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

// clicking mouse modifies shape for testing 
void mousePressed() {
  if (mouseButton == LEFT) {
    //shapeMod = shapeMod != 1 ? 1 : (incDecTog ? 0.5 : 1.5);
    //if(shapeMod == 0.5) incDecTog = false;
    //if(shapeMod == 1.5) incDecTog = true;
    choice = incDecTog ? choice + 1 : choice - 1;
    
    if(choice == 0) incDecTog = true;
    if(choice == cubeRange_e - cubeRange_s) incDecTog = false;
    
    println(choice);
  }
}

// scroll mouse to increase / decrease zoom;
void mouseWheel(MouseEvent event) {
  zoom -= event.getCount()*10;
}

void keyPressed() {
  //int keyIndex = -1;
  //if (key >= 'A' && key <= 'Z') {
  //  keyIndex = key - 'A';
  //} else if (key >= 'a' && key <= 'z') {
  //  keyIndex = key - 'a';
  //}
  //if (keyIndex == -1) {
  //  // If it's not a letter key, clear the screen
  //  background(0);
  //} else { 
  //  // It's a letter key, fill a rectangle
  //  fill(millis() % 255);
  //  float x = map(keyIndex, 0, 25, 0, width - rectWidth);
  //  rect(x, 0, rectWidth, height);
  //}
}
