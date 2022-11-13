/*
  tree structure comprised of many different shapes
 can do poses and shit
 
 to do the translations for arms I need to either translate it down by half so the top of the cylinder is at the joint
 or I need a second cylinder function that 
 */
class CompositeObject {
  PShape shape;
  PVector posRel, posOff, angDeg, ang_min, ang_max; // angles are in degrees

  ArrayList<CompositeObject> children;

  CompositeObject(PShape shape_, PImage texture_, PVector posRel_, PVector posOff_, PVector ang_, PVector ang_min_, PVector ang_max_) {  
    this.shape = shape_;
    this.shape.setTextureMode(REPEAT);
    this.shape.setTexture(texture_);
    this.shape.setStroke(false);
    this.posRel = posRel_.copy();

    this.angDeg = new PVector(0, 0);
    //this.angDeg = ang_.copy();
    this.ang_min = ang_min_.copy();
    this.ang_max = ang_max_.copy();

    this.setAngDeg(ang_);

    children = new ArrayList<CompositeObject>();

    shape.translate(posOff_.x, posOff_.y, posOff_.z);
  }

  void display() {
    pushMatrix();
    translate(this.posRel.x, this.posRel.y, this.posRel.z);

    rotateX( radians(this.angDeg.x) );
    rotateY( radians(this.angDeg.y) );
    rotateZ( radians(this.angDeg.z) );

    shape(shape);

    if (!this.isLeaf())
      for (int i = 0; i < children.size(); ++i)
        children.get(i).display();

    // dont pop matrix until after to stack transformations
    // this lets the object act as if it is a whole
    popMatrix();
  }

  void addChildObj(CompositeObject child) {
    children.add(child);
  }

  void setAngDeg(PVector provided) {
    PVector ang_target = provided.copy();
    this.angDeg.x = constrain(ang_target.x, ang_min.x, ang_max.x);
    this.angDeg.y = constrain(ang_target.y, ang_min.y, ang_max.y);
    this.angDeg.z = constrain(ang_target.z, ang_min.z, ang_max.z);
  }

  boolean isLeaf() {
    // short circuit evaluation prevents null pointer exception
    return children == null || children.isEmpty();
  }
}
