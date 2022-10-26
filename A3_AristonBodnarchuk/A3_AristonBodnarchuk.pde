PVector[] controlPoints;
final int scaleFactor = 15;

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
    controlPoints[i] = controlPoints[i].mult(scaleFactor);
}

void draw() {
  // center the curve
  // can do this with last point because it is the farthest from our start (0,0)
  PVector lastPoint = controlPoints[controlPoints.length - 1];
  PVector centerAdjust = new PVector(lastPoint.x / 2, lastPoint.y / 2);
  translate(width / 2 - centerAdjust.x, height / 2 - centerAdjust.y);

  // draw control points
  fill(0);
  noStroke();
  for (PVector cp : controlPoints) {
    pushMatrix();
    translate(cp.x, cp.y, 0);
    box(3);
    popMatrix();
  }

  noFill();
  strokeWeight(1.5);
  stroke(69, 13, 255);
  beginShape();
  for (float curvePosition = 0; curvePosition < 1; curvePosition += 0.01) {
    PVector uniformBSP = BSplinePoint(curvePosition, controlPoints);
    vertex(uniformBSP.x, uniformBSP.y);
  }
  endShape();
}
