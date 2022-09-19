class ButtonData {
  final PVector pos, dim; // position and dimensions 
  final String title;
  final char upper, lower;
  int value;
  boolean rdm = false;
  color color_optional = -1;
  
  ButtonData(float x, float y, float wid, float hgt, String ttl, int val, char low, char up) {
    pos = new PVector(x, y);
    dim = new PVector(wid, hgt);
    title = ttl;
    value = val;
    upper = up;
    lower = low;
  }
  
  void display() {
    rectMode(CENTER);
    pushStyle();
    strokeWeight(1);
    stroke(0);
    
    if(color_optional == -1)
      fill(69); // nice
    else
      fill(color_optional);
      
    rect(pos.x, pos.y, dim.x, dim.y);
    fill(0);
    textSize(12);
    textAlign(CENTER, CENTER);
    text(title, pos.x, pos.y - dim.y/3);
    textSize(18);
    
    if(rdm)
      text("RANDOM", pos.x, pos.y);
    else {
      text("+", pos.x + dim.x*0.45, pos.y);
      text("-", pos.x - dim.x*0.45, pos.y);
      if(value != -1) text(value, pos.x, pos.y);
      textSize(12);
      text(lower, pos.x - dim.x*0.45, pos.y - 18);
      text(upper, pos.x + dim.x*0.45, pos.y - 18);
    }
    
    popStyle();
  }
}
