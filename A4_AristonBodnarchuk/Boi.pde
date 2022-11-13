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

  Boi (float x_, float y_, float z_) {
    pos = new PVector(x_, y_, z_);

    buildBoiObjects();
    //someAssemblyRequired();

    root = torso_mid;
  }
  
  void interpPoes(PoseVector pose1) {
      torso_top.setAngDeg(pose1.torso_top);
    torso_mid.setAngDeg(pose1.torso_mid);
    torso_bot.setAngDeg(pose1.torso_bot);
    neck.setAngDeg(pose1.neck);
    head.setAngDeg(pose1.head);
    right_eye.setAngDeg(pose1.right_eye);
    left_eye.setAngDeg(pose1.left_eye);
    right_arm_upper.setAngDeg(pose1.right_arm_upper);
    right_arm_lower.setAngDeg(pose1.right_arm_lower);
    left_arm_upper.setAngDeg(pose1.left_arm_upper);
    left_arm_lower.setAngDeg(pose1.left_arm_lower);
    right_leg_upper.setAngDeg(pose1.right_leg_upper);
    right_leg_lower.setAngDeg(pose1.right_leg_lower);
    left_leg_upper.setAngDeg(pose1.left_leg_upper);
    left_leg_lower.setAngDeg(pose1.left_leg_lower);
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

  void display() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);
    rotateY(radians(frameCount/2 % 360));

    //rotateY( radians(frameCount % 360) );
    //rotateZ( radians(frameCount % 720) );

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
    PVector zero = new PVector((part.ang_max.x + part.ang_min.x)/2, (part.ang_max.y + part.ang_min.y)/2, (part.ang_max.y + part.ang_min.y)/2);

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
}
