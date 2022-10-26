PVector BSplinePoint(float t, PVector[] points) {
  final int degree = 3;

  int i, j, s, l;              // function-scoped iteration variables
  int n = points.length;    // points count
  int d = 3; // point dimensionality

  // build weight vector of length [n]
  float[] weights = new float[n];
  for (i=0; i<n; i++) {
    weights[i] = 1;
  }

  // build knot vector of length [n + degree + 1]
  float[] knots = new float[n + degree + 1];
  for (i=0; i<n+degree+1; i++) {
    knots[i] = i;
  }


  int[] domain = {
    degree, 
    knots.length-1 - degree
  };

  // remap t to the domain where the spline is defined
  float low  = knots[domain[0]];
  float high = knots[domain[1]];
  t = t * (high - low) + low;

  // find s (the spline segment) for the [t] value provided
  for (s=domain[0]; s<domain[1]; s++) {
    if (t >= knots[s] && t <= knots[s+1]) {
      break;
    }
  }

  // convert points to homogeneous coordinates
  float[][] v = new float[n][d + 1];
  for (i=0; i<n; i++) {
    v[i][0] = points[i].x * weights[i];
    v[i][1] = points[i].y * weights[i];
    v[i][2] = points[i].z * weights[i];

    v[i][3] = weights[i];
  }

  // l (level) goes from 1 to the curve degree + 1
  float alpha;
  for (l=1; l<=degree+1; l++) {
    // build level l of the pyramid
    for (i=s; i>s-degree-1+l; i--) {
      alpha = (t - knots[i]) / (knots[i+degree+1-l] - knots[i]);

      // interpolate each component
      for (j=0; j<d+1; j++) {
        v[i][j] = (1 - alpha) * v[i-1][j] + alpha * v[i][j];
      }
    }
  }

  PVector result = new PVector(v[s][0] / v[s][d], v[s][1] / v[s][d], v[s][2] / v[s][d]);

  return result;
}
