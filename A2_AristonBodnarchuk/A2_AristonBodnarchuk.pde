// just getting some stuff down to start
// I need to think about the logic and animations I want to do for the animations 
// I want to use xml and a better object based structure to create animations on an object level which would make animation much more human readable

// just a test to load an obj
PShape test;

PVector angs = new PVector(0, 0, 0);
  
public void setup() {
  size(1280, 720, P3D);
    
  test = loadShape("untitled.obj");
}

public void draw() {
  background(0);
  lights();
  
  translate(mouseX, mouseY, 0);
  
  //rotateX(angs.x);
  //rotateZ(angs.y);
  //rotateY(angs.z);
  //box(1);
  shape(test);
  //scale(100);
  
  
  angs.x += 0.02;
}
