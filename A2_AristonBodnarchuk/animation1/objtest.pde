class Object3D {
  PShape obj;
  String id;
  PVector pos, rot, scl;
  int firstFrame, lastFrame, currentKeyFrame, nextKeyFrame;
  ArrayList<keyframe> keyframes = new ArrayList<keyframe>();

  Object3D(PShape o, String i) {
    //obj = loadShape(o); // pass path
    obj = o; // pass pshape

    id = i;
  }

  void addKeyframe(int f, PVector p, PVector r, PVector s) {
    keyframes.add( new keyframe(f, p, r, s) );
  }
}

// holds data
class keyframe {
  int frame;
  PVector pos, rot, scl;

  keyframe(int f, PVector p, PVector r, PVector s) {
    frame = f;
    pos = p.copy();
    rot = r.copy();
    scl = s.copy();
  }
}
