final int FPS = 60;

PVector xyrNoise = new PVector(0, 0, 0);
final float incNoise = 0.03;

PImage woodTexture;
PShape body, head, arm1, arm2, leg1, leg2;

Boi doug;

boolean swap = false;

PGraphics blackTexture, whiteTexture, gwape;

void setup() {
  size(1280, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(FPS);
  surface.setTitle("a4"); // name the window better

  noiseDetail(1, 0.5);

  woodTexture = loadImage("./Textures/wood (" + (int)random(0, 16) + ").jpg");

  blackTexture = createGraphics(256, 256);
  blackTexture.beginDraw();
  blackTexture.background(0);
  blackTexture.endDraw();

  whiteTexture = createGraphics(256, 256);
  whiteTexture.beginDraw();
  whiteTexture.background(255);
  whiteTexture.endDraw();
  
  gwape = createGraphics(256, 256);
  gwape.beginDraw();
  gwape.background(200, 0, 255);
  gwape.endDraw();

  createTwigBoi();

  doug = new Boi();
}

void draw() {
  lights();
  background_colourful();

  drawTwigBoi();

  doug.display();

  if (swap) {
    doug.left_eye.setAngDeg(new PVector(-frameCount*2 % 180, frameCount*2 % 180, 0) );
    doug.right_eye.setAngDeg(new PVector(frameCount*2 % 180, -frameCount*2 % 180, 0) );

    float bounce10 = frameCount%80 < 40 ? map(frameCount%80, 0, 39, -10, 10) : map(frameCount%80, 40, 79, 10, -10);
    float bounce30 = frameCount%80 < 40 ? map(frameCount%80, 0, 39, -30, 30) : map(frameCount%80, 40, 79, 30, -30);
    doug.torso_top.setAngDeg( new PVector(bounce10, 0, 0) );
    doug.neck.setAngDeg( new PVector(bounce30, 0, 0) );

    doug.left_arm_upper.setAngDeg(new PVector(0, 0, frameCount%80 < 40 ? map(frameCount%80, 0, 39, 180, 90) : map(frameCount%80, 40, 79, 90, 180) ) );
    doug.right_arm_upper.setAngDeg(new PVector(0, 0, frameCount%80 < 40 ? map(frameCount%80, 0, 39, 180, 270) : map(frameCount%80, 40, 79, 270, 180) ) );

    doug.torso_mid.setAngDeg(new PVector(0, frameCount%80 < 40 ? map(frameCount%80, 0, 39, -5, 5) : map(frameCount%80, 40, 79, 5, -5), 0) );
    doug.torso_bot.setAngDeg(new PVector(0, 0, frameCount%80 < 40 ? map(frameCount%80, 0, 39, -5, 5) : map(frameCount%80, 40, 79, 5, -5)) );

    doug.left_leg_upper.setAngDeg(new PVector(frameCount%80 < 40 ? map(frameCount%80, 0, 39, -30, 30) : map(frameCount%80, 40, 79, 30, -30), 0, 0 ) );
    doug.right_leg_upper.setAngDeg(new PVector(frameCount%80 < 40 ? map(frameCount%80, 0, 39, 30, -30) : map(frameCount%80, 40, 79, -30, 30), 0, 0 ) );
  }
}

//void displayShape(PShape shape, float xpos, float ypos) {
//  pushMatrix();
//  pushStyle();

//  translate(xpos, ypos);

//  //rotateY( radians(frameCount % 360) );
//  //rotateZ( radians(frameCount % 720) );

//  shape(shape);

//  popStyle();
//  popMatrix();
//}

// this is tight as fuck
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

PImage randomTexture() {
  return loadImage("./Textures/wood (" + (int)random(0, 15) + ").jpg");
  //return gwape;
}

void createTwigBoi() {
  body = cylinder(30, 30, 10, 100);
  body.setTextureMode(REPEAT);
  //body.setTexture(woodTexture);
  body.setTexture( randomTexture() );
  body.setStroke(false);

  head = createShape(SPHERE, 25);
  //head.setTexture(woodTexture);
  head.setTexture( randomTexture() );
  head.setStroke(false);

  arm1 = cylinder(20, 6, 4, 80);
  arm1.setTextureMode(REPEAT);
  //arm1.setTexture(woodTexture);
  arm1.setTexture( randomTexture() );
  arm1.setStroke(false);
  arm2 = cylinder(20, 6, 4, 80);
  arm2.setTextureMode(REPEAT);
  //arm2.setTexture(woodTexture);
  arm2.setTexture( randomTexture() );
  arm2.setStroke(false);

  leg1 = cylinder(20, 5, 7, 80);
  leg1.setTextureMode(REPEAT);
  //leg1.setTexture(woodTexture);
  leg1.setTexture( randomTexture() );
  leg1.setStroke(false);
  leg2 = cylinder(20, 5, 7, 80);
  leg2.setTextureMode(REPEAT);
  //leg2.setTexture(woodTexture);
  leg2.setTexture( randomTexture() );
  leg2.setStroke(false);
}

void drawTwigBoi() {
  pushMatrix();
  pushStyle();

  translate(width*2/3, height/2);

  rotateX( radians(frameCount % 360) );
  rotateY( radians(frameCount % 1080) );
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

void mousePressed() {
  swap = !swap;

  PVector zero = new PVector(0, 0, 0);
  doug.left_eye.setAngDeg(zero);
  doug.right_eye.setAngDeg(zero);
  doug.torso_top.setAngDeg(zero);
  doug.neck.setAngDeg(zero);
  doug.left_arm_upper.setAngDeg(new PVector(0, 0, 180));
  doug.right_arm_upper.setAngDeg(zero);
  doug.torso_mid.setAngDeg(zero);
  doug.torso_bot.setAngDeg(zero);
  doug.left_leg_upper.setAngDeg(zero);
  doug.right_leg_upper.setAngDeg(zero);
}
