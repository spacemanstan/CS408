/*
  
 abbafjbafaf
 !!!!!!!!!!!!!!!!!!!!111
 
 do not forget to set framecount to 0 when animation is starting
 and textureWrap(REPEAT);
 */

class AnimationSystem {
  File startDir, startDirXML;
  XML anim;
  int btnIndex = -1, animationEndFrame = -1, LOAD_STATUS, ERR_TIMER = -1;
  String animationPath = null, exportPath = null, SYS_STATE = "MENU";
  ;
  PImage helpScreen;
  boolean showHelp = false, ANIMATION_START = false;

  Button menuBtns[];
  // animation objects (stored with abstract super type)
  Object_ objs[];

  AnimationSystem() {
    // load help screen image
    helpScreen = loadImage("./resources/placeHolder.png");

    // very important but very difficult to figure out
    startDir = new File(sketchPath()); 
    startDirXML = new File(sketchPath("")+"*.xml"); // filters only xml files for animation files

    // initialize buttons
    initBtns();

    // make textures repeat
    textureWrap(REPEAT);
  }

  void run() {
    background(69); // nice

    if (SYS_STATE == "MENU")
      run_menu();

    if (SYS_STATE == "PLAY")
      playAnimation();

    if (SYS_STATE == "END") {
      background(0);

      // display "fin"; click to continue
      pushStyle(); // prevent styling collisions 
      rectMode(CENTER); // make life easy 

      // white text 
      fill(360);

      textAlign(CENTER, BOTTOM);
      textSize(width*0.05);
      text("fin", width*0.5, height*0.5);

      textAlign(CENTER, TOP);
      textSize(width*0.03);
      text("Left Click -> Back to Menu", width*0.5, height*0.6);

      textAlign(CENTER, TOP);
      textSize(width*0.03);
      text("Right Click -> Replay Animation", width*0.5, height*0.65);
      popStyle();
    }
  }

  void run_menu() {
    if (showHelp) {
      image(helpScreen, 0, 0, width, height);
    } else {
      // display title at top
      pushStyle(); // prevent styling collisions 
      rectMode(CENTER); // make life easy 

      // title text
      textAlign(CENTER, CENTER);
      textSize(height*0.06);
      text("LIOM XML Animation System", width*0.5, height*0.075);
      popStyle();

      // show buttons 
      for (int ii = 0; ii < menuBtns.length; ++ii) 
        if (menuBtns[ii] != null) menuBtns[ii].display();

      // error messages
      if (ERR_TIMER != -1) {
        pushMatrix();
        translate(0, 0, 1);

        pushStyle(); // prevent styling collisions 
        rectMode(CENTER); // make life easy 

        // dark red rect
        fill(360, 69, 69);
        strokeWeight(5);
        stroke(360, 69, 77);
        rect(width*0.5, height*0.5, width*0.45, height*0.3, width*0.025);

        // white text
        fill(360);
        
        textAlign(CENTER, BOTTOM);
        textSize(height*0.06);
        text("ERROR CODE: " + LOAD_STATUS, width*0.5, height*0.5);
        
        textAlign(CENTER, TOP);
        textSize(height*0.03);
        text(getErrorMessage(), width*0.5, height*0.5);
        
        popStyle();
        popMatrix();

        if (ERR_TIMER != -1) --ERR_TIMER;
      }
    }
  }

  // to handle mouse released event
  // all mouse events go through this
  void mouseEvent() {
    if (showHelp) {
      showHelp = false;
      return;
    }

    if (SYS_STATE == "END") {
      if (mouseButton == LEFT) SYS_STATE = "MENU";
      else SYS_STATE = "PLAY";
      return;
    }


    for (int ii = 0; ii < menuBtns.length; ++ii)
      if ( menuBtns[ii].clicked() ) {
        btnIndex = ii;
        mouseInputHandler(mouseButton == LEFT);
        return;
      };

    // set btnIndex to -1 if no button is clicked
    btnIndex = -1;
  }

  // function to handle inputs from buttons
  void mouseInputHandler(boolean leftClick) {
    if (btnIndex == -1) return;

    switch(btnIndex) {
    case 0:
      // play button
      LOAD_STATUS = loadAnimation(animationPath);
      if (LOAD_STATUS < 0) ERR_TIMER = FPS * 3;
      else SYS_STATE = "PLAY";
      break;
    case 1:
      // load button
      if (leftClick) {
        selectInput("Select an animation XML file:", "selectionHandler", startDirXML);
      } else {
        menuBtns[1].bottomText = "";
        animationPath          = null;
        menuBtns[0].disabled   = true;
      }
      break;
    case 2:
      // export button
      if (leftClick) {
        selectFolder("Select export destination folder:", "selectionHandler", startDir);
      } else {
        menuBtns[2].bottomText = "";
        exportPath             = null;
        menuBtns[3].topText    = "";
        menuBtns[3].disabled   = true;
      }
      break;
    case 3:
      // export checkbox
      menuBtns[3].topText = menuBtns[3].topText == "X" ? "" : "X";
      break;
    case 4:
      // help button 
      showHelp = true;
      break;
    default:
      break;
    }
  }

