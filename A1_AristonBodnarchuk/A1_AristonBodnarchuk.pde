final int FPS = 60;
ParticleSystem emitter;

int farts = 0;

void setup() {
  size(1280, 720, P3D);
  frameRate(FPS);
  colorMode(RGB, 100, 100, 100, 100);

  emitter = new ParticleSystem();
}

void draw() {
  background(69); // nice

  // keyboard check, limit update so it doesn't update at full framerate
  if (keyPressed && frameCount % (FPS/4) == 0) {
    if (key == 'A' || key == 'a') {
      farts = key == 'A' ? farts + 1 : farts - 1;
      println(farts);
    }
  }

  emitter.display();

  println("Performance: fps[" + round(frameRate) + "] | particles[" + emitter.particles.size() + "]" );
}

//// clicking mouse modifies shape for testing 
//void mousePressed() {
//  if (mouseButton == LEFT) {
//    //shapeMod = shapeMod != 1 ? 1 : (incDecTog ? 0.5 : 1.5);
//    //if(shapeMod == 0.5) incDecTog = false;
//    //if(shapeMod == 1.5) incDecTog = true;
//    choice = incDecTog ? choice + 1 : choice - 1;

//    if(choice == 0) incDecTog = true;
//    if(choice == cubeRange_e - cubeRange_s) incDecTog = false;

//    println(choice);
//  }
//}

//// scroll mouse to increase / decrease zoom;
//void mouseWheel(MouseEvent event) {
//  zoom -= event.getCount()*10;
//}
