/*
  ButtonData
 =======================
 a straight forward utility class to help manage particle system buttons
 */
class ButtonData {
  final PVector pos, dim; // position and dimensions 
  final String title; // top text display 
  final char upper, lower; // increase / decrease keys
  int value; // what to display for a value (or not display anything if -1)
  boolean rdm = false; // random mode bool
  color color_optional = -1; // if the button can be colored 

  // simple constructor 
  ButtonData(float x, float y, float wid, float hgt, String ttl, int val, char low, char up) {
    pos = new PVector(x, y);
    dim = new PVector(wid, hgt);
    title = ttl;
    value = val;
    upper = up;
    lower = low;
  }

  /*
    display
   ======================
   function used to render elements to screen
   
   draws button appropriately based on stored parameters 
   */
  void display() {
    // rect mode center applies to both drawing rectangles and text boxes
    // first two parameters specify center pos, last two are width and height 
    rectMode(CENTER); 
    pushStyle(); // prevent style contamination 
    strokeWeight(1); // skinny border
    stroke(0); // make border black 

    // if colored, set color 
    if (color_optional == -1)
      fill(69); // nice
    else
      fill(color_optional);

    // draw button
    rect(pos.x, pos.y, dim.x, dim.y);
    // add text 
    fill(0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text(title, pos.x, pos.y - dim.y/3);
    textSize(18);

    // if random mode display text RANDOM
    if (rdm)
      text("RANDOM", pos.x, pos.y);
    // otherwise display value and keys 
    else {
      text("+", pos.x + dim.x*0.45, pos.y);
      text("-", pos.x - dim.x*0.45, pos.y);
      // display value if button has a value to display 
      if (value != -1) text(value, pos.x, pos.y); 
      textSize(12);
      text(lower, pos.x - dim.x*0.45, pos.y - 18);
      text(upper, pos.x + dim.x*0.45, pos.y - 18);
    }

    popStyle();
  }
}
