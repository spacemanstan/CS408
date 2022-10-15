class Object2D extends Object_ {
  PImage img;
  PVector dimensions;

  Object2D(PImage p, float w, float h) {
    img = p; // pass loaded image
    dimensions = new PVector(w, h);
  }

  void display() {
    update();

    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    scale(scl.x, scl.y, scl.z);
    imageMode(CENTER);
    image(img, 0, 0);
    popStyle();
    popMatrix();
  }
}
