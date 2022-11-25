/*
I tried my best to clean this code up and make it more readable but I can only do so much and I am running out of time
 
 If I had more time I would optimize this code and make use of vectors
 I think there is some room to multithread things here aswell but not a lot as part of the process is sequential
 
 mainly I would just want to name a lot of variables to explain exactly what is happening, the work of Ash and Stam is hard
 as all fuck to follow because of how complex the math is with little explanation... also Im dumb haha. 
 
 this code is based almost entirely on the work of Mike Ash, which is based off of the work done by Jos Stam
 Mike Ash's work ---> https://mikeash.com/pyblog/fluid-simulation-for-dummies.html
 Jos Stam's work ---> https://www.dgp.toronto.edu/public_user/stam/reality/Research/pdf/GDC03.pdf
 
 three main functions:
 diffuse, project, advect
 */

class Simulation {
  boolean colorToggle = false;
  boolean fadeToggle = false;
  boolean strokeToggle = false;

  int size;
  float timestep;
  float diffusion;
  float thicc; // viscosity but a funnier name because viscosity basically is just how thick the liquid is anyway 

  float[] density, density_prev;
  float[] velX, velY, velX_prev, velY_prev;

  Simulation(float ts, float spreadRate, float viscosity) {

    this.size = DIM;
    this.timestep = ts;
    this.diffusion = spreadRate;
    this.thicc = viscosity;

    this.density_prev = new float[DIM * DIM];
    this.density = new float[DIM * DIM];
    this.velX = new float[DIM * DIM];
    this.velY = new float[DIM * DIM];
    this.velX_prev = new float[DIM * DIM];
    this.velY_prev = new float[DIM * DIM];
  }

  // main update / run function called in draw
  // named draw_ because it is called in main draw() function and drives the simulation
  void draw_() {
    this.step();
    this.renderD();

    if (fadeToggle) 
      this.fadeD();
  }

  void toggleColorMode() {
    this.colorToggle = !this.colorToggle;
  }

  void toggleFade() {
    this.fadeToggle = !this.fadeToggle;
  }

  void toggleStroke() {
    this.strokeToggle = !this.strokeToggle;
  }

  int getIndex(int x, int y) {
    x = constrain(x, 0, DIM - 1);
    y = constrain(y, 0, DIM - 1);
    return x + (y * DIM);
  }

  void step() {
    // diffuse velocities based on time step, viscotsity, x, and y
    diffuse(1, this.velX_prev, this.velX, this.thicc, this.timestep);
    diffuse(2, this.velY_prev, this.velY, this.thicc, this.timestep);

    // clean up velcoities
    project(this.velX_prev, this.velY_prev, this.velX, this.velY);

    // run advection on velcoities
    advect(1, this.velX, this.velX_prev, this.velX_prev, this.velY_prev, this.timestep);
    advect(2, this.velY, this.velY_prev, this.velX_prev, this.velY_prev, this.timestep);

    // clean up
    project(this.velX, this.velY, this.velX_prev, this.velY_prev);

    // diffuse and advect density or dye
    diffuse(0, this.density_prev, this.density, this.diffusion, this.timestep);
    advect(0, this.density, this.density_prev, this.velX, this.velY, this.timestep);
  }

  // add velocity to a specified index based on x and y coordinates 
  void addVelocity(int x, int y, float amountX, float amountY) {
    int index = getIndex(x, y);
    this.velX[index] += amountX;
    this.velY[index] += amountY;
  }

  /*
    This acts like it is adding density but really it is just adding dye to our cells
   because density and velocity are kind of invisible dye allows a visualization
   */
  void addDyeDensity(int x, int y, float amount) {
    int index = getIndex(x, y);
    this.density[index] += amount;
  }

  /*
    remove dye from a given cell as well as it's 4 adjacent cells (up, down, left, right)
  */
  void removeDyeDensity(int x, int y, float amount) {
    int index = getIndex(x, y);
    if (this.density[index] > 0)
      this.density[index] -= amount;

    // adjacent right
    index = getIndex(x + 1, y);
    if (this.density[index] > 0)
      this.density[index] -= amount;

    // adjacent left
    index = getIndex(x - 1, y);
    if (this.density[index] > 0)
      this.density[index] -= amount;

    // adjacent down
    index = getIndex(x, y + 1);
    if (this.density[index] > 0)
      this.density[index] -= amount;

    // adjacent up
    index = getIndex(x, y - 1);
    if (this.density[index] > 0)
      this.density[index] -= amount;
  }

  void renderD() {
    if (colorToggle)
      colorMode(HSB, 255);

    for (int i = 0; i < DIM; ++i) {
      for (int j = 0; j < DIM; ++j) {
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[getIndex(i, j)];

        // handle colouring the cell
        if (colorToggle)
          fill( (d + 50) % 176, 88, d );
        else
          fill(d);

        // old experimental fill mode that makes the screen a rainbow gradient 
        //fill( map(getIndex(i, j), 0, DIM * DIM, 0, 255), 69, d );

        // show grid 
        if (strokeToggle)
          stroke(0);
        else
          noStroke();

        // actually draw the cell now that we got everything 
        square(x, y, SCALE);
      }
    }
  }

  void fadeD() {
    for (int i = 0; i < this.density.length; ++i) {
      float d = density[i];
      density[i] = constrain(d - 0.75, 0, 255);
    }
  }

  void diffuse (int xyDir, float[] x, float[] x0, float diff, float dt) {
    float a = dt * diff * (DIM - 2) * (DIM - 2);
    lin_solve(xyDir, x, x0, a, 1 + 6 * a);
  }

