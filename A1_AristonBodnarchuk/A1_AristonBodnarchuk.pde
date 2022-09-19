final int FPS = 60;
ParticleSystem emitter;

int farts = 0;

void setup() {
  surface.setTitle("Particle System");
  size(1280, 720, P3D);
  frameRate(FPS);
  colorMode(RGB, 100, 100, 100, 100);

  emitter = new ParticleSystem();
}

void draw() {
  background(30); // nice

  // keyboard check, limit update so it doesn't update at full framerate
  //if (keyPressed && frameCount % (FPS/4) == 0) {
  //  if (key == 'A' || key == 'a') {
  //    farts = key == 'A' ? farts + 1 : farts - 1;
  //    println(farts);
  //  }
  //}

  emitter.display();

  //println("Performance: fps[" + round(frameRate) + "] | particles[" + emitter.particles.size() + "]" );
}

void mousePressed() {
  // left click
  if (mouseButton == LEFT)
    if (mouseY > height - emitter.btmRow_height && mouseY < height) {
      // increase or decrease buttons with left click
      for (int i = 0; i < emitter.btmRow.length; ++i) {
        if (mouseX > emitter.btmRow[i].pos.x - emitter.btmRow_width/2 && mouseX < emitter.btmRow[i].pos.x + emitter.btmRow_width/2) {
          if (mouseX > emitter.btmRow[i].pos.x) {
            key = emitter.btmRow[i].upper;
            emitter.buttonFunctions( emitter.btmRow[i].upper );
          }
          if(mouseX < emitter.btmRow[i].pos.x) {
            key = emitter.btmRow[i].lower;
            emitter.buttonFunctions( emitter.btmRow[i].lower );
          }
        }
      }
    }

  // right click
  if (mouseButton == RIGHT)
    if (mouseY > height - emitter.btmRow_height && mouseY < height) {
      //right click a button

      // non positional buttons
      for (int i = 0; i <= 7; ++i) {
        if (mouseX > emitter.btmRow[i].pos.x - emitter.btmRow_width/2 && mouseX < emitter.btmRow[i].pos.x + emitter.btmRow_width/2) {
          emitter.btmRow[i].rdm = !emitter.btmRow[i].rdm;
        }
      }

      // positional buttons
      if (mouseX > emitter.btmRow[8].pos.x - emitter.btmRow_width/2 && mouseX < emitter.btmRow[10].pos.x + emitter.btmRow_width/2) {
        emitter.btmRow[8].rdm = !emitter.btmRow[8].rdm;
        emitter.btmRow[9].rdm = !emitter.btmRow[9].rdm;
        emitter.btmRow[10].rdm = !emitter.btmRow[10].rdm;
      }
    } else {
      // camera rotation stuff
    }
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
