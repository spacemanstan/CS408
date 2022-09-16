// shape size and shape modifier
float shapeSize = 100, shapeMod = 1;
// convex or concave cube
boolean incDecTog = true;

PShape pCube;

// camera rotation things 
float xRot, yRot = 0;
// new camera rotation things from update
float xRot_, yRot_ = 0;

void setup() {
  size(1280, 720, P3D);
  
  pCube = createShape();
  
  pCube.beginShape(); // start drawing custom shape that can be warped
  
  // top face of cube (4 polygons total)
  pCube.vertex(0, -1 * shapeMod, 0);
  pCube.vertex(-1, -1, -1);
  pCube.vertex(-1, -1, 1);
  
  pCube.vertex(0, -1 * shapeMod, 0);
  pCube.vertex(-1, -1, -1);
  pCube.vertex(1, -1, -1);
  
  pCube.vertex(0, -1 * shapeMod, 0);
  pCube.vertex(-1, -1, 1);
  pCube.vertex(1, -1, 1);
  
  pCube.vertex(0, -1 * shapeMod, 0);
  pCube.vertex(1, -1, 1);
  pCube.vertex(1, -1, -1);

  pCube.endShape();
}

void draw() {
  background(69); // nice

  // push matrix to not effect other drawings after
  pushMatrix(); 
  // translate to screen center and push back 
  translate(width/2, height/2, -50); 
 
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

  rotateX(-yRot); 
  rotateY(-xRot); 

  // make shape correct size 
  scale(shapeSize);
  // make lines not massive
  strokeWeight(1/ shapeSize);
  stroke(255); // white line color
  fill(30); // dark shape color
  
  renderTest();
  rotateZ(PI/2);
  renderTest();
  rotateZ(PI/2);
  renderTest();
  rotateZ(PI/2);
  renderTest();
  rotateX(PI/2);
  renderTest();
  rotateX(PI);
  renderTest();

  popMatrix();
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
  shapeMod = shapeMod != 1 ? 1 : (incDecTog ? 0.5 : 1.5);
  if(shapeMod == 0.5) incDecTog = false;
  if(shapeMod == 1.5) incDecTog = true;
}