  /*
   distribution to all surrounding cells
   iterations decides how many times to run through all of a cells neighbors to spread the love
   more iterations = more calcs = worse performance but I saw little difference in my tests for high iterations
   
   this funciton is mostly black magic however 
   */
  void lin_solve(int xyDir, float[] x, float[] x0, float a, float c) {
    float cRecip = 1.0 / c;
    for (int k = 0; k < iterations; k++) {
      for (int j = 1; j < DIM - 1; ++j) {
        for (int i = 1; i < DIM - 1; ++i) {
          x[getIndex(i, j)] =
            (x0[getIndex(i, j)]
            + a*(    x[getIndex(i+1, j)]
            +x[getIndex(i-1, j)]
            +x[getIndex(i, j+1)]
            +x[getIndex(i, j-1)]
            )) * cRecip;
        }
      }

      setBounds(xyDir, x);
    }
  }

  // amount of stuff going in = amount of stuff going out of cell
  void project(float[] velX, float[] velY, float[] p, float[] div) {
    for (int j = 1; j < DIM - 1; ++j) {
      for (int i = 1; i < DIM - 1; ++i) {
        div[getIndex(i, j)] = -0.5f*(
          velX[getIndex(i+1, j)]
          -velX[getIndex(i-1, j)]
          +velY[getIndex(i, j+1)]
          -velY[getIndex(i, j-1)]
          ) / DIM;
        p[getIndex(i, j)] = 0;
      }
    }

    setBounds(0, div); 
    setBounds(0, p);
    lin_solve(0, p, div, 1, 6);

    for (int j = 1; j < DIM - 1; ++j) {
      for (int i = 1; i < DIM - 1; ++i) {
        velX[getIndex(i, j)] -= 0.5f * (  p[getIndex(i+1, j)]
          -p[getIndex(i-1, j)]) * DIM;
        velY[getIndex(i, j)] -= 0.5f * (  p[getIndex(i, j+1)]
          -p[getIndex(i, j-1)]) * DIM;
      }
    }

    setBounds(1, velX);
    setBounds(2, velY);
  }

  // actually move stuff around
  void advect(int xyDir, float[] dens, float[] dens_p, float[] velX, float[] velY, float timestep) {
    float i0, i1, j0, j1;

    float tsX = timestep * (DIM - 2);
    float tsY = timestep * (DIM - 2);

    float s0, s1, t0, t1;
    float tmp1, tmp2, x, y;

    float Nfloat = DIM;
    float ifloat, jfloat;
    int i, j;

    for (j = 1, jfloat = 1; j < DIM - 1; ++j, ++jfloat) { 
      for (i = 1, ifloat = 1; i < DIM - 1; ++i, ++ifloat) {
        tmp1 = tsX * velX[getIndex(i, j)];
        tmp2 = tsY * velY[getIndex(i, j)];
        x    = ifloat - tmp1; 
        y    = jfloat - tmp2;

        if (x < 0.5f) x = 0.5f; 
        if (x > Nfloat + 0.5f) x = Nfloat + 0.5f; 
        i0 = floor(x); // maybe unecessary 
        i1 = i0 + 1.0f;
        if (y < 0.5f) y = 0.5f; 
        if (y > Nfloat + 0.5f) y = Nfloat + 0.5f; 
        j0 = floor(y); // maybe unecessary
        j1 = j0 + 1.0f; 

        s1 = x - i0; 
        s0 = 1.0f - s1; 
        t1 = y - j0; 
        t0 = 1.0f - t1;

        int i0i = int(i0);
        int i1i = int(i1);
        int j0i = int(j0);
        int j1i = int(j1);

        dens[getIndex(i, j)] = 
          s0 * (t0 * dens_p[getIndex(i0i, j0i)] + t1 * dens_p[getIndex(i0i, j1i)]) 
          + s1 * (t0 * dens_p[getIndex(i1i, j0i)] + t1 * dens_p[getIndex(i1i, j1i)]);
      }
    }

    setBounds(xyDir, dens);
  }


  /*
   velocities going towards walls get a counter velocity to push back in equal amount
   keeps the system closed
   just reverse velocity in edge rows/columns to keep shit contained
   
   xyDir is telling the function which array we are dealing with, if I had more time
   I would use pvectors to sort this out implcitly and save a variable
   */
  void setBounds(int xyDir, float[] x) {
    for (int i = 1; i < DIM - 1; ++i) {
      x[getIndex(i, 0  )] = xyDir == 2 ? -x[getIndex(i, 1  )] : x[getIndex(i, 1 )];
      x[getIndex(i, DIM - 1)] = xyDir == 2 ? -x[getIndex(i, DIM - 2)] : x[getIndex(i, DIM - 2)];
    }
    for (int j = 1; j < DIM - 1; ++j) {
      x[getIndex(0, j)] = xyDir == 1 ? -x[getIndex(1, j)] : x[getIndex(1, j)];
      x[getIndex(DIM - 1, j)] = xyDir == 1 ? -x[getIndex(DIM - 2, j)] : x[getIndex(DIM - 2, j)];
    }

    x[getIndex(0, 0)] = 0.5f * (x[getIndex(1, 0)] + x[getIndex(0, 1)]);
    x[getIndex(0, DIM - 1)] = 0.5f * (x[getIndex(1, DIM - 1)] + x[getIndex(0, DIM - 2)]);
    x[getIndex(DIM - 1, 0)] = 0.5f * (x[getIndex(DIM - 2, 0)] + x[getIndex(DIM - 1, 1)]);
    x[getIndex(DIM - 1, DIM - 1)] = 0.5f * (x[getIndex(DIM - 2, DIM - 1)] + x[getIndex(DIM - 1, DIM - 2)]);
  }
}
