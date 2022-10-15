final int FPS = 60;

// liom = linear interpolation & object models
AnimationSystem liom;

public void setup() {
  size(1280, 720, P3D); // "720p HD" window resolution 
  colorMode(HSB, 360, 100, 100);

  // set framerate
  frameRate(FPS);
  
  // setup animation system
  liom = new AnimationSystem();
}

public void draw() {
  liom.run();
}

void mouseReleased() {
  liom.mouseEvent();
}

void selectionHandler(File select) {
  liom.btnSelectionHandler(select);
}
