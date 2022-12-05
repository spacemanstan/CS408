/*
  keyboard functions
 #########################################
 keep all the keyboard input in one place seperate from main program
 
 this handles keyboard input to toggle the simulations' :
 ---> color mode with c
 ---> fade mode with f
 ---> stroke mode with s
 
 color mode just swaps between grayscale and a green to purple hue value based on density
 fade mode simply turns on or off if the gas should fade out over time or not
 stroke mode just toggles whether drawing the cells should have a black border or not (lets user see cell borders)
 the last mode is not an actual mode of the class but I change the viscosity and it makes it feel like playing with wet sand
 so the unoficial last mode is for sand mode I guess
 */
void keyPressed() {
  if ( Character.toLowerCase(key) == 'c')
    gasSim.toggleColorMode(); 

  if ( Character.toLowerCase(key) == 'f')
    gasSim.toggleFade();

  if ( Character.toLowerCase(key) == 's')
    gasSim.toggleStroke();

  // makes it feel like sand
  if ( Character.toLowerCase(key) == ' ')
    gasSim.thicc = gasSim.thicc == 0 ? 0.00001 : 0;
}
