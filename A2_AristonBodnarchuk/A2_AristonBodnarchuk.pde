final int FPS = 60;

// liom = linear interpolation & object models
AnimationSystem liom;

public void setup() {
  size(1280, 720, P3D); // "720p HD" window resolution 
  colorMode(HSB, 360, 100, 100);
  //fullScreen();

  // set framerate
  frameRate(FPS);
  
  // setup animation system
  liom = new AnimationSystem();
}

public void draw() {
  liom.run();
}

void displayTitle() {
  pushStyle(); // prevent styling collisions 
  rectMode(CENTER); // make life easy 

  // title text
  textAlign(CENTER, CENTER);
  textSize(height*0.06);
  text("LIOM XML Animation System", width*0.5, height*0.075);
  popStyle();
}

void mouseReleased() {
  liom.mouseEvent();
}

void onWindowResize() {

}

void selectionHandler(File select) {
  liom.btnSelectionHandler(select);
}
