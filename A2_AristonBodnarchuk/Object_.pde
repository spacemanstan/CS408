/*
  abstract super class to allow all object types to be stored in a single array 
 */
abstract class Object_ {
  String objId;
  PVector pos, rot, scl;
  int keyFrameIndex;
  ArrayList<Keyframe> keyframes = new ArrayList<Keyframe>();

  void addKeyframe(int f, PVector p, PVector r, PVector s) {
    // store keyframe into array list
    keyframes.add( new Keyframe(f, p, r, s) );
  } 

  void update() {
    int firstFrame = keyframes.get(0).frame;
    if (frameCount == firstFrame) keyFrameIndex = 0;

    Keyframe thisFrame = keyframes.get(keyFrameIndex);

    // set keyframe values or interpolate depending on frameCount (current frame)
    if (frameCount == thisFrame.frame) {
      // if keyframe, set values
      pos = thisFrame.pos.copy();
      rot = thisFrame.rot.copy();
      scl = thisFrame.scl.copy();
      // if at a keyframe, assign keyframe values
    } else {
      // interpolation
      Keyframe nextFrame = keyframes.get(keyFrameIndex + 1);
      if (frameCount + 1 == nextFrame.frame) ++keyFrameIndex;

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
  }

  abstract void display();
}
