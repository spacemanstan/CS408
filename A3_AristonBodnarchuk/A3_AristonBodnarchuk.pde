PVector[] controlPoints, BSplinePoints;
PShape BSplineCurve;
final int scaleFactor = 15, FPS = 60;
int secElapsed = 0; // seconds elapsed

void setup() {
  size(1280, 720, P3D); // 720p 3d render
  surface.setTitle("Garbage"); // name the window better

  frameRate(FPS);

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
    BSplineCurve.vertex(uniformBSP.x, uniformBSP.y);
    ++index;
  }

  BSplineCurve.endShape();
}

void draw() {
  background(69); // nice

  // center the curve
  // can do this with last point because it is the farthest from our start (0,0)
  PVector lastPoint = controlPoints[controlPoints.length - 1];
  PVector centerAdjust = new PVector( (width / 2) + (lastPoint.x / 3) - 50, (height / 4) - (lastPoint.y) - 15 );

  for (int dupe = 0; dupe < 3; ++dupe) {
    pushMatrix();
    // make 3 curves 
    centerAdjust.add(-lastPoint.x / 3, height / 4);
    translate(centerAdjust.x, centerAdjust.y);

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


    // yellow balls
    noStroke();
    fill(255, 255, 130);

    /* 
     Assignment Part (b):   Motion Control
     =====================================
     The program resets its framecount every 5 seconds, this just uses some
     basic math to iterate through the points stored in the B Spline point 
     array at the correct rate to last 5 seconds by using modulo on frame 
     count in conjusction with division to extend the time
     */
    if (dupe == 0) {
      //
      PVector ballPos = BSplinePoints[ (int)map(frameCount, 0, 5*FPS, 0, BSplinePoints.length - 1) ];
      pushMatrix();
      translate(ballPos.x, ballPos.y, 0);
      sphere(15);
      popMatrix();
    }

    //if (dupe == 1) {
    //  //divide framcount by 3 because we have 60fps * 5seconds / 101 BSpline curve points
    //  PVector ballPos = BSplinePoints[(frameCount / 3) % BSplinePoints.length];
    //  pushMatrix();
    //  translate(ballPos.x, ballPos.y, 0);
    //  sphere(15);
    //  popMatrix();
    //}

    /* 
     Assignment Part (c):   Sinusoidal Ease-in / Ease-out
     ====================================================
     
     */
    if (dupe == 1) {
      float t = (double)map(frameCount, 0, 5*FPS, 0, 1);
      flaot ease = 0, 
        k1 = 0.3,
        k2 = 0.7;

      if (secElapsed < 1) {
        ease =  k1*2/PI + k2 – k1 + (1.0 – k2)*2/PI;
      }
      if (secElapsed > 1 && secElapsed < 4) {
        ease  = (2*k1/PI + t - k1);
      }
      if (secElapsed >= 4) {
        ease = 2*k1/PI + k2 - k1 + ((1-k2)*(2/PI)) * sin( (float)(((t - k2) / (1.0 - k2) ) * PI / 2) );
      }
      
      ease /= k1*2/PI + k2 - k1 + (1.0 - k2)*2/PI;

      //println((int)(ease * 100));

      PVector ballPos = BSplinePoints[ (int)(ease * 100) ];
      pushMatrix();
      translate(ballPos.x, ballPos.y, 0);
      sphere(15);
      popMatrix();
    }

    popMatrix();
  }

  if (frameCount%FPS == 0) {
    ++secElapsed;
    println("Seconds Elapsed [" + secElapsed + "]");

    if (secElapsed >= 5) { 
      secElapsed = 0;
      frameCount = 0;
      println("### RESET ###");
    }
  }
}
