PVector[] ControlPoints;

void setup() {
  size(1280, 720, P3D); // 720p 3d render

  ControlPoints = new PVector[] {
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
}

void draw() {
  translate(width/2, height/2);

  for (int p = 0; p < ControlPoints.length - 1; ++p) {
    PVector p1 = ControlPoints[p];
    PVector p2 = ControlPoints[p + 1];

    line(p1.x, p1.y, p2.x, p2.y);
  }
}
