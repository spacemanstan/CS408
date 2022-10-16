/*
  This class handles image files and their dimensions 
 
 everything in this class is crazy straight forward
 */
class Object2D extends Object_ {
  PImage img;
  PVector dimensions;

  Object2D(String oId, PImage p, float w, float h) {
    objId = oId;
    img = p; // pass loaded image
    dimensions = new PVector(w, h);
  }

  void display() {
    // get first and last frame
    int firstFrame = keyframes.get(0).frame;
    int lastFrame = keyframes.get(keyframes.size() - 1).frame;

    // don't do anything if not displaying
    if (frameCount < firstFrame || frameCount > lastFrame) {
      println("Object does not exist");
      return;
    } else {
      // worthless console spam for assignment requirement 
      println("Object: id[" + objId + "], time(frame): [" + frameCount + "], pos:  " + pos + ", rot: " + rot + ", scale: " + scl + "");
    }

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
