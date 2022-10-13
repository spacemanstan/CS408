class Object3D {
  PShape obj;
  String id;
  int firstFrame, lastFrame, currentKeyFrame, nextKeyFrame;
  ArrayList<keyframe> keyframes = new ArrayList<keyframe>();
  
  Object3D(String o, String i, int ff, int lf, int cf, int nf) {
    obj = loadShape(o);
    id = i;
  }
  
  void addKeyframe(String i, int f, PVector p, PVector r, PVector s) {
    keyframes.add( new keyframe(i, f, p, r, s) );
  }
}
