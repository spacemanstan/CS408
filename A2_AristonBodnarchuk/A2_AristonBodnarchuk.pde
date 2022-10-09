// just getting some stuff down to start
// I need to think about the logic and animations I want to do for the animations 
// I want to use xml and a better object based structure to create animations on an object level which would make animation much more human readable

// just a test to load an obj
PShape marvin, payer, textureTest;

PVector angs = new PVector(PI, 0, PI);
  
public void setup() {
  size(1280, 720, P3D);
    
  marvin = loadShape("marvin.obj");
  marvin.scale(100);
  
  textureTest = loadShape("C:/Users/arist/Documents/Blender/newscene/newscene.obj");
  textureTest.scale(1);
  
  payer = loadShape("payer.obj");
  payer.scale(100);
}

public void draw() {
  background(69);
  lights();
  
  pushMatrix();
  translate(width/3, height/2 + marvin.getHeight()/2, 100);
  rotateY(angs.y += 0.05);
  rotateZ(angs.z);

  shape(marvin);
  popMatrix();
  
  pushMatrix();
  translate(width*2/3, height/2 + textureTest.getHeight()/2, 100);
  rotateY(angs.x -= 0.05);
  rotateZ(angs.z);

  shape(textureTest);
  popMatrix();
}
