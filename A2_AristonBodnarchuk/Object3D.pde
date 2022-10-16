/*
  This class handles object files and primative types with textures
  
  everything in this class is crazy straight forward
*/
class Object3D extends Object_ {
  PShape obj; // PShape allows storing both obj and custom generated textured primatives 

  Object3D(String oId, PShape o) {
    objId = oId;
    obj = o; // pass pshape
  }
  
  void display() {
    // get first and last frame
    int firstFrame = keyframes.get(0).frame;
    int lastFrame = keyframes.get(keyframes.size() - 1).frame;
    
    // don't do anything if not displaying
    if(frameCount < firstFrame || frameCount > lastFrame) {
      println("Object does not exist");
      return;
    } else {
      // worthless console spam for assignment requirement 
      println("Object: id[" + objId + "], time(frame): [" + frameCount + "], pos:  " + pos + ", rot: " + rot + ", scale: " + scl + "");
    }
    
    update();

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    scale(scl.x, scl.y, scl.z);
    shape(obj);
    popMatrix();
  }
}
