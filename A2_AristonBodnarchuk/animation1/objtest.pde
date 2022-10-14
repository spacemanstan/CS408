class Object3D {
  PShape obj;
  String id;
  PVector pos, rot, scl;
  int keyFrameIndex;
  ArrayList<Keyframe> keyframes = new ArrayList<Keyframe>();

  Object3D(PShape o, String i) {
    //obj = loadShape(o); // pass path
    obj = o; // pass pshape
    id = i;
  }

  void addKeyframe(int f, PVector p, PVector r, PVector s) {
    // store keyframe into array list
    keyframes.add( new Keyframe(f, p, r, s) );
  }

  void animate() {
    int firstFrame = keyframes.get(0).frame;
    if (frameCount == firstFrame) keyFrameIndex = 0;

    Keyframe thisFrame = keyframes.get(keyFrameIndex);

    if (frameCount == thisFrame.frame) {
      // if keyframe, set values
      pos = thisFrame.pos.copy();
      rot = thisFrame.rot.copy();
      scl = thisFrame.scl.copy();
    } else {
      // interpolation
      int lastFrame = keyframes.get(keyframes.size() - 1).frame;
      Keyframe nextFrame = keyframes.get(keyFrameIndex + 1);
      if(frameCount + 1 == nextFrame.frame) ++keyFrameIndex;

      float frameDiff = nextFrame.frame - thisFrame.frame;

      pos.x += (nextFrame.pos.x - thisFrame.pos.x) / frameDiff;
      pos.y += (nextFrame.pos.y - thisFrame.pos.y) / frameDiff;
      pos.z += (nextFrame.pos.z - thisFrame.pos.z) / frameDiff;
      
      rot.x += (nextFrame.rot.x - thisFrame.rot.x) / frameDiff;
      rot.y += (nextFrame.rot.y - thisFrame.rot.y) / frameDiff;
      rot.z += (nextFrame.rot.z - thisFrame.rot.z) / frameDiff;
      
      scl.x += (nextFrame.scl.x - thisFrame.scl.x) / frameDiff;
      scl.y += (nextFrame.scl.y - thisFrame.scl.y) / frameDiff;
      scl.z += (nextFrame.scl.z - thisFrame.scl.z) / frameDiff;
    }


    println("###################");
    println("fc: " + frameCount + " | kf i: " + keyFrameIndex + " | kf f: " + thisFrame.frame);

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

// holds data
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
