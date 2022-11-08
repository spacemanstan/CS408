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
    // calc measurements 
    float topX = cosX * radius_top;
    float topY = sinY * radius_top;
    float botX = cosX * radius_bottom;
    float botY = sinY * radius_bottom;

    // top
    cylinder_top.vertex(topX, -half, topY);
    // bottom
    cylinder_bottom.vertex(botX, -half, botY);
    // middle
    cylinder_body.vertex(topX, -half, topY);
    cylinder_body.vertex(botX, half, botY);
  }

  // end the shapes
  cylinder_top.endShape(CLOSE);
  cylinder_bottom.endShape(CLOSE);
  cylinder_body.endShape(CLOSE);

  // add to group shape 
  tempShapeGroup.addChild(cylinder_top);
  tempShapeGroup.addChild(cylinder_bottom);
  tempShapeGroup.addChild(cylinder_body);

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
