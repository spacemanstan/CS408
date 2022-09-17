// shape size and shape modifier
float shapeSize = 50, shapeMod = 1, zoom = 0;
// convex or concave cube
boolean incDecTog = true;
int choice = 0;

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
  
  // l = left, r = right, u = up, d= down, f =front, b = back
  luf = new PVector(-1, -1,  1);
  ruf = new PVector( 1, -1,  1);
  lub = new PVector(-1, -1, -1);
  rub = new PVector( 1, -1, -1);
  ldf = new PVector(-1,  1,  1);
  rdf = new PVector( 1,  1,  1);
  ldb = new PVector(-1,  1, -1);
  rdb = new PVector( 1,  1, -1);
  
  PCube = new PShape[3];
  
  shapeMod = 0.5;
  createPCube(0);
  shapeMod = 1;
  createPCube(1);
  shapeMod = 1.5;
  createPCube(2);
  
  //for(float t = 0.5; t <= 3.0; t += 0.1)
  //  println(t);
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
}

void createFace(PShape face, PVector c0, PVector c1, PVector c2, PVector c3) {
  PVector center = new PVector(c0.x + c1.x + c2.x + c3.x, c0.y + c1.y + c2.y + c3.y, c0.z + c1.z + c2.z + c3.z);
  center.div(4);
  if(center.x != 0) center.x *= shapeMod;
  if(center.y != 0) center.y *= shapeMod;
  if(center.z != 0) center.z *= shapeMod;
  
  face.beginShape();
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
  face.endShape(CLOSE); 
}

// clicking mouse modifies shape for testing 
void mousePressed() {
  if (mouseButton == LEFT) {
    //shapeMod = shapeMod != 1 ? 1 : (incDecTog ? 0.5 : 1.5);
    //if(shapeMod == 0.5) incDecTog = false;
    //if(shapeMod == 1.5) incDecTog = true;
    choice = incDecTog ? choice + 1 : choice - 1;
    
    if(choice == 0) incDecTog = true;
    if(choice == 2) incDecTog = false;
  }
}

void mouseWheel(MouseEvent event) {
  zoom -= event.getCount()*10;
}
