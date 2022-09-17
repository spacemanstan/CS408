// shape size and shape modifier
float shapeSize = 50, shapeMod = 1, zoom = 0;
// convex or concave cube
boolean incDecTog = true;

PShape PCubeFace, PCube;
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
  
  luf = new PVector(-1, -1,  1);
  ruf = new PVector( 1, -1,  1);
  lub = new PVector(-1, -1, -1);
  rub = new PVector( 1, -1, -1);
  ldf = new PVector(-1,  1,  1);
  rdf = new PVector( 1,  1,  1);
  ldb = new PVector(-1,  1, -1);
  rdb = new PVector( 1,  1, -1);
}

void draw() {
  background(69); // nice

  // push matrix to not effect other drawings after
  pushMatrix(); 
  // translate to screen center and push back 
  translate(width/2, height/2, zoom); 
 
  if (mousePressed && (mouseButton == RIGHT)) {
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
  // top
  fill(45); // dark shape color
  createFace(luf, lub, rub, ruf);
  // front
  createFace(luf, ruf, rdf, ldf);
  // left
  createFace(luf, lub, ldb, ldf);
  // back
  createFace(lub, rub, rdb, ldb);
  // right
  createFace(ruf, rub, rdb, rdf);
  // bottom
  createFace(ldf, ldb, rdb, rdf);

  popMatrix();
  
  println(frameRate);
}

void createFace(PVector c0, PVector c1, PVector c2, PVector c3) {
  PVector center = new PVector(c0.x + c1.x + c2.x + c3.x, c0.y + c1.y + c2.y + c3.y, c0.z + c1.z + c2.z + c3.z);
  center.div(4);
  if(center.x != 0) center.x *= shapeMod;
  if(center.y != 0) center.y *= shapeMod;
  if(center.z != 0) center.z *= shapeMod;
  
  println(center);
  
  beginShape();
  vertex(center.x, center.y, center.z);
  vertex(c0.x, c0.y, c0.z);
  vertex(c1.x, c1.y, c1.z);
  
  vertex(center.x, center.y, center.z);
  vertex(c1.x, c1.y, c1.z);
  vertex(c2.x, c2.y, c2.z);
  
  vertex(center.x, center.y, center.z);
  vertex(c2.x, c2.y, c2.z);
  vertex(c3.x, c3.y, c3.z);
  
  vertex(center.x, center.y, center.z);
  vertex(c3.x, c3.y, c3.z);
  vertex(c0.x, c0.y, c0.z);
  endShape(CLOSE); 
}

void renderTest() {
  beginShape(); // start drawing custom shape that can be warped
  
  // top face of cube (4 polygons total)
  vertex(0, -1 * shapeMod, 0);
  vertex(-1, -1, -1);
  vertex(-1, -1, 1);
  
  vertex(0, -1 * shapeMod, 0);
  vertex(-1, -1, -1);
  vertex(1, -1, -1);
  
  vertex(0, -1 * shapeMod, 0);
  vertex(-1, -1, 1);
  vertex(1, -1, 1);
  
  vertex(0, -1 * shapeMod, 0);
  vertex(1, -1, 1);
  vertex(1, -1, -1);

  endShape();  
}

// clicking mouse modifies shape for testing 
void mousePressed() {
  if (mouseButton == LEFT) {
    shapeMod = shapeMod != 1 ? 1 : (incDecTog ? 0.5 : 1.5);
    if(shapeMod == 0.5) incDecTog = false;
    if(shapeMod == 1.5) incDecTog = true;
  }
}

void mouseWheel(MouseEvent event) {
  zoom -= event.getCount()*10;
}
