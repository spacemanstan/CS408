/*
CS408 - Alain Maubert Crotte
 Assignment 2: Animated BSpline Curve with different easing functions
 
 Name: Ariston Bodnarchuk
 Id:   200285478
 
 Description
 ==================================
 My function for calculating a point on a B-Spline is adopted from a javascript library that
 handles B-Spline calculations given a vector of control points, knots, and weights. I completed
 this before the assignment due date was extended and before we were given the B-Spline function
 lecture notes. I have included the citations down below. I modified and refactored the libraries
 function heavily reducing it's size and increasing the efficiency slightly. The new algorithm 
 is specifically tailored to cubic B-Splines as it is intended just for this assignment. My work
 for the sinusoidal easing and parablolic easing was based of the classes textbook which covers
 how to implement such easing. My answer to question 1, the animation algorithm, can be found in
 the same zip folder this source code is in, named "a3_q1.pdf". The curve is displayed 3 times
 at an offset and each of the different easing methods are shown at once, one a loop is completed
 the aniations reset and the camera angle changes by 45 degrees showcasing the 3d effect. Since we
 were forced to do this in 3d I found it a shame not to use it in anyway, even if a creative feature
 is not a requirement. This assignment was probably the hardest so far because of the math. My 
 new B-Spline function also drastically improves the readability of the source code it was based upon
 when looking into De Boor's algorithm.
 
 There is no user interaction with the program, it just loops the 3 types of easing infinitely while,
 each reset goes between a straight on camera angle, or an angle of 45 degrees, then bounces back.
 
 
 
 Citations:
 ==========
 BSpline library referenced:
 https://github.com/thibauts/b-spline
 
 Textbook used for Sinusoidal Ease-in / Ease-out & Parabolic Ease-in / Ease-out:
 Parent, R. (2012). Computer Animation: Algorithms and Techniques (3rd ed.). Morgan Kaufmann.
 (APA - 7th edition)
 
 De Boor's Algorithm:
 Wikimedia Foundation. (2022, February 22). De Boor's algorithm. Wikipedia. https://en.wikipedia.org/wiki/De_Boor%27s_algorithm 
 (APA - 7th edition)
 */

PVector[] controlPoints; // store provided control points provided in assignment
PShape BSplineCurve; // shape object to store calculated curve
final int scaleFactor = 15, FPS = 60; // constants for scaling points and frameRate
int secElapsed = 0, cameraMod = 0, camTrack = 0; // seconds elapsed + camera rotate variables for coolness 

// used to draw the yellow ball on each curve
PVector yellowBall = new PVector();

void setup() {
  size(1280, 720, P3D); // 720p resolution, 3d required 
  surface.setTitle("Animation Curves"); // name the window better

  frameRate(FPS); // 60 fps requirement 

  // init control points sepcified in assignment 
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

  // create a pshape to draw the curve to, this improves performance substantially
  // it also makes the curve look better than drawing a million points
  BSplineCurve = createShape();
  BSplineCurve.beginShape();
  BSplineCurve.noFill();
  BSplineCurve.strokeWeight(1.5);
  BSplineCurve.stroke(160, 190, 255);

  // this curve is technically 1001 different vertices but because of
  // pshape optimization it doesn't really effect performance
  for (float curvePosition = 0; curvePosition < 1; curvePosition += 0.001) {
    PVector uniformBSP = BSplinePoint(curvePosition, controlPoints);
    BSplineCurve.vertex(uniformBSP.x, uniformBSP.y);
  }

  BSplineCurve.endShape();
}

