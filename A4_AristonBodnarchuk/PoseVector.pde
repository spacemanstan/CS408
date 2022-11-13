class PoseVector {
  // torso
  PVector torso_top, torso_mid, torso_bot;
  // head 
  PVector neck, head, right_eye, left_eye;
  // arms
  PVector right_arm_upper, right_arm_lower, left_arm_upper, left_arm_lower;
  // legs
  PVector right_leg_upper, right_leg_lower, left_leg_upper, left_leg_lower;

  PoseVector (
  /* torso */    PVector torso_top__, PVector torso_mid__, PVector torso_bot__, 
  /* head  */    PVector neck__, PVector head__, PVector right_eye__, PVector left_eye__, 
  /* arms  */    PVector right_arm_upper__, PVector right_arm_lower__, PVector left_arm_upper__, PVector left_arm_lower__, 
  /* leg   */    PVector right_leg_upper__, PVector right_leg_lower__, PVector left_leg_upper__, PVector left_leg_lower__
    ) {
    torso_top = torso_top__;
    torso_mid = torso_mid__;
    torso_bot = torso_bot__;
    neck = neck__;
    head = head__;
    right_eye = right_eye__;
    left_eye = left_eye__;
    right_arm_upper = right_arm_upper__;
    right_arm_lower = right_arm_lower__;
    left_arm_upper = left_arm_upper__;
    left_arm_lower = left_arm_lower__;
    right_leg_upper = right_leg_upper__;
    right_leg_lower = right_leg_lower__;
    left_leg_upper = left_leg_upper__;
    left_leg_lower = left_leg_lower__;
  }
}
