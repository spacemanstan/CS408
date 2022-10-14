final int FPS = 30;

// store objs
Object3D objs[];

XML anim;
int animationEndFrame = -1;
boolean ANIMATION_START = false;

public void setup() {
  size(1280, 720, P3D); // "720p HD" window resolution 
  colorMode(HSB, 360, 100, 100);
  //fullScreen();

  //test = loadShape("spaceShip/spaceShip.obj");

  // set framerate
  frameRate(FPS);

  int loadResult = loadAnimation("animation1.xml");

  if (loadResult == 0) {
    println("Animation creation successful; objects and keyframes loaded succesfully without error. ");
  } else {
    println("Animation creation failed; error code: " + loadResult);
  }
}

void draw() {
  background(69); // nice

  playAnimation();
}

void playAnimation() {
  if (!ANIMATION_START && mousePressed && mouseButton == LEFT) {
    frameCount = 0;
    ANIMATION_START = true;
  }

  // don't play if not started
  if (!ANIMATION_START) {
    //println(frameCount);
    return;
  }

  textureWrap(REPEAT); // make textures work
  for (int oIndex = 0; oIndex < objs.length; ++oIndex)
    objs[oIndex].animate();

  if (frameCount >= animationEndFrame)
    ANIMATION_START = false;
}

int loadAnimation(String animationFile) {
  /* 
   -1 = no frame; 
   -2 = no pos; 
   -3 = no rot; 
   -4 = no scale; 
   -69 = keyframe timing error; 
   -420 = failed to load something 
   -666 = objectless keyframe error
   */
  int ERR_CODE = 0; 

  anim = loadXML(animationFile);

  // load xml objects
  XML[] XMLobjs = anim.getChildren("object"); // get list of objects
  XML[] XMLkeys = anim.getChildren("keyframe"); // get list of keyframes

  // prepare array for objs
  objs = new Object3D[XMLobjs.length];

  // objectless keyframe error test
  for (int ii = 0; ii < XMLkeys.length; ++ii) {
    boolean errorCheck = true;
    for (int jj = 0; jj < XMLobjs.length; ++jj) {
      if ( XMLkeys[ii].getString("id").equals(XMLobjs[jj].getString("id")) ) {
        errorCheck = false;
        break;
      }
    }
    if (errorCheck) return ERR_CODE = -666;
  }

  // iterate through each object, then retrieve and add all related keyframes
  // if errors are encountered exit with correct error
  for (int ii = 0; ii < XMLobjs.length; ++ii) {
    String obj_id = XMLobjs[ii].getString("id");
    String obj_path = XMLobjs[ii].getContent();
    println("Creating object: id[" + obj_id + "], file[" + obj_path + "]");

    // check if file is correct before loading
    if ( new File(sketchPath() + obj_path).isFile() == false) return ERR_CODE = -420;

    objs[ii] = new Object3D(loadShape(obj_path), obj_id);

    // iterate and add keyframes for current object
    for (int jj = 0; jj < XMLkeys.length; ++jj) {
      String kf_id = XMLkeys[jj].getString("id");

      // make sure ids match
      if (kf_id.equals(obj_id)) {
        // precheck for errors getting attributes and children
        // fat ternary operator to "one line" (broken up for readability) check for errors
        ERR_CODE = !XMLkeys[jj].hasAttribute("frame") ? -1 
          : (XMLkeys[jj].getChild("position") == null ? -2 
          : (XMLkeys[jj].getChild("rotation") == null ? -3 
          : (XMLkeys[jj].getChild("scale") == null ? -3 
          : 0)));

        // stop here and return error if something went wrong
        if (ERR_CODE != 0) {
          return ERR_CODE;
        }

        // grab keyframe info from xml

        // get frame
        int f_ = XMLkeys[jj].getInt("frame");

        // update last frame of animation
        if (f_ > animationEndFrame) animationEndFrame = f_;

        // keyframe timing error check
        // check remaining frames
        if (jj != XMLkeys.length - 1)
          for (int kfc = jj; kfc < XMLkeys.length; ++kfc)
            if ( XMLkeys[jj + 1].getString("id").equals(obj_id) && XMLkeys[jj + 1].getInt("frame") <= f_ )
              return ERR_CODE = -69;

        // get pos
        PVector p_ = new PVector(
          XMLkeys[jj].getChild("position").getFloat("x"), 
          XMLkeys[jj].getChild("position").getFloat("y"), 
          XMLkeys[jj].getChild("position").getFloat("z")
          );

        // get rotation
        PVector r_ = new PVector(
          radians( XMLkeys[jj].getChild("rotation").getFloat("x") ), 
          radians( XMLkeys[jj].getChild("rotation").getFloat("y") ), 
          radians( XMLkeys[jj].getChild("rotation").getFloat("z") )
          );

        // get scale
        PVector s_ = new PVector(
          XMLkeys[jj].getChild("scale").getFloat("x"), 
          XMLkeys[jj].getChild("scale").getFloat("y"), 
          XMLkeys[jj].getChild("scale").getFloat("z")
          );

        println("Obj " + obj_id + " adding keyframe f: " + f_ + " p:" + p_ + " r:" + r_ + " s:" + s_ );
        objs[ii].addKeyframe(f_, p_, r_, s_);

        // original first frame and last frame check 
        // last step is to check if this is the firt or last frame and record it
        //if (jj == 0 || jj == XMLkeys.length -1) 
        //  if (jj == 0) objs[ii].firstFrame = f_;
        //  else         objs[ii].lastFrame  = f_;
      }
    }
  }

  return 0;
}
