abstract class Object_ {
  protected String id;
  protected int frame;
  protected PVector pos, rot, scl, pos_, rot_, scale_;
  
  Object_(String i, int f, PVector p, PVector r, PVector s) {
    id = i;
    frame = f;
    pos = p.copy();
    rot = r.copy();
    scl = s.copy();
    pos_ = p.copy();
    rot_ = r.copy();
    scale_ = s.copy();
  }
  
  void update() {
    
  }
}
