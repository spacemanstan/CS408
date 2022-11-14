/*##############################################################################################################
 ##############################################################################################################
 ##############################################################################################################
 
 Name: Ariston Bodnarchuk
 Id:   200285478
 Prof: Alain Crotte
 
 ##############################################################################################################
 
 video demo: http://paulbourke.net/texturelibrary/
 
 Controls
 ##################
 Left Mouse Button   =   Change Pose
 Right Mouse Button   =   Change Pose Mode (interpolate, set, vibe)
 Middle Mouse Button   =   Change Rotation Mode (face forward, circle spin, crazy spin)
 
 Description
 ##################
 My model is built out of composite objects used to form a tree structure that holds a model, and all relevant 
 positioning information as well as an array of children consisting of further composite objects. The model is 
 displayed using the tree structure. By performing a depth first search I am able to stack transformations to 
 play objects relevant to one another rather than relevant to the world. This model is then stored in a class 
 called Boi as root, and global position on the screen as well as rotation are stored. This Boi class also 
 handles setting positions, interpolating, or calculating dynamic dance animations as well as handling 
 different global rotation modes. The main draw function acts as a driver for the boi class, which handles 
 everything for the model. The mouse is used to interact with the instance of the boi class named Doug. 

An array of pose vector data types holds the data for the different poses used by the Boi class.

Rather than use keybindings I used mouse input instead as there are few controls needed and keyboard controls 
are annoying in my opinion. The mouse controls allow a quicker and easier way of checking all functionality works. 

all textures are cited from:
http://paulbourke.net/texturelibrary/
 
 ##############################################################################################################
 ##############################################################################################################
 ##############################################################################################################*/
final int FPS = 60;

PVector xyrNoise = new PVector(0, 0, 0);
final float incNoise = 0.03;

PImage woodTexture;
PShape body, head, arm1, arm2, leg1, leg2;

Boi doug;

int poseMode = 0;
PGraphics blackTexture, whiteTexture;

int poseIndex = 0;
PoseVector[] poses;

void setup() {
  size(1280, 720, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(FPS);
  surface.setTitle("A4 -  Hierarchical Kinematic Animation"); // name the window better

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

  createTwigBoi();

  doug = new Boi();

  createPoses();

  poseIndex = poses.length - 1;
  doug.setAngles(poses[poseIndex]);
}

void draw() {
  lights();
  background_colourful();

  drawTwigBoi();

  doug.display();

  if (poseIndex == poses.length || poseMode == 2) {
    doug.zeroAngs(doug.root);

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
  } else {
    if (poseMode == 0)
      doug.interpPoses(poses[(poseIndex + 1) % poses.length], 0.05);
    if (poseMode == 1)
      doug.setAngles(poses[(poseIndex + 1) % poses.length]);
  }
}

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

void createPoses() {
  poses = new PoseVector[4];

  poses[0] = new PoseVector(
    //___________________________top___________________mid___________________bot__________________________
  /* torso */    new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), 

    //___________________________neck__________________head_________________r_eye_________________l_eye___
  /* head  */    new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), 

    //_________________right_arm_upper_______right_arm_lower_______left_arm_upper________left_arm_lower___
  /* arms  */    new PVector(0, 0, 270), new PVector(0, 0, 0), new PVector(0, 0, 90), new PVector(0, 0, 0), 

    //_________________right_leg_upper_______right_leg_lower_______left_leg_upper________left_leg_lower___
  /* leg   */    new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0)
    );

  poses[1] = new PoseVector(
    //___________________________top___________________mid___________________bot__________________________
  /* torso */    new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), 

    //___________________________neck__________________head_________________r_eye_________________l_eye___
  /* head  */    new PVector(15, 0, 15), new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0), 

    //_________________right_arm_upper_______right_arm_lower_______left_arm_upper________left_arm_lower___
  /* arms  */    new PVector(0, -45, 270), new PVector(0, 0, -60), new PVector(0, -90, 90), new PVector(0, 0, -90), 

    //_________________right_leg_upper_______right_leg_lower_______left_leg_upper________left_leg_lower___
  /* leg   */    new PVector(-45, 0, 0), new PVector(-115, 0, 0), new PVector(15, 0, -15), new PVector(0, 0, 0)
    );

  poses[2] = new PoseVector(
    //___________________________top___________________mid___________________bot__________________________
  /* torso */    new PVector(0, 60, 0), new PVector(0, -30, 0), new PVector(15, 30, 0), 

    //___________________________neck__________________head_________________r_eye_________________l_eye___
  /* head  */    new PVector(-15, 0, -15), new PVector(0, 0, 0), new PVector(-30, -30, 0), new PVector(30, 30, 0), 

    //_________________right_arm_upper_______right_arm_lower_______left_arm_upper________left_arm_lower___
  /* arms  */    new PVector(0, 0, 270), new PVector(0, 0, 90), new PVector(0, 0, 100), new PVector(0, 30, 45), 

    //_________________right_leg_upper_______right_leg_lower_______left_leg_upper________left_leg_lower___
  /* leg   */    new PVector(100, 0, 0), new PVector(-10, 0, 0), new PVector(-15, 0, -15), new PVector(-15, 0, 0)
    );

  poses[3] = new PoseVector(
    //___________________________top___________________mid___________________bot__________________________
  /* torso */    new PVector(0, 60, 0), new PVector(0, -30, 0), new PVector(15, 30, 0), 

    //___________________________neck__________________head_________________r_eye_________________l_eye___
  /* head  */    new PVector(30, 0, -15), new PVector(0, 0, 0), new PVector(45, 0, 0), new PVector(-45, 0, 0), 

    //_________________right_arm_upper_______right_arm_lower_______left_arm_upper________left_arm_lower___
  /* arms  */    new PVector(30, 0, 245), new PVector(0, 0, 15), new PVector(10, 0, 10), new PVector(0, -10, 10), 

    //_________________right_leg_upper_______right_leg_lower_______left_leg_upper________left_leg_lower___
  /* leg   */    new PVector(15, 0, 0), new PVector(-10, 0, 0), new PVector(-15, 0, -15), new PVector(-15, 0, 0)
    );
}

void mousePressed() {
  if (mouseButton == CENTER)
    doug.incRotateMode();

  if (mouseButton == RIGHT) {
    ++poseMode;
    poseMode %= 3;
  }

  if (mouseButton == LEFT) {
    if (poseMode == 2)
      poseIndex = poses.length;
    else
      poseIndex = (poseIndex + 1) % poses.length;
  }
}
