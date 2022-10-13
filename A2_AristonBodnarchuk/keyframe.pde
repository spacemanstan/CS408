// holds data
class keyframe {
  String id;
  int frame;
  PVector pos, rot, scl;
  
  keyframe(String i, int f, PVector p, PVector r, PVector s) {
    id = i;
    frame = f;
    pos = p.copy();
    rot = r.copy();
    scl = s.copy();
  }
}