void draw() {
  // creative feature
  camera(width/2 + (width/2*cameraMod), height/2, width/2, // eye
    width/2, height/2, 0, // center
    0, 1, 0); // up
  background(69); // nice

  // center the curve
  // can do this with last point because it is the farthest from our start (0,0)
  PVector lastPoint = controlPoints[controlPoints.length - 1];
  PVector centerAdjust = new PVector( (width / 2) + (lastPoint.x / 3) - 50, (height / 4) - (lastPoint.y) - 15 );

  // for loop to draw the same curve 3 times to show the 3 variants of the yellow ball animation
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

    /* 
     Assignment Part (b):   Motion Control
     =====================================
     I just get a time value by mapping the the range of possible frames (0 - 300)
     to a float value betweem 0 and 1 then passing that to my b spline function to 
     get the correct point
     */
    if (dupe == 0) {
      write("Part (b)");

      yellowBall = BSplinePoint( norm(frameCount, 0, 5*FPS), controlPoints).copy();

      drawYellowBall();
    }

    /* 
     Assignment Part (c):   Sinusoidal Ease-in / Ease-out
     ====================================================
     I used the textbook algorithm for how to get sinusoidal easing as my attempts to implement
     my own solution / approach to it ended in failure.
     
     This is based on the textook page 82, see comment at top line or documentaiton for citation
     */
    if (dupe == 1) {
      write("Part (c)");

      // based on textbook page 82, figure 3.12
      float t = norm(frameCount, 0, 5.25*FPS); // t is for time
      // my bspline calculation gives sinosodial movement already 
      // f is needed to normalize, s is just a temp, k1 and k2 are start stop ratios
      float f, s, k1 = 0.3, k2 = 0.7; 

      f = k1 * 2 / PI + k2 - k1 + (1.0 - k2) * 2 / PI;

      if (t < k1) {
        s = k1 * (2 / PI)*(sin((t / k1) * PI / 2 - PI / 2) + 1);
      } else {
        if (t < k2) {
          s = (2 * k1 / PI + t - k1);
        } else {
          s = 2 * k1 / PI + k2 - k1 + ((1 - k2) * (2 / PI)) * sin(((t - k2)/(1.0 - k2)) * PI / 2);
        }
      }

      yellowBall = BSplinePoint( s/f, controlPoints).copy();

      drawYellowBall();
    }

    /* 
     Assignment Part (d):   Parabolic Ease-in / Ease-out
     ====================================================
     I based my calculations on the formulas provided in the textbook, however I took liberties to 
     drastically reduce some math redundancies to improve computational costs. 
     
     This is based on the textook page 86, see comment at top line or documentaiton for citation
     */
    if (dupe == 2) {
      write("Part (d)");

      // based on textbook page 82, figure 3.12
      float t = norm(frameCount, 0, 8.5*FPS);
      double d = 0;
      float t1 = 1.0 / 6.0, t2 = 5.0 / 6.0;

      if (t < t1)
        d = t * t / t1;

      if (t >= t1 && t <= t2)
        d = t1 + 2 * (t - t1);

      if (t > t2)
        d = t1 + 2 * (t - t1) + (2 - ((t - t2)/(1 - t2))) * (t - t2);

      if (d > 1)
        d = 1;

      yellowBall = BSplinePoint( (float)d, controlPoints).copy();

      drawYellowBall();
    }

    popMatrix();
  }

  // track frames to count and output seconds and reset the frameCount + animations
  if (frameCount%FPS == 0) {
    ++secElapsed; // track seconds
    println("Seconds Elapsed [" + secElapsed + "]");

    if (secElapsed >= 5) { 
      camTrack = camTrack < 3 ? camTrack + 1 : 0; // used to rotate curve animations
      secElapsed = 0;
      frameCount = 0;
      println("### RESET ###");

      if (camTrack == 1 || camTrack == 3) {
        cameraMod = camTrack == 1 ? -1 : 1;
      } else {
        cameraMod = 0;
      }
    }
  }
}

// utility function to repeat less code for drawing the yellow ball
void drawYellowBall() {
  pushStyle();
  // style yellow ball
  noStroke();
  fill(255, 255, 130);

  pushMatrix();
  translate(yellowBall.x, yellowBall.y, 0);
  sphere(15);
  popMatrix();
  popStyle();
}

// utility function to write words on the screen to label animations 
void write(String msg) {
  pushStyle();
  fill(255); // dark
  rectMode(CENTER);
  textAlign(RIGHT, CENTER);
  textSize(30);
  text(msg, -25, 0);
  popStyle();
}
