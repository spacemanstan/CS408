/*
  
 abbafjbafaf
 !!!!!!!!!!!!!!!!!!!!111
 
 do not forget to set framecount to 0 when animation is starting
 and textureWrap(REPEAT);
 */

class AnimationSystem {
  File startDir, startDirXML;
  XML animation;

  String SYS_STATE = "MENU";
  //String SYS_STATE = "TEST";

  int btnIndex = -1;
  String animationPath = null, exportPath = null;
  PImage helpScreen;
  boolean showHelp = false;

  Button menuBtns[];

  ArrayList<Object3D> objects = new ArrayList<Object3D>();

  PShape rocket = loadShape("animation1/spaceShip/spaceShip.obj");

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

    if (SYS_STATE == "LOAD") {
      animation = loadXML(animationPath);

      XML[] objs = animation.getChildren("object");
      XML[] kfs = animation.getChildren("keyframe");

      for (int o = 0; o < objs.length; o++) {
        String id = objs[o].getString("id");
        String path = objs[o].getContent();

        Object3D temp = new Object3D(id, path);
        
        boolean first = true;
        
        for (int k = 0; k < kfs.length; k++) {
            String i_ = kfs[k].getString("id");
            
            if(i_ != temp.id)
              break;
 
            int f_ =  kfs[k].getInt("frame");
            
            if(first) {
              temp.firstFrame = f_;
              first = false;
            }
            
            XML pos = kfs[k].getChild("position");
            PVector p_ = new PVector(pos.getFloat("x"), pos.getFloat("y"), pos.getFloat("z"));
            XML rot = kfs[k].getChild("rotation");
            PVector r_ = new PVector(rot.getFloat("x"), rot.getFloat("y"), rot.getFloat("z"));
            XML scl = kfs[k].getChild("scale");
            PVector s_ = new PVector(scl.getFloat("x"), scl.getFloat("y"), scl.getFloat("z"));
            
            temp.addKeyframe(i_, f_, p_, r_, s_);
        }
        
        objects.add(temp);
      }

      frameCount = 0;
      SYS_STATE = "PLAY";
    }

    if (SYS_STATE == "PLAY") {
      for (int i = 0; i < objects.size(); ++i)
        println(objects.get(i).id);
        
      SYS_STATE = "END";
    }

    if (SYS_STATE == "END") {
      // display "fin"; click to continue
      pushStyle(); // prevent styling collisions 
      rectMode(CENTER); // make life easy 

      textAlign(CENTER, BOTTOM);
      textSize(width*0.05);
      text("fin", width*0.5, height*0.5);

      textAlign(CENTER, TOP);
      textSize(width*0.03);
      text("click to continue", width*0.5, height*0.6);
    }

    if (SYS_STATE == "TEST") {
      //pushMatrix();
      //translate(width/2, height/2);
      //rotateX( radians(frameCount%(360*420)) );
      //rotateY( radians(frameCount%(360*10)) );
      //scale(100);
      //shape(rocket);
      //popMatrix();
    }
  }

  void run_menu() {
    if (showHelp) {
      image(helpScreen, 0, 0, width, height);
    } else {
      displayTitle();

      for (int ii = 0; ii < menuBtns.length; ++ii)
        if (menuBtns[ii] != null) menuBtns[ii].display();
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

  void mouseEvent() {
    if (SYS_STATE == "END")
      SYS_STATE = "MENU";

    if (showHelp) {
      showHelp = false;
      return;
    }

    for (int ii = 0; ii < menuBtns.length; ++ii)
      if ( menuBtns[ii].clicked() ) {
        btnIndex = ii;
        btnInputHandler(mouseButton == LEFT);
        return;
      };

    // set btnIndex to -1 if no button is clicked
    btnIndex = -1;
  }

  // function to handle inputs from buttons
  void btnInputHandler(boolean leftClick) {
    if (btnIndex == -1)
      println("no button pressed");
    else
      println("button index " + btnIndex + " clicked");

    switch(btnIndex) {
    case 0:
      println("Building animation");
      SYS_STATE = "LOAD";
      break;
    case 1:
      if (leftClick) {
        selectInput("Select an animation XML file:", "selectionHandler", startDirXML);
      } else {
        menuBtns[1].bottomText = "";
        animationPath          = null;
        menuBtns[0].disabled   = true;
      }
      break;
    case 2:
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
      menuBtns[3].topText = menuBtns[3].topText == "X" ? "" : "X";
      break;
    case 4:
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
}
