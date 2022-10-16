/*
  this class just creates 2 random points to move around outside of the window 
  lines are drawn and it just adds something to look at on the menu screen
  
  the code here is not the best written, I probably should have just drawn lines
  randomly then rotated the screen or something lol
*/
class RandLine {
  boolean p1_d, p2_d; // true = vertical, false = horizontale
  PVector p1, p2;
  int resetTimer, amt, hue;

  RandLine() {
    hue = (int)random(0, 361);

    p1_d = (int)random(0, 2) == 1;
    p2_d = p1_d; 

    if (p1_d) {
      p1 = new PVector((int)random(0, width), 0);
      p2 = new PVector((int)random(0, width), height);
    } else {
      p1 = new PVector(0, (int)random(0, height));
      p2 = new PVector(width, (int)random(0, height));
    }

    // increase or decrease value randomly
    boolean incOrDec = (int)random(0, 2) == 1;
    amt = (int)random(1, 8) * (incOrDec ? 1 : -1);

    resetTimer = (int)random(FPS / 2, FPS);
  }

  void display() {   
    pushMatrix();
    translate(0, 0, -1);

    pushStyle();
    stroke(hue, 100, 100);
    strokeWeight(3);
    line(p1.x, p1.y, p2.x, p2.y);

    popStyle();
    popMatrix();

    if (p1_d) {
      p1.x += amt;

      if (p1.x > width) {
        p1.x = width;
        p1_d = false;
      }

      if (p1.x < 0) {
        p1.x = 0;
        p1_d = false;
      }
    } else {
      p1.y += amt;

      if (p1.y > height) {
        p1.y = height;
        p1_d = true;
      }

      if (p1.y < 0) {
        p1.y = 0;
        p1_d = true;
      }
    }

    if (p2_d) {
      p2.x -= amt;

      if (p2.x > width) {
        p2.x = width;
        p2_d = false;
      }

      if (p2.x < 0) {
        p2.x = 0;
        p2_d = false;
      }
    } else {
      p2.y -= amt;

      if (p2.y > height) {
        p2.y = height;
        p2_d = true;
      }

      if (p2.y < 0) {
        p2.y = 0;
        p2_d = true;
      }
    }

    --resetTimer;

    if (resetTimer <= 0) {
      // increase or decrease value randomly
      boolean incOrDec = (int)random(0, 2) == 1;
      amt = (int)random(1, 8) * (incOrDec ? 1 : -1);

      resetTimer = (int)random(FPS / 2, FPS);
    }
  }
}
