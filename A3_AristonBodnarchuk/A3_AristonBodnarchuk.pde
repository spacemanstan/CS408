PVector[] controlPoints;

void setup() {
  size(1280, 720, P3D); // 720p 3d render

  controlPoints = new PVector[] {
    new PVector( 0.0, 0.0, 0.0), 
    new PVector( 1.0, 3.5, 0.0), 
    new PVector( 4.8, 1.8, 0.0), 
    new PVector( 6.5, 7.0, 0.0), 
    new PVector( 9.0, 3.5, 0.0), 
    new PVector(32.5, 4.8, 0.0), 
    new PVector(33.2, 2.6, 0.0), 
    new PVector(36.8, 7.0, 0.0), 
    new PVector(37.8, 5.0, 0.0), 
    new PVector(41.2, 20.5, 0.0), 
    new PVector(41.5, 21.5, 0.0), 
  };

  // scale points so it doesn't look terrible
  for (int i = 0; i < controlPoints.length; ++i)
    controlPoints[i] = controlPoints[i].mult(10);
}

void draw() {
  // center
  translate(width/2 - 20.75*10, height/2);

  // draw control points
  fill(0);
  noStroke();
  //for (PVector cp : controlPoints) {
  //  pushMatrix();
  //  translate(cp.x, cp.y, 0);
  //  box(3);
  //  popMatrix();
  //}

  for (float t=0; t<1; t+=0.001) {
    PVector fuck = BSplinePoint(t, controlPoints);
    
    pushMatrix();
    translate(fuck.x, fuck.y, 0);
    box(3);
    popMatrix();
  }
}
