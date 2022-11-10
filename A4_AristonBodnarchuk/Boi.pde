class Boi {
  PVector pos;
  // torso (+ root)
  CompositeObject torso_top, torso_mid, torso_bot;
  // head objects 
  CompositeObject neck, head, eye_left, eye_right, pupil_left, pupil_right, ear_left, ear_right;
  // arms
  CompositeObject right_arm_upper, right_arm_lower, left_arm_upper, left_arm_lower;
  // legs
  CompositeObject right_leg_upper, right_leg_lower, left_leg_upper, left_leg_lower;
  // root
  CompositeObject root;

  Boi (float x_, float y_, float z_) {
    pos = new PVector(x_, y_, z_);

    buildBoiObjects();
    someAssemblyRequired();

    root = torso_mid;
  }

  void someAssemblyRequired() {
    torso_mid.addChildObj(torso_top);
    //torso_mid.addChildObj(torso_bot);
    
    //neck.addChildObj(head);
    //head.addChildObj(eye_left);
    //head.addChildObj(eye_right);
    //head.addChildObj(pupil_left);
    //head.addChildObj(pupil_right);
    //head.addChildObj(ear_left);
    //head.addChildObj(ear_right);

    right_arm_upper.addChildObj(right_arm_lower);
    //left_arm_upper.addChildObj(left_arm_lower);

    //right_leg_upper.addChildObj(right_leg_lower);
    //left_leg_upper.addChildObj(left_leg_lower);

    //torso.addChildObj(neck);
    torso_top.addChildObj(right_arm_upper);
    //torso.addChildObj(right_leg_upper);
    //torso.addChildObj(left_arm_upper);
    //torso.addChildObj(left_leg_upper);
  }

  void buildBoiObjects() {
    torso_top = new CompositeObject(
      "torso_top", // id
      cylinder(30, 30, 10), // shape
      randomTexture(), // texture
      new PVector(0, -10, 0), // relative position to parent
      new PVector(0, 5, 0), // position offset for rotate
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );
      
      torso_mid = new CompositeObject(
      "torso_mid", // id
      cylinder(30, 30, 10), // shape
      randomTexture(), // texture
      new PVector(0, 0, 0), // relative position to parent
      new PVector(0, 0, 0), // position offset for rotate
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );
      
      //torso_bot = new CompositeObject(
      //"torso_bot", // id
      //cylinder(30, 30, 50), // shape
      //randomTexture(), // texture
      //new PVector(0, 0, 0), // relative position to parent
      //new PVector(0, 80, 0), // position offset for rotate
      //new PVector(0, 0, 0), // ang
      //new PVector(-360, -360, -360), // ang_min
      //new PVector(360, 360, 360)  // ang_max
      //);

    right_arm_upper = new CompositeObject(
      "right_arm_upper", // id
      cylinder(30, 10, 40), // shape
      randomTexture(), // texture
      new PVector(40, 0, 0), // relative position to parent
      new PVector(0, 10, 0), // position offset for rotate
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );

    right_arm_lower = new CompositeObject(
      "right_arm_lower", // id
      cylinder(30, 10, 40), // shape
      randomTexture(), // texture
      new PVector(0, 40, 0), // relative position to parent
      new PVector(0, 10, 0), // position offset for rotate
      new PVector(0, 0, 0), // ang
      new PVector(-360, -360, -360), // ang_min
      new PVector(360, 360, 360)  // ang_max
      );
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

  void display() {
    pushMatrix();

    translate(pos.x, pos.y, pos.z);

    //rotateY( radians(frameCount % 360) );
    //rotateZ( radians(frameCount % 720) );

    root.display();

    popMatrix();
  }

  void setRoot(CompositeObject part) {
    this.root = part;
  }
}
