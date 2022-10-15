class Object3D extends Object_ {
  PShape obj;

  Object3D(PShape o) {
    obj = o; // pass pshape
  }
  
  void display() {
    // get first and last frame
    int firstFrame = keyframes.get(0).frame;
    int lastFrame = keyframes.get(keyframes.size() - 1).frame;
    
    // don't do anything if not displaying
    if(frameCount < firstFrame || frameCount > lastFrame) return;
    
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
