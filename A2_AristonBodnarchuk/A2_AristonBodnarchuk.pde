Button menuBtns[];

public void setup() {
  size(1280, 720, P3D); // "720p HD" window resolution 
  colorMode(HSB, 360, 100, 100);
  //fullScreen();

  frameRate(60);

  menuBtns = new Button[5];
  // play button (top)
  menuBtns[0] = new Button("Play", width*0.5, height*0.3, width*0.05, width*0.3, height*0.2, width*0.025, 120);
  // toggle export + export location
  menuBtns[1] = new Button("Export", width*0.5 + height*0.1, height*0.55, width*0.05, width*0.3 - height*0.2, height*0.2, width*0.025, 36);
  menuBtns[2] = new Button("X", width*0.4, height*0.55, width*0.05, height*0.15, height*0.15, 0, -1);
  menuBtns[3] = new Button("Load", width*0.5, height*0.8, width*0.05, width*0.3, height*0.2, width*0.025, 270);
  // help button in corner
  menuBtns[4] = new Button("[?]", width - height*0.1, height - height*0.1, width*0.05, height*0.15, height*0.15, width*0.01, -1);
}

public void draw() {
  background(69); // nice

  displayTitle();

  for (int ii = 0; ii < menuBtns.length; ++ii)
    if (menuBtns[ii] != null) menuBtns[ii].display();
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
