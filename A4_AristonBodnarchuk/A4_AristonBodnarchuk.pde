final int FPS = 60;

PVector xyrNoise = new PVector(0, 0, 0);
final float incNoise = 0.03;

PImage woodTexture;
PShape body, head, arm1, arm2, leg1, leg2;

void setup() {
  size(1280, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(FPS);
  surface.setTitle("a4"); // name the window better

  noiseDetail(1, 0.5);

  woodTexture = loadImage("./wood15.jpg");

  body = cylinder(30, 30, 10, 100);
  body.setTextureMode(REPEAT);
  body.setTexture(woodTexture);
  body.setStroke(false);

  head = createShape(SPHERE, 25);
  head.setTexture(woodTexture);
  head.setStroke(false);

  arm1 = cylinder(20, 6, 4, 80);
  arm1.setTextureMode(REPEAT);
  arm1.setTexture(woodTexture);
  arm1.setStroke(false);
  arm2 = cylinder(20, 6, 4, 80);
  arm2.setTextureMode(REPEAT);
  arm2.setTexture(woodTexture);
  arm2.setStroke(false);

  leg1 = cylinder(20, 5, 7, 80);
  leg1.setTextureMode(REPEAT);
  leg1.setTexture(woodTexture);
  leg1.setStroke(false);
  leg2 = cylinder(20, 5, 7, 80);
  leg2.setTextureMode(REPEAT);
  leg2.setTexture(woodTexture);
  leg2.setStroke(false);
}

void draw() {
  lights();
  background_colourful();

  pushMatrix();
  pushStyle();

  translate(width/2, height/2);

  rotateX( radians(frameCount*2 % 360) );
  rotateY( radians(frameCount % 1080) );
  rotateZ( radians(frameCount*3 % 720) );

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