  void btnSelectionHandler(File selection) {
    // load and play button file handling
    if (btnIndex == 1) {
      if (selection == null) {
        println("User terminated selection; window was closed or user hit cancel.");
      } else {
        // update button and animation path text
        menuBtns[1].bottomText = selection.getName();
        animationPath = selection.getAbsolutePath();
        println("Animation File: " + animationPath);
      }

      // play button disalbed unless animation file is stored
      menuBtns[0].disabled = menuBtns[1].bottomText == null || menuBtns[1].bottomText == "" || animationPath == null;
    }

    if (btnIndex == 2) {
      if (selection == null) {
        println("User terminated selection; window was closed or user hit cancel.");
      } else {
        // update button and animation path text
        menuBtns[2].bottomText = selection.getName();
        exportPath = selection.getAbsolutePath();
        println("Export Path: " + exportPath);
      }

      // play button disalbed unless animation file is stored
      menuBtns[3].disabled = menuBtns[2].bottomText == null || menuBtns[2].bottomText == "" || exportPath == null;
      if (menuBtns[3].disabled) menuBtns[3].topText = "";
    }
  }

  // functio to initialize buttons, less constructor clutter
  void initBtns() {
    // setup buttons array 
    menuBtns = new Button[5];
    /*
    buttons are placed in a semi quarter system. By making all the buttons appear based on screen size percentages
     the window is theortetically rezisable. The limitation with the current implementation is it is designed for 
     typical 16x9 monitor layouts, or rather wide screen layouts and would display but be very ugly at unintended
     no rectangle displays. 
     
     buttons use contrustors to initialize all parameters, see button class for more info 
     */
    // play button; index 0; location top middle
    menuBtns[0] = new Button("Play", "", width*0.5, height*0.3, width*0.05, width*0.3, height*0.2, width*0.025, 120);
    menuBtns[0].disabled = true; // can't play animation if nothing is loaded
    // Load button; index 1; location screen center, below play 
    menuBtns[1] = new Button("Load", "", width*0.5, height*0.55, width*0.05, width*0.3, height*0.2, width*0.025, 270);
    // Export button; index 2; location bottom middle, below load 
    menuBtns[2] = new Button("Export", "", width*0.5, height*0.8, width*0.05, width*0.3, height*0.2, width*0.025, 36);
    // Export checkbox; index 3; left adjacent export 
    menuBtns[3] = new Button("", width*0.3, height*0.8, width*0.05, height*0.1, height*0.1, 0, -1);
    menuBtns[3].disabled = true; // disable export option if no export location
    // help button; index 4; location bottom right corner
    menuBtns[4] = new Button("[?]", width - height*0.1, height - height*0.1, width*0.05, height*0.15, height*0.15, width*0.01, -1);
  }
  
  String getErrorMessage() {
    String errmsg;
    
    switch(LOAD_STATUS) {
        case -1:
          errmsg = "no frame"; 
          break;
        case -2: 
          errmsg = "no pos"; 
          break;
        case -3: 
          errmsg = "no rot"; 
          break;
        case -4: 
          errmsg = "no scale"; 
          break;
        case -5: 
          errmsg = "missing width";
          break;
        case -6: 
          errmsg = "missing height";
          break;
        case -42: 
          errmsg = "type match error";
          break;
        case -69: 
          errmsg = "keyframe timing error"; 
          break;
        case -420: 
          errmsg = "failed to load path for object or image / texture";
          break;
        case -666: 
          errmsg = "objectless keyframe error";
          break;
        case -690: 
          errmsg = "missing texture error";
          break;
        default:
          errmsg = "Unkown error occured"; 
          break;
        }
        
        return errmsg;
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

        // get width and height from attributes
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

  void playAnimation() {
    // setup for animation 
    if (!ANIMATION_START) {
      frameCount = 0;
      ANIMATION_START = true;
    }

    // don't play if not started
    if (!ANIMATION_START) return;

    textureWrap(REPEAT); // make textures work
    for (int oIndex = 0; oIndex < objs.length; ++oIndex)
      objs[oIndex].display();
      
    /*
      if the animation is running check if export is enabled
      if enabled save screenshots in ascending order to export directory 
    */
    if(menuBtns[3].topText.equals("X")) {
      String exportName = menuBtns[1].bottomText.substring(0, menuBtns[1].bottomText.length() - 4);
      
      saveFrame(exportPath + "\\" + exportName + "-######.png");
    }

    if (frameCount >= animationEndFrame) {
      ANIMATION_START = false;
      SYS_STATE = "END";
    }
  }
}
