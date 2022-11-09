/*
  tree structure comprised of many different shapes
 can do poses and shit
 
 to do the translations for arms I need to either translate it down by half so the top of the cylinder is at the joint
 or I need a second cylinder function that 
 
 having a second cylinder function might be more intiuitive that draws the cylinders top at the origin (0,0) and the bottom at full extent 
 */
class CompositeObject {
  private String id;
  private PShape shape;
  //private PImage texture;
  private PVector pos, angDeg, ang_min, ang_max; // angles are in degrees

  private ArrayList<CompositeObject> children = null;

  CompositeObject(String id_, PShape shape_, PImage texture_, PVector pos_, PVector ang_, PVector ang_min_, PVector ang_max_) {  
    this.id = id_;
    this.shape = shape_;
    this.shape.setTextureMode(REPEAT);
    this.shape.setTexture(texture_);
    this.shape.setStroke(false);
    this.pos = pos_.copy();
    
    this.angDeg = new PVector(0, 0);
    //this.angDeg = ang_.copy();
    this.ang_min = ang_min_.copy();
    this.ang_max = ang_max_.copy();
    
    this.setAng(ang_);
  }

  void display() {
    pushMatrix();
    translate(this.pos.x, this.pos.y, this.pos.z);
    rotateX(this.angDeg.x);
    rotateY(this.angDeg.y);
    rotateZ(this.angDeg.z);
    
    shape(shape);

    if (!this.isLeaf())
      for (int i = 0; i < children.size(); ++i)
        children.get(i).display();

    // dont pop matrix until after to stack transformations
    // this lets the object act as if it is a whole
    popMatrix();
  }
  
  void setAng(PVector provided) {
    PVector ang_target = provided.copy();
    this.angDeg.x = constrain(ang_target.x, ang_min.x, ang_max.x);
    this.angDeg.y = constrain(ang_target.y, ang_min.y, ang_max.y);
    this.angDeg.z = constrain(ang_target.z, ang_min.z, ang_max.z);
  }

  boolean isLeaf() {
    // short circuit evaluation prevents null pointer exception
    return children == null || children.isEmpty();
  }
  
  // remove child, true = deleted, false = failed to remove
  boolean childMurder() {
    if( isLeaf() )
      return false;
      
    for(int i = 0; i < children.size(); ++i)
      return children.remove( children.get(i) );
    
    // this will never be reached, but java needs it 
    return true;
  }
}
