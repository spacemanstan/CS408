final int FPS = 60;

PVector xyrNoise = new PVector(0, 0, 0);
final float incNoise = 0.03;

PShape body, head, arm1, arm2, leg1, leg2;

void setup() {
  size(1280, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(FPS);
  surface.setTitle("a4"); // name the window better

  noiseDetail(1, 0.5);

  body = cylinder(20, 30, 10, 100);
  head = createShape(SPHERE, 25);
  arm1 = cylinder(12, 6, 4, 80);
  arm2 = cylinder(12, 6, 4, 80);
  leg1 = cylinder(12, 5, 7, 80);
  leg2 = cylinder(12, 5, 7, 80);
}

void draw() {
  background_colourful();

  pushMatrix();
  pushStyle();

  translate(width/2, height/2);

  rotateY( radians(frameCount % 360) );
  rotateZ( radians(frameCount % 720) );

  shape(body);

  pushMatrix();
  translate(0, -75);
  shape(head);
  popMatrix();

  pushMatrix();
  translate(-30, 0);
  rotateZ( radians(10) );
  shape(arm1);
  popMatrix();

  pushMatrix();
  translate(30, 0);
  rotateZ( radians(-10) );
  shape(arm2);
  popMatrix();

  pushMatrix();
  translate(-18, 85);
  rotateZ( radians(10) );
  shape(leg1);
  popMatrix();

  pushMatrix();
  translate(18, 85);
  rotateZ( radians(-10) );
  shape(leg2);
  popMatrix();

  popStyle();
  popMatrix();
}

void displayShape(PShape shape, float xpos, float ypos) {
  pushMatrix();
  pushStyle();

  translate(xpos, ypos);

  rotateY( radians(frameCount % 360) );
  rotateZ( radians(frameCount % 720) );

  shape(shape);

  popStyle();
  popMatrix();
}

// this is sweet as fuck
void background_colourful() {
  pushMatrix();
  pushStyle();

  translate(width/2, height/2, -width/2);

  float smolVal = frameCount * 0.01;
  xyrNoise.x = smolVal;
  xyrNoise.y = smolVal;

  int degVar = 20;
  rotateZ(radians(degVar) * noise(xyrNoise.z += 0.005) + radians(365 - degVar/2));

  for (int h = (int)(height * -1.5); h < height * 1.5; ++h) {
    xyrNoise.y -= (incNoise * noise(xyrNoise.z));

    stroke(noise(xyrNoise.x, xyrNoise.y) * 360, 42, 90);
    strokeWeight(1);
    line(width * -1.5, h, width * 1.5, h);
  }

  popStyle();
  popMatrix();
}
