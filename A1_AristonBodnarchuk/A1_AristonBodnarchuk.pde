float test = 0;

void setup() {
 size(1280,720,P3D); 
}

void draw() {
  background(69);
  
  rectMode(CENTER);
  fill(51);
  stroke(255);
  
  test += 0.01;
  
  translate(mouseX, mouseY, sin(test)*100);
  rotateZ(PI/8*sin(test));
  rotateY(PI/12*cos(test));
  rect(0, 0, 100, 100);
}
