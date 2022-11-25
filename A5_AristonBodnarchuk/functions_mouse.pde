/*
  mouse functions
 #########################################
 keep all the mouse input in one place seperate from main program
 
 allows the user to affect simulation based on current mouse position
 ---> add velocity + add denisty with left click && mouse drag
 ---> remove density with right click && mouse drag
 ---> toggle simulation color mode with middle mouse click (on release)
 ---> toggle simulation fade mode with right click && no mouse drag (on release)
 
 color mode just swaps between grayscale and a green to purple hue value based on density
 fade mode simply turns on or off if the gas should fade out over time or not
 
 when the mouse is pressed, a boolean is set to track if the mouse has been dragged yet
 if the mouse is not dragged when the mouse is released, clicking and dragging and just
 clicking can be differentiated easily.
 */

boolean pressedNotDragged;

void mousePressed() {
  pressedNotDragged = true;
}

void mouseReleased() {
  if (mouseButton == CENTER)
    gasSim.toggleColorMode();

  if (pressedNotDragged && mouseButton == RIGHT)
    gasSim.toggleFade();
}

void mouseDragged() {
  pressedNotDragged = false;

  if (mouseButton == LEFT) {
    gasSim.addDyeDensity(mouseX / SCALE, mouseY / SCALE, 100);
    float amtx = mouseX - pmouseX;
    float amty = mouseY - pmouseY;
    gasSim.addVelocity(mouseX / SCALE, mouseY / SCALE, amtx, amty);
  } 

  if (mouseButton == RIGHT) {
    gasSim.removeDyeDensity(mouseX / SCALE, mouseY / SCALE, 100);
  }
}
