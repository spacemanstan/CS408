PVector[] controlPoints, BSplinePoints;
PShape BSplineCurve;
final int scaleFactor = 15;

void setup() {
  size(1280, 720, P3D); // 720p 3d render
  surface.setTitle("Garbage"); // name the window better

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

  // Assignment Part (a): Uniform Cubic B-Spline
  // generate B spline curve and store into shape

  // draw a straight blue line made up of many dots from the first point to the last point (assignment requirement)

  BSplineCurve = createShape();
  BSplineCurve.beginShape();
  BSplineCurve.noFill();
  BSplineCurve.strokeWeight(1.5);
  BSplineCurve.stroke(160, 190, 255);

  int index = 0;
  BSplinePoints = new PVector[101]; // 101 because of += 0.01 in for loop

  for (float curvePosition = 0; curvePosition < 1; curvePosition += 0.01) {
    PVector uniformBSP = BSplinePoint(curvePosition, controlPoints);
    BSplinePoints[index] = uniformBSP.copy();
    ++index;
    BSplineCurve.vertex(uniformBSP.x, uniformBSP.y);
  }
  //println("TEST: " + test);
  BSplineCurve.endShape();
}

void draw() {
  background(69); // nice

  // center the curve
  // can do this with last point because it is the farthest from our start (0,0)
  PVector lastPoint = controlPoints[controlPoints.length - 1];
  PVector centerAdjust = new PVector(lastPoint.x / 2, lastPoint.y / 2);
  translate(width / 2 - centerAdjust.x, height / 2 - centerAdjust.y);

  // Assignment Part (a): Uniform Cubic B-Spline
  // draw the control points in black (assignment requirement)
  fill(0);
  noStroke();
  for (PVector cp : controlPoints) {
    pushMatrix();
    translate(cp.x, cp.y, 0);
    box(3);
    popMatrix();
  }

  // Assignment Part (a): Uniform Cubic B-Spline
  shape(BSplineCurve);

  noStroke();
  fill(255, 255, 130);
  PVector ballPos = BSplinePoints[frameCount % (BSplinePoints.length)];
  pushMatrix();
  translate(ballPos.x, ballPos.y, 0);
  sphere(15);
  popMatrix();
}
