final int FPS = 30;

int count = 0;
float noiseInc = 0.02;
PVector ang = new PVector(0, 0, 0), bgNoise = new PVector(0, 0);

PGraphics test;

void setup() {
  size(1280, 720, P3D);
  colorMode(360, 100, 100, 100, HSB);
  frameRate(FPS);

  //test = createGraphics(width * 2, height * 2, P2D);
  //test.colorMode(360, 100, 100, 100, HSB);
  //test.beginDraw();
  //test.loadPixels();
  //for (int px = 0; px < test.width; ++px) {
  //bgNoise.x += noiseInc;
  
  //  for (int py = 0; py < test.height; ++py) {
  //    bgNoise.y += noiseInc;
      
  //    pixels[px + py * test.width] = color(noise(bgNoise.x, bgNoise.y) * 255);
  //  }
  //}
  //test.updatePixels();
  //test.endDraw();
}

float fml = 0;

void draw() {
  background(fml); // nice

  translate(width/2, height/2);
  rotateX(ang.x);
  rotateY(ang.y);
  rotateZ(ang.z);

  drawCylinder( 12, 75, 100, 200);

  if (frameCount > FPS) {
    count = count > 2 ? 0 : count + 1;

    if (count == 0) {
      ang.x += degrees(frameCount % 360);
      fml = random(0, 360);
    }
    if (count == 1)
      ang.y += degrees(frameCount % 360);
    if (count == 2)
      rotateY( degrees(frameCount % 360) );
    ang.z += degrees(frameCount % 360);
  }
  
  frameCount = 0;
}

void drawCylinder( int sides, float r1, float r2, float h)
{
  float angle = 360 / sides;
  float halfHeight = h / 2;
  // top
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r1;
    float y = sin( radians( i * angle ) ) * r1;
    vertex( x, y, -halfHeight);
  }
  endShape(CLOSE);
  // bottom
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r2;
    float y = sin( radians( i * angle ) ) * r2;
    vertex( x, y, halfHeight);
  }
  endShape(CLOSE);
  // draw body
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x1 = cos( radians( i * angle ) ) * r1;
    float y1 = sin( radians( i * angle ) ) * r1;
    float x2 = cos( radians( i * angle ) ) * r2;
    float y2 = sin( radians( i * angle ) ) * r2;
    vertex( x1, y1, -halfHeight);
    vertex( x2, y2, halfHeight);
  }
  endShape(CLOSE);
}
