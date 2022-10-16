// data class to hold information for animation objects
class Keyframe {
  int frame;
  PVector pos, rot, scl;

  Keyframe(int f, PVector p, PVector r, PVector s) {
    frame = f;
    pos = p.copy();
    rot = r.copy();
    scl = s.copy();
  }
}
