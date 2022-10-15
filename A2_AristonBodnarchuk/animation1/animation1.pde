final int FPS = 30;

// store objs
Object_ objs[];

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
    objs[oIndex].display();

  if (frameCount >= animationEndFrame)
    ANIMATION_START = false;
}

int loadAnimation(String animationFile) {
  /* 
   -1 = no frame; 
   -2 = no pos; 
   -3 = no rot; 
   -4 = no scale; 
   -5 = missing width;
   -6 = missing height;
   -42 = type match error;
   -69 = keyframe timing error; 
   -420 = failed to load path for object or image / texture;
   -666 = objectless keyframe error;
   -690 = missing texture error;
   */
  int ERR_CODE = 0; 

  anim = loadXML(animationFile);

  // load xml objects
  XML[] XMLobjs = anim.getChildren("object"); // get list of objects
  XML[] XMLkeys = anim.getChildren("keyframe"); // get list of keyframes

  // prepare array for objs
  objs = new Object_[XMLobjs.length];

  // objectless keyframe error test
  for (int ii = 0; ii < XMLkeys.length; ++ii) {
    // update last frame of animation
    int f_ = XMLkeys[ii].getInt("frame");
    if (f_ > animationEndFrame) animationEndFrame = f_;


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
    // check type mismatch error
    boolean typeCheck = XMLobjs[ii].getString("type").equals("obj") 
      || XMLobjs[ii].getString("type").equals("box") 
      || XMLobjs[ii].getString("type").equals("cube")
      || XMLobjs[ii].getString("type").equals("sphere")
      || XMLobjs[ii].getString("type").equals("img");
    if (!typeCheck) return ERR_CODE = -42;

    String obj_id = XMLobjs[ii].getString("id");

    println("Creating object: id[" + obj_id + "]");

    // 3D obj (obj file + optional mtl file for textures)
    if ( XMLobjs[ii].getString("type").equals("obj")) {
      String obj_path = XMLobjs[ii].getContent();
      // check if file is correct before loading
      if ( new File(sketchPath() + obj_path).isFile() == false) return ERR_CODE = -420;

      objs[ii] = new Object3D(loadShape(obj_path));
    }
    // img (image file)
    if ( XMLobjs[ii].getString("type").equals("img") ) {
      String obj_path = XMLobjs[ii].getContent();
      // check if file is correct before loading
      if ( new File(sketchPath() + obj_path).isFile() == false) return ERR_CODE = -420;
      // attribute check 
      if (!XMLobjs[ii].hasAttribute("width")) return ERR_CODE = -5;
      if (!XMLobjs[ii].hasAttribute("height")) return ERR_CODE = -6;

      int w_ = XMLobjs[ii].getInt("width");
      int h_ = XMLobjs[ii].getInt("height");

      objs[ii] = new Object2D(loadImage(obj_path), w_, h_);
    }
    // if primative, check content texture first then handle object creation 
    if ( XMLobjs[ii].getString("type").equals("cube") 
      || XMLobjs[ii].getString("type").equals("box") 
      || XMLobjs[ii].getString("type").equals("sphere") ) 
    {
      // missing texture check
      // content specifies texture 
      if ( XMLobjs[ii].getContent() == null 
        || XMLobjs[ii].getContent().equals("") 
        || XMLobjs[ii].getContent().equals(" ") ) return ERR_CODE = -690;

      String texture_path = XMLobjs[ii].getContent();
      if ( new File(sketchPath() + texture_path).isFile() == false) return ERR_CODE = -690;

      // box || cube (processing 3d primative cube shape)
      if ( XMLobjs[ii].getString("type").equals("cube") || XMLobjs[ii].getString("type").equals("box") ) {    
        // create a 1x1x1 cube, scale determines "Size"
        PShape shape = createShape(BOX, 1);
        shape.setTexture(loadImage(texture_path));
        shape.setStroke(false);

        objs[ii] = new Object3D(shape);
      }

      // sphere (processing 3d primative sphere shape)
      if ( XMLobjs[ii].getString("type").equals("sphere") ) {
        // create a sphere with radius 1, scale for "size"
        PShape shape = createShape(SPHERE, 1);
        shape.setTexture(loadImage(texture_path));
        shape.setStroke(false);

        objs[ii] = new Object3D(shape);
      }
    }

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
      }
    }
  }

  // if all code executed succesfully return success ERR_CODE
  return ERR_CODE = 0;
}
