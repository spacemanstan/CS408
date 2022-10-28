/*
 Assignment Part (a): Uniform Cubic B-Spline
 ===============================================
 take a value referencing a point on the curve (as a percentage float value from 0 to 1)
 returns a PVector with corresponding uniform cubic B-spline point
 allows for curve precision to be defined
 assumes all weights and knots to be 1
 */
PVector BSplinePoint(float curvePos, PVector[] points) {
  // this is what makes it cubic, 1 = linear, 2 = quadratic, etc
  final int degree = 3; // curve degree

  int i;                      // for loop iterator 
  int splineSeg;              // spline segment 
  int pCount = points.length; // points count
  int pDim = 3;               // point dimensionality

  // arrays for weights and knots 
  float[] weights = new float[pCount]; // declare weight array of length [pCount]
  float[] knots = new float[pCount + degree + 1]; // declare knot array of length [pCount + degree + 1]
  float[][] homoCoords = new float[pCount][pDim + 1]; // 2D array to hold conversion to homogeneous coordinates

  // build weight and knot arrays together
  for (i = 0; i < (pCount + degree + 1); ++i) {
    knots[i] = i;

    if (i < pCount) {
      weights[i] = 1;

      // convert points to homogeneous coordinates
      homoCoords[i][0] = points[i].x * weights[i];
      homoCoords[i][1] = points[i].y * weights[i];
      homoCoords[i][2] = points[i].z * weights[i];
      homoCoords[i][3] = weights[i];
    }
  }

  int dom_a = degree;
  int dom_b = knots.length - 1 - degree;

  // remap curvePos to the domain where the spline is defined
  float low  = knots[dom_a];
  float high = knots[dom_b];
  curvePos = curvePos * (high - low) + low;

  // find spline segment for given curvePos
  for (splineSeg = dom_a; splineSeg < dom_b; ++splineSeg) {
    if (curvePos >= knots[splineSeg] && curvePos <= knots[splineSeg + 1]) {
      break; // stop when found
    }
  }

  // level goes from 1 to the curve degree + 1
  float alpha;
  for (int level = 1; level <= degree + 1; ++level) {
    // build level of the pyramid
    for (i = splineSeg; i > (splineSeg - degree - 1 + level); --i) {
      alpha = (curvePos - knots[i]) / (knots[i + degree + 1 - level] - knots[i]);

      // interpolate each component
      for (int j = 0; j < (pDim + 1); ++j) {
        homoCoords[i][j] = (1 - alpha) * homoCoords[i - 1][j] + alpha * homoCoords[i][j];
      }
    }
  }

  int s = splineSeg; // better readability for splinepoint vector
  PVector splinePoint = new PVector(homoCoords[s][0] / homoCoords[s][pDim], homoCoords[s][1] / homoCoords[s][pDim], homoCoords[s][2] / homoCoords[s][pDim]);

  return splinePoint;
}
