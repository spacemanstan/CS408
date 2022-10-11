class Button {
  final PVector btnPos, btnDim;
  final int hue;
  String topText, bottomText;

  Button(String top, String bottom, float px, float py, float textSize, float dimx, float dimy, float roundness, int HUE) {
    topText = top;
    bottomText = bottom;
    btnPos = new PVector(px, py, textSize); /* use 3d PVector to store rect x, y, and roundness */
    btnDim = new PVector(dimx, dimy, roundness); /* use 3d PVector to store rect dimensions + text size */
    hue = HUE;
  }
  
  Button(String top, float px, float py, float textSize, float dimx, float dimy, float roundness, int HUE) {
    this(top, null, px, py, textSize, dimx, dimy, roundness, HUE); 
  }

  void display() {
    pushStyle(); // prevent styling collisions 
    rectMode(CENTER); // make life easy 
    
    // gray scale for non hue buttons
    if(hue == -1) {
      fill(hue, 0, 90);
      stroke(hue, 0, 50);
    } else {
      fill(hue, 20, 90);
      stroke(hue, 15, 50);
    }
    
    strokeWeight(5);
    rect(btnPos.x, btnPos.y, btnDim.x, btnDim.y, btnDim.z);
    
    fill(360); // white
    if(topText == "X") fill(0);
    textAlign(CENTER, CENTER);
    textSize(btnPos.z);
    text(topText, btnPos.x, btnPos.y);

    popStyle();
  }
}
