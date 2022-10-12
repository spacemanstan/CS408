/*
  Button Class
 ================
 This class is used to handle everything about the buttons except for the activity they execute.
 Click function is handled outside of the class to simplify interaction with different parts of
 the animation system. Button class still calculates click detection. 
 
 Buttons have two types, single text and multi text
   bottomText == null       -> single text
   bottomText == "" || " "  -> multi text displaying single text
   bottomText == STRING     -> sdisplay both texts on seperate lines
   
 Buttons will show a pastel color unles hue is set to -1 to trigger gray scale mode
   
 Vectors to store position and dimensions use their 3rd vector dimension to hold extra data to
 make smarter use of space, rather than create extra variables.
 */
class Button {
  final PVector btnPos, btnDim;
  final int hue;
  String topText, bottomText;
  boolean disabled ;

  Button(String top, String bottom, float px, float py, float textSize, float dimx, float dimy, float roundness, int HUE) {
    topText = top;
    bottomText = bottom;
    btnPos = new PVector(px, py, textSize); /* use 3d PVector to store rect x, y, and roundness */
    btnDim = new PVector(dimx, dimy, roundness); /* use 3d PVector to store rect dimensions + text size */
    hue = HUE;
    
    // buttons enabled by default
    disabled = false;
  }

  Button(String top, float px, float py, float textSize, float dimx, float dimy, float roundness, int HUE) {
    this(top, null, px, py, textSize, dimx, dimy, roundness, HUE);
  }

  void display() {
    pushStyle(); // prevent styling collisions 
    rectMode(CENTER); // make life easy 

    // gray scale for non hue buttons
    // stroke is set to be darker than fill
    if (hue == -1) {
      fill(hue, 0, 70);
      stroke(hue, 0, 50);
    } else {
      fill(hue, 20, 70);
      stroke(hue, 15, 50);
    }
    
    // disabled buttons should be dark gray to indicate
    if(disabled) {
      fill(hue, 15, 20);
      stroke(hue, 15, 15);
    }

    strokeWeight(5);
    rect(btnPos.x, btnPos.y, btnDim.x, btnDim.y, btnDim.z);


    if (bottomText == null) {
      fill(0); // dark
      textAlign(CENTER, CENTER);
      textSize(btnPos.z);
      text(topText, btnPos.x, btnPos.y - textDescent()*0.5);
    } else {
      fill(360); // white

      if (bottomText == "" || bottomText == " ") {
        textAlign(CENTER, CENTER);
        textSize(btnPos.z);
        text(topText, btnPos.x, btnPos.y);
      } else {
        textAlign(CENTER, BOTTOM);
        textSize(btnPos.z*0.6);
        text(topText, btnPos.x, btnPos.y - btnPos.z*0.2);
        textAlign(CENTER, TOP);
        textSize(btnPos.z*0.4);
        text(bottomText, btnPos.x, btnPos.y + (btnDim.y * 0.25), btnDim.x, btnDim.y*0.25);
      }
    }

    popStyle();
  }

  boolean clicked() {
    // disabled button can't be clicked
    if(disabled)
      return false;
    
    if (mouseY > btnPos.y - btnDim.y*.5 && mouseY < btnPos.y + btnDim.y*.5)
      if (mouseX > btnPos.x - btnDim.x*.5 && mouseX < btnPos.x + btnDim.x*.5)
        return true;

    return false;
  }
}
