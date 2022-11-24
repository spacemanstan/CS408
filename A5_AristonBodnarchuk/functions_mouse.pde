void mouseReleased() {
  if (mouseButton == CENTER)
    //gasSim.toggleColorMode(); 
    fadeToggle =! fadeToggle;
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    gasSim.addDensity(mouseX / SCALE, mouseY / SCALE, 100);
    float amtx = mouseX - pmouseX;
    float amty = mouseY - pmouseY;
    gasSim.addVelocity(mouseX / SCALE, mouseY / SCALE, amtx, amty);
  } 

  if (mouseButton == RIGHT) {
    gasSim.removeDensity(mouseX / SCALE, mouseY / SCALE, 100);
  }
}
