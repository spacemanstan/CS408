/*
  function to create a cylender pshape object
 drawn like a pole standing straight up
 
 this is done by creating a temporary local group pshare variable to return
 the cylinder is built in simulatenously in the order top, bottom, mid section
 The cylinder must be constructed in this order (or bottom top mid) as the mid
 section needs top and bottom points
 
 Different radiuses can be given for top and bottom
 
 extent = height, but height is a reserved word so extent instead
 
 I didn't know if I should make this a class or a function because I could
 use an anoymous object if I wanted since I would just need the PShape
 */
PShape cylinder(int sides, float radius_top, float radius_bottom, float extent) {
  PShape tempShapeGroup = createShape(GROUP); // return object 

  // calc values
  float angle = 360 / sides; 
  float half = extent / 2;

  // create the shapes we need
  PShape cylinder_top = createShape();
  PShape cylinder_bottom = createShape();
  PShape cylinder_body = createShape();

  // begin all shapes (body needs parameter)
  cylinder_top.beginShape();
  cylinder_bottom.beginShape();
  cylinder_body.beginShape(TRIANGLE_STRIP);


  // build each shape by iterating through sides
  for (int side = 0; side < sides; ++side) {
    // calc trig
    float cosX = cos(side * angle);
    float sinY = sin(side * angle);

    // create + intialize coordinates for top + bottom circles
    PVector top = new PVector(cosX * radius_top, sinY * radius_top);
    PVector bot = new PVector(cosX * radius_bottom, sinY * radius_bottom);

    // calc uv coordinates
    // top uv calculations
    PVector top_n = top.copy(); // copy top values
    top_n.normalize(); // normalize the vector (this is why we need a copy)
    float u_t = atan2(top_n.x, top_n.z) / TWO_PI + 0.5; // map value between -0.5 & 0.5
    float v_t = top_n.y * 0.5 + 0.5;// shift range
    // bottom uv calculations
    PVector bn = new PVector(bot.x, bot.y); // copy bottom values
    bn.normalize(); // normalize the copy of vector
    float u_b = atan2(bn.x, bn.z) / TWO_PI + 0.5; // map value between -0.5 & 0.5
    float v_b = bn.y * 0.5 + 0.5; // shift range

    // top ==> vertex ==> (x, y, z, u, v)
    cylinder_top.vertex(top.x, -half, top.y, u_t, v_t);
    // bottom ==> vertex ==> (x, y, z, u, v)
    cylinder_bottom.vertex(bot.x, half, bot.y, u_b, v_b);
    // middle ==> vertex ==> (x, y, z, u, v)
    cylinder_body.vertex(top.x, -half, top.y, u_t, v_t);
    cylinder_body.vertex(bot.x, half, bot.y, u_b, v_b);
  }

  // end the shapes
  cylinder_top.endShape(CLOSE);
  cylinder_bottom.endShape(CLOSE);
  cylinder_body.endShape(CLOSE);

  // add to group shape 
  tempShapeGroup.addChild(cylinder_top);
  tempShapeGroup.addChild(cylinder_bottom);
  tempShapeGroup.addChild(cylinder_body);

  // after all that math return the shape me made + UV map
  return tempShapeGroup;
}

// optional constructor for if both sides are the same
PShape cylinder(int sides, float radius, float extent) {
  // just call different side function
  return cylinder(sides, radius, radius, extent);
}

// default is just some arbitrary values
PShape cylinder() {
  return cylinder(20, 25, 100);
}
