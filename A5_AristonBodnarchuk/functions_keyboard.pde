/*
  keyboard functions
 #########################################
 keep all the keyboard input in one place seperate from main program
 
 this handles keyboard input to toggle the simulations:
 ---> color mode with c
 ---> fade mode with f
 
 color mode just swaps between grayscale and a green to purple hue value based on density
 fade mode simply turns on or off if the gas should fade out over time or not
 */
void keyPressed() {
  if ( Character.toLowerCase(key) == 'c')
    gasSim.toggleColorMode(); 

  if ( Character.toLowerCase(key) == 'f')
    gasSim.toggleColorFadeMode();
}
