class Boi {
  PVector pos;
  // torso (+ root)
  CompositeObject torso_top, torso_mid, torso_bot;
  // head objects 
  CompositeObject neck, head, right_eye, left_eye, pupil, right_ear, left_ear, nose;
  // arms
  CompositeObject right_arm_upper, right_arm_lower, left_arm_upper, left_arm_lower, hand;
  // legs
  CompositeObject right_leg_upper, right_leg_lower, right_leg_foot, left_leg_upper, left_leg_lower, left_leg_foot;
  // root
  CompositeObject root;

  int rotateMode = 0;

  Boi (float x_, float y_, float z_) {
    pos = new PVector(x_, y_, z_);

    buildBoiObjects();
    //someAssemblyRequired();

    root = torso_mid;
  }

  void setAngles(PoseVector angles) {
    torso_top.setAngDeg(angles.torso_top);
    torso_mid.setAngDeg(angles.torso_mid);
    torso_bot.setAngDeg(angles.torso_bot);
    neck.setAngDeg(angles.neck);
    head.setAngDeg(angles.head);
    right_eye.setAngDeg(angles.right_eye);
    left_eye.setAngDeg(angles.left_eye);
    right_arm_upper.setAngDeg(angles.right_arm_upper);
    right_arm_lower.setAngDeg(angles.right_arm_lower);
    left_arm_upper.setAngDeg(angles.left_arm_upper);
    left_arm_lower.setAngDeg(angles.left_arm_lower);
    right_leg_upper.setAngDeg(angles.right_leg_upper);
    right_leg_lower.setAngDeg(angles.right_leg_lower);
    left_leg_upper.setAngDeg(angles.left_leg_upper);
    left_leg_lower.setAngDeg(angles.left_leg_lower);
  }
  
  void incRotateMode() {
    rotateMode += 1;
    rotateMode %= 3;
  }

