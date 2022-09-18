class ParticleSystem {
  int red, green, blue, opacity, size, shapeParam, cubeRange_s = 5, cubeRange_e = 30;
  float shapeSize = 50;
  PVector pos, startVel;
  PShape PCube[];

  ArrayList<Particle> particles = new ArrayList<Particle>();

  ParticleSystem() {  
    PCube = new PShape[cubeRange_e - cubeRange_s + 1];
    renderPCubeShapes();

    //addParticle();
  }

  void display() {
    pushMatrix();
    translate(width/2, height/2, -500);

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);

      p.display();

      if (p.deceased) {
        particles.remove(i);
        if(round(frameRate) >= 30) addParticle();
      }
    }

    popMatrix();
    
    this.update();
  }

  void update() {
    if(round(frameRate) >= 30) addParticle();
    //if(frameCount % FPS == 0) addParticle();
  }

  void addParticle() {
    //particles.add(new Particle(red, green, blue, opacity, size, shapeParam, startVel));
    particles.add(new Particle( PCube[ (int)random(0, PCube.length) ] ) );
  }

  /*
    renderPCubeShapes
   ==================================
   fills array of every possible PShape
   
   saves processing time by calculating all shapes first
   */
  void renderPCubeShapes() {
    float shapeMod;

    for (int i = cubeRange_s; i <= cubeRange_e; ++i) {
      shapeMod = i / 10.0;
      createPCube(i - cubeRange_s, shapeMod);
    }
  }

  /*
    createPCube
   ====================
   makes a cube of 6 sides 
   */
  void createPCube(int index, float sMod) {
    // l = left, r = right, u = up, d= down, f =front, b = back
    PVector luf = new PVector(-1, -1, 1);
    PVector ruf = new PVector( 1, -1, 1);
    PVector lub = new PVector(-1, -1, -1);
    PVector rub = new PVector( 1, -1, -1);
    PVector ldf = new PVector(-1, 1, 1);
    PVector rdf = new PVector( 1, 1, 1);
    PVector ldb = new PVector(-1, 1, -1);
    PVector rdb = new PVector( 1, 1, -1);

    PShape top, bottom, front, back, left, right;

    // top
    top = createShape();
    createFace(top, luf, lub, rub, ruf, sMod);
    // bottom
    bottom = createShape();
    createFace(bottom, ldf, ldb, rdb, rdf, sMod);
    // left
    left = createShape();
    createFace(left, luf, lub, ldb, ldf, sMod);
    // right
    right = createShape();
    createFace(right, ruf, rub, rdb, rdf, sMod);
    // front
    front = createShape();
    createFace(front, luf, ruf, rdf, ldf, sMod);
    // back
    back = createShape();
    createFace(back, lub, rub, rdb, ldb, sMod);

    PCube[index] = createShape(GROUP);
    PCube[index].addChild(top);
    PCube[index].addChild(bottom);
    PCube[index].addChild(left);
    PCube[index].addChild(right);
    PCube[index].addChild(front);
    PCube[index].addChild(back);

    // clear support shapes
    // idk if this will actually improve memory but it is worth a shot 
    top = null;
    bottom = null;
    left = null;
    right = null;
    front = null;
    back = null;
  }

  /*
    createFace
   ====================
   utility function for create createPCube
   */
  void createFace(PShape face, PVector c0, PVector c1, PVector c2, PVector c3, float shapeMod) {
    PVector center = new PVector(c0.x + c1.x + c2.x + c3.x, c0.y + c1.y + c2.y + c3.y, c0.z + c1.z + c2.z + c3.z);
    center.div(4);
    if (center.x != 0) center.x *= shapeMod;
    if (center.y != 0) center.y *= shapeMod;
    if (center.z != 0) center.z *= shapeMod;

    face.beginShape(TRIANGLES); // necessary
    face.vertex(center.x, center.y, center.z);
    face.vertex(c0.x, c0.y, c0.z);
    face.vertex(c1.x, c1.y, c1.z);

    face.vertex(center.x, center.y, center.z);
    face.vertex(c1.x, c1.y, c1.z);
    face.vertex(c2.x, c2.y, c2.z);

    face.vertex(center.x, center.y, center.z);
    face.vertex(c2.x, c2.y, c2.z);
    face.vertex(c3.x, c3.y, c3.z);

    face.vertex(center.x, center.y, center.z);
    face.vertex(c3.x, c3.y, c3.z);
    face.vertex(c0.x, c0.y, c0.z);
    face.endShape();
  }
}
