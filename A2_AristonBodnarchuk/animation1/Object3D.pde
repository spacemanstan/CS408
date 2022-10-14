class Object3D extends Object_ {
  PShape obj;

  Object3D(PShape o) {
    obj = o; // pass pshape
  }
  
  void display() {
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