  void display() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);
    if (rotateMode == 1 || rotateMode == 2) {
      if (rotateMode == 1) {
        rotateY(radians(frameCount/2 % 360));
      }
      if (rotateMode == 2) {
        rotateY( radians(frameCount % 360) );
        rotateZ( radians(frameCount % 720) );
      }
    }

    root.display();

    popMatrix();
  }

  void buildBoiObjects() {
    buildTorso();
    buildHead();
    buildArms();
    buildLegs();
  }

  Boi (PVector pos_) {
    this(pos_.x, pos_.y, pos_.z);
  }

  Boi (float x_, float y_) {
    this(x_, y_, 0);
  }

  Boi () {
    this(width/3, height/2, 0);
  }

  void zeroAngs(CompositeObject part) {
    PVector zero = new PVector(0, 0, 0);

    part.setAngDeg(zero);

    if (!part.isLeaf())
      for (int i = 0; i < part.children.size(); ++i) {
        CompositeObject child = part.children.get(i);
        child.setAngDeg(zero);
        zeroAngs(child);
      }
  }

  void buildTorso() {
    torso_top = new CompositeObject(
      cylinder(30, 45, 50, 50), // shape
      randomTexture(), // texture
      new PVector(0, 0, 0), // relative position to parent, affected by parent rotation
      new PVector(0, -50, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-180, -180, -180), // ang_min
      new PVector(180, 180, 180)  // ang_max
      );

    torso_mid = new CompositeObject(
      cylinder(30, 50, 30, 50), // shape
      randomTexture(), // texture
      new PVector(0, 0, 0), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-180, -180, -180), // ang_min
      new PVector(180, 180, 180)  // ang_max
      );

    torso_bot = new CompositeObject(
      cylinder(30, 30, 50), // shape
      randomTexture(), // texture
      new PVector(0, 0, 0), // relative position to parent, affected by parent rotation
      new PVector(0, 50, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-180, -180, -180), // ang_min
      new PVector(180, 180, 180)  // ang_max
      );

    torso_mid.addChildObj(torso_top);
    torso_mid.addChildObj(torso_bot);
  }

  void buildHead() {
    neck = new CompositeObject(
      cylinder(30, 3, 40), // shape
      randomTexture(), // texture
      new PVector(0, -50, 0), // relative position to parent, affected by parent rotation
      new PVector(0, -40, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-30, -75, -30), // ang_min
      new PVector(30, 75, 30)  // ang_max
      );

    head = new CompositeObject(
      createShape(SPHERE, 35), // shape
      randomTexture(), // texture
      new PVector(0, -80, 0), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(0, 0, 0), // ang_min
      new PVector(0, 0, 0)  // ang_max
      );

    right_eye = new CompositeObject(
      createShape(SPHERE, 10), // shape
      whiteTexture, // texture
      new PVector(-20, -7.5, 25), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-180, -180, -180), // ang_min
      new PVector(180, 180, 180)  // ang_max
      );

    left_eye = new CompositeObject(
      createShape(SPHERE, 10), // shape
      whiteTexture, // texture
      new PVector(20, -7.5, 25), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-180, -180, -180), // ang_min
      new PVector(180, 180, 180)  // ang_max
      );

    pupil = new CompositeObject(
      createShape(SPHERE, 3), // shape
      blackTexture, // texture
      new PVector(0, 0, 8), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(0, 0, 0), // ang_min
      new PVector(0, 0, 0)  // ang_max
      );

    // ears should have the same texture 
    PImage earTexture = randomTexture();

    right_ear = new CompositeObject(
      createShape(SPHERE, 8), // shape
      earTexture, // texture
      new PVector(-35.5, 0, 0), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(0, 0, 0), // ang_min
      new PVector(0, 0, 0)  // ang_max
      );

    left_ear = new CompositeObject(
      createShape(SPHERE, 8), // shape
      earTexture, // texture
      new PVector(35.5, 0, 0), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(0, 0, 0), // ang_min
      new PVector(0, 0, 0)  // ang_max
      );

    nose = new CompositeObject(
      cylinder(30, 5.25, 60), // shape
      randomTexture(), // texture
      new PVector(0, -2.5, 40), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(90, 0, 0), // ang
      new PVector(90, 0, 0), // ang_min
      new PVector(90, 0, 0)  // ang_max
      );

    torso_top.addChildObj(neck);
    neck.addChildObj(head);
    head.addChildObj(right_eye);
    head.addChildObj(left_eye);
    right_eye.addChildObj(pupil);
    left_eye.addChildObj(pupil);
    head.addChildObj(left_ear);
    head.addChildObj(right_ear);
    head.addChildObj(nose);
  }

  void buildArms() {
    // 180 z angle = up, 90 = straigh out, 0 = down
    right_arm_upper = new CompositeObject(
      cylinder(30, 8, 60), // shape
      randomTexture(), // texture
      new PVector(-50, -50, 0), // relative position to parent, affected by parent rotation
      new PVector(0, -30, 0), // position offset for rotate, affected by self rotation
      // 360 z angle = up, 270 = straigh out, 180 = down
      new PVector(0, 0, 270), // ang
      new PVector(0, -90, 180), // ang_min
      new PVector(0, 90, 360)  // ang_max
      );

    right_arm_lower = new CompositeObject(
      cylinder(30, 8, 60), // shape
      randomTexture(), // texture
      new PVector(0, -60, 0), // relative position to parent, affected by parent rotation
      new PVector(0, -30, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    // 180 z angle = down, 90 = straigh out, 0 = up
    left_arm_upper = new CompositeObject(
      cylinder(30, 8, 60), // shape
      randomTexture(), // texture
      new PVector(50, -50, 0), // relative position to parent, affected by parent rotation
      new PVector(0, -30, 0), // position offset for rotate, affected by self rotation
      // 180 z angle = down, 90 = straigh out, 0 = up
      new PVector(0, 0, 90), // ang
      new PVector(0, -90, 0), // ang_min
      new PVector(0, 90, 180)  // ang_max
      );

    left_arm_lower = new CompositeObject(
      cylinder(30, 8, 60), // shape
      randomTexture(), // texture
      new PVector(0, -60, 0), // relative position to parent, affected by parent rotation
      new PVector(0, -30, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    hand = new CompositeObject(
      createShape(SPHERE, 10), // shape
      randomTexture(), // texture
      new PVector(0, -65, 0), // relative position to parent, affected by parent rotation
      new PVector(0, 0, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(0, 0, 0), // ang_min
      new PVector(0, 0, 0)  // ang_max
      );

    torso_top.addChildObj(right_arm_upper);
    right_arm_upper.addChildObj(right_arm_lower);
    right_arm_lower.addChildObj(hand);
    torso_top.addChildObj(left_arm_upper);
    left_arm_upper.addChildObj(left_arm_lower);
    left_arm_lower.addChildObj(hand);
  }

  void buildLegs() {
    right_leg_upper = new CompositeObject(
      cylinder(30, 11, 8, 60), // shape
      randomTexture(), // texture
      new PVector(-25, 70, 0), // relative position to parent, affected by parent rotation
      new PVector(4, 30, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    right_leg_lower = new CompositeObject(
      cylinder(30, 8, 10, 60), // shape
      randomTexture(), // texture
      new PVector(0, 60, 0), // relative position to parent, affected by parent rotation
      new PVector(4, 30, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    right_leg_foot = new CompositeObject(
      cylinder(30, 10, 33), // shape
      randomTexture(), // texture
      new PVector(0, 69, 0), // relative position to parent, affected by parent rotation
      new PVector(4, 7, 0), // position offset for rotate, affected by self rotation
      new PVector(90, 0, 0), // ang
      new PVector(90, 0, 0), // ang_min
      new PVector(90, 0, 0)  // ang_max
      );


    left_leg_upper = new CompositeObject(
      cylinder(30, 11, 8, 60), // shape
      randomTexture(), // texture
      new PVector(25, 70, 0), // relative position to parent, affected by parent rotation
      new PVector(-4, 30, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    left_leg_lower = new CompositeObject(
      cylinder(30, 8, 10, 60), // shape
      randomTexture(), // texture
      new PVector(0, 60, 0), // relative position to parent, affected by parent rotation
      new PVector(-4, 30, 0), // position offset for rotate, affected by self rotation
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    left_leg_foot = new CompositeObject(
      cylinder(30, 10, 33), // shape
      randomTexture(), // texture
      new PVector(0, 69, 0), // relative position to parent, affected by parent rotation
      new PVector(-4, 7, 0), // position offset for rotate, affected by self rotation
      new PVector(90, 0, 0), // ang
      new PVector(90, 0, 0), // ang_min
      new PVector(90, 0, 0)  // ang_max
      );

    torso_bot.addChildObj(right_leg_upper);
    right_leg_upper.addChildObj(right_leg_lower);
    right_leg_lower.addChildObj(right_leg_foot);
    torso_bot.addChildObj(left_leg_upper);
    left_leg_upper.addChildObj(left_leg_lower);
    left_leg_lower.addChildObj(left_leg_foot);
  }

  void interpPoses(PoseVector targetPosition, float speed) {
    torso_top.angDeg.x = lerp(torso_top.angDeg.x, targetPosition.torso_top.x, speed);
    torso_top.angDeg.y = lerp(torso_top.angDeg.y, targetPosition.torso_top.y, speed);
    torso_top.angDeg.z = lerp(torso_top.angDeg.z, targetPosition.torso_top.z, speed);
    torso_mid.angDeg.x = lerp(torso_mid.angDeg.x, targetPosition.torso_mid.x, speed);
    torso_mid.angDeg.y = lerp(torso_mid.angDeg.y, targetPosition.torso_mid.y, speed);
    torso_mid.angDeg.z = lerp(torso_mid.angDeg.z, targetPosition.torso_mid.z, speed);
    torso_bot.angDeg.x = lerp(torso_bot.angDeg.x, targetPosition.torso_bot.x, speed);
    torso_bot.angDeg.y = lerp(torso_bot.angDeg.y, targetPosition.torso_bot.y, speed);
    torso_bot.angDeg.z = lerp(torso_bot.angDeg.z, targetPosition.torso_bot.z, speed);
    neck.angDeg.x = lerp(neck.angDeg.x, targetPosition.neck.x, speed);
    neck.angDeg.y = lerp(neck.angDeg.y, targetPosition.neck.y, speed);
    neck.angDeg.z = lerp(neck.angDeg.z, targetPosition.neck.z, speed);
    head.angDeg.x = lerp(head.angDeg.x, targetPosition.head.x, speed);
    head.angDeg.y = lerp(head.angDeg.y, targetPosition.head.y, speed);
    head.angDeg.z = lerp(head.angDeg.z, targetPosition.head.z, speed);
    right_eye.angDeg.x = lerp(right_eye.angDeg.x, targetPosition.right_eye.x, speed);
    right_eye.angDeg.y = lerp(right_eye.angDeg.y, targetPosition.right_eye.y, speed);
    right_eye.angDeg.z = lerp(right_eye.angDeg.z, targetPosition.right_eye.z, speed);
    left_eye.angDeg.x = lerp(left_eye.angDeg.x, targetPosition.left_eye.x, speed);
    left_eye.angDeg.y = lerp(left_eye.angDeg.y, targetPosition.left_eye.y, speed);
    left_eye.angDeg.z = lerp(left_eye.angDeg.z, targetPosition.left_eye.z, speed);
    right_arm_upper.angDeg.x = lerp(right_arm_upper.angDeg.x, targetPosition.right_arm_upper.x, speed);
    right_arm_upper.angDeg.y = lerp(right_arm_upper.angDeg.y, targetPosition.right_arm_upper.y, speed);
    right_arm_upper.angDeg.z = lerp(right_arm_upper.angDeg.z, targetPosition.right_arm_upper.z, speed);
    right_arm_lower.angDeg.x = lerp(right_arm_lower.angDeg.x, targetPosition.right_arm_lower.x, speed);
    right_arm_lower.angDeg.y = lerp(right_arm_lower.angDeg.y, targetPosition.right_arm_lower.y, speed);
    right_arm_lower.angDeg.z = lerp(right_arm_lower.angDeg.z, targetPosition.right_arm_lower.z, speed);
    left_arm_upper.angDeg.x = lerp(left_arm_upper.angDeg.x, targetPosition.left_arm_upper.x, speed);
    left_arm_upper.angDeg.y = lerp(left_arm_upper.angDeg.y, targetPosition.left_arm_upper.y, speed);
    left_arm_upper.angDeg.z = lerp(left_arm_upper.angDeg.z, targetPosition.left_arm_upper.z, speed);
    left_arm_lower.angDeg.x = lerp(left_arm_lower.angDeg.x, targetPosition.left_arm_lower.x, speed);
    left_arm_lower.angDeg.y = lerp(left_arm_lower.angDeg.y, targetPosition.left_arm_lower.y, speed);
    left_arm_lower.angDeg.z = lerp(left_arm_lower.angDeg.z, targetPosition.left_arm_lower.z, speed);
    right_leg_upper.angDeg.x = lerp(right_leg_upper.angDeg.x, targetPosition.right_leg_upper.x, speed);
    right_leg_upper.angDeg.y = lerp(right_leg_upper.angDeg.y, targetPosition.right_leg_upper.y, speed);
    right_leg_upper.angDeg.z = lerp(right_leg_upper.angDeg.z, targetPosition.right_leg_upper.z, speed);
    right_leg_lower.angDeg.x = lerp(right_leg_lower.angDeg.x, targetPosition.right_leg_lower.x, speed);
    right_leg_lower.angDeg.y = lerp(right_leg_lower.angDeg.y, targetPosition.right_leg_lower.y, speed);
    right_leg_lower.angDeg.z = lerp(right_leg_lower.angDeg.z, targetPosition.right_leg_lower.z, speed);
    left_leg_upper.angDeg.x = lerp(left_leg_upper.angDeg.x, targetPosition.left_leg_upper.x, speed);
    left_leg_upper.angDeg.y = lerp(left_leg_upper.angDeg.y, targetPosition.left_leg_upper.y, speed);
    left_leg_upper.angDeg.z = lerp(left_leg_upper.angDeg.z, targetPosition.left_leg_upper.z, speed);
    left_leg_lower.angDeg.x = lerp(left_leg_lower.angDeg.x, targetPosition.left_leg_lower.x, speed);
    left_leg_lower.angDeg.y = lerp(left_leg_lower.angDeg.y, targetPosition.left_leg_lower.y, speed);
    left_leg_lower.angDeg.z = lerp(left_leg_lower.angDeg.z, targetPosition.left_leg_lower.z, speed);
  }
}
