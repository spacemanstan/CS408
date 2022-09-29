/*
  CS408 - Alain Maubert Crotte
   Assignment 1: 3D Particle System
   
   Name: Ariston Bodnarchuk
   Id:   200285478
   
   Description
   ==================================
   I used the processing language to create a 3D particle system as outlined by
   the assignemnt specifications. 
   
   I have added lots of creative features to this program as well as have changed
   the default starting parameters for the particle system to be less aggressive 
   and extreme. The best in my experience was one particle a second shot straight 
   up with gray have opaque colors. I kept the emitter starting in the middle of 
   the screen.
   
   Running the program will prompt the user with on screen insctructions, the 
   actual program does not start until the '/' or '?' key is pressed to close 
   the help screen. Users can interact with the inputs either with keyboard or 
   mouse control. Some controls are limited to just keyboard or mouse. Zoom is
   handled only by scrolling. 
   
   Creative Features:
     Mouse functions
     - click buttons
     - right click to rotate camera
     - scroll wheel to zoom in and out
     Help Screen
     - toggled with '?' key
     3D Particles
     - Alain intially said we had to use 3D but enough people requested 2D
      I however already finished the assignment in 3D lol
     Spawn Rate
     - spawn rate can be altered using the '<' and '>' keys 
     Particle Physics 
     - particles have gravity
     - particles have air friction
     - particles have a random spin to them
     On Screen Buttons
     - show values and interact with particle system
 */

final int FPS = 60; // global framerate constant to be used for timing functions
ParticleSystem emitter; // declar particle system

/*
  Setup function is ran first before draw() is called
 allows window parameters to be set prior to running 
 
 disabling the window maximize button does not fuction in P3D properly
 */
void setup() {
  surface.setTitle("Particle System"); // name the window better
  size(1280, 720, P3D); // 1280 x 720 resolution or 720p; low enough resolution to work on most systems
  frameRate(FPS); // set frameRate to 60fps
  // color mode set to RGB values with ranges for values from 0 - 100 including opacity 
  colorMode(RGB, 100, 100, 100, 100);

  // initialize the actual particle system
  emitter = new ParticleSystem();
}

void draw() {
  // comment this out for a cool effect
  background(10); // refresh screen (prevents trailing)

  emitter.display(); // display particles + update particle system

  // CREATIVE FEATURE
  // display performance in console
  println("Performance: fps[" + round(frameRate) + "] | particles[" + emitter.particles.size() + "]" );
}

// CREATIVE FEATURE
/*
  mousePressed event
 ==================
 gets called whenever any mouse button is pressed down; used for single click functions
 
 handling single mouse presses inside of the particle system would be more complicated
 as the update function would be called 60 times a second and variables would be needed
 to track when the mouse is pressed, which button, when it was release, etc; Which seems
 pointless when there is a built in function. The benefit to that would be having press
 and hold to continuously increase however I am happy with it as is given I have the 
 keyboard keys working on a press and hold basis.
 
 mouse input for buttons works by imitating a keyboard press
 buttons store their increase and decrease characters making it easy to fetch the key of
 the clicked button and pass it to the keyboard key handling function in the particle system
 */
void mousePressed() {
  // left click (button interaction)
  if (mouseButton == LEFT)
    // click is in range of bottom row buttons
    if (mouseY > height - emitter.btmRow_height && mouseY < height) {
      // iterate through buttons to find which was clicked
      for (int i = 0; i < emitter.btmRow.length; ++i) {
        // get correct button
        if (mouseX > emitter.btmRow[i].pos.x - emitter.btmRow_width/2 && mouseX < emitter.btmRow[i].pos.x + emitter.btmRow_width/2) {
          // right side of button = increase
          if (mouseX > emitter.btmRow[i].pos.x) {
            key = emitter.btmRow[i].upper;
            // imitate keyboard input with mouse click 
            emitter.buttonFunctions( emitter.btmRow[i].upper );
          }
          // left side of button = decrease
          if (mouseX < emitter.btmRow[i].pos.x) {
            key = emitter.btmRow[i].lower;
            // imitate keyboard input with mouse click 
            emitter.buttonFunctions( emitter.btmRow[i].lower );
          }
        }
      }
    }

  // right click (toggle random for buttons)
  if (mouseButton == RIGHT)
    if (mouseY > height - emitter.btmRow_height && mouseY < height) {
      //right click a button

      // non positional buttons (not x, y, or z emitter position)
      for (int i = 0; i <= 7; ++i) {
        if (mouseX > emitter.btmRow[i].pos.x - emitter.btmRow_width/2 && mouseX < emitter.btmRow[i].pos.x + emitter.btmRow_width/2) {
          emitter.btmRow[i].rdm = !emitter.btmRow[i].rdm;
        }
      }

      // positional buttons (emitter position)
      if (mouseX > emitter.btmRow[8].pos.x - emitter.btmRow_width/2 && mouseX < emitter.btmRow[10].pos.x + emitter.btmRow_width/2) {
        emitter.btmRow[8].rdm = !emitter.btmRow[8].rdm;
        emitter.btmRow[9].rdm = !emitter.btmRow[9].rdm;
        emitter.btmRow[10].rdm = !emitter.btmRow[10].rdm;
      }
    } else {
      // if not clicking buttons then using camera rotation, set initial camera value
      // this works the same as mouseDragged() but I only learnt about that function 
      // after I finished and din't see the point in rewriting the system I made
      emitter.mX = mouseX;
    }
}

// CREATIVE FEATURE
// scroll mouse to increase / decrease zoom;
void mouseWheel(MouseEvent event) {
  // factor by 10 so you dont have to scroll for years to zoom in and out
  // emiter z position acts as zoom 
  emitter.pos.z -= event.getCount()*10;
}

// CREATIVE FEATURE
/*
  seperate keypressed function for toggling helpscreen
 this allows particle system to be paused when the helpscreen is up 
 while not having to keep listening for the helpscreen toggle
 */
void keyPressed() {
  if (key ==  '/' || key == '?') {
    emitter.helpScreen = !emitter.helpScreen;
  }
}
