/*
three main functions:
 diffuse, project, advect
 */

class Simulation {
  boolean colorToggle = false;
  boolean fadeToggle = false;

  int size;
  float dt;
  float diff;
  float visc;

  float[] s;
  float[] density;

  float[] Vx;
  float[] Vy;

  float[] Vx0;
  float[] Vy0;

  Simulation(float dt, float diffusion, float viscosity) {

    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;

    this.s = new float[N*N];
    this.density = new float[N*N];

    this.Vx = new float[N*N];
    this.Vy = new float[N*N];

    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
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

  void toggleColorFadeMode() {
    this.fadeToggle = !this.fadeToggle;
  }

  int getIndex(int x, int y) {
    x = constrain(x, 0, N-1);
    y = constrain(y, 0, N-1);
    return x + (y * N);
  }

  void step() {
    int N          = this.size;
    float visc     = this.visc;
    float diff     = this.diff;
    float dt       = this.dt;
    float[] Vx      = this.Vx;
    float[] Vy      = this.Vy;
    float[] Vx0     = this.Vx0;
    float[] Vy0     = this.Vy0;
    float[] s       = this.s;
    float[] density = this.density;

    // diffuse velocities based on time step, viscotsity, x, and y
    diffuse(1, Vx0, Vx, visc, dt);
    diffuse(2, Vy0, Vy, visc, dt);

    // clean up velcoities
    project(Vx0, Vy0, Vx, Vy);

    // run advection on velcoities
    advect(1, Vx, Vx0, Vx0, Vy0, dt);
    advect(2, Vy, Vy0, Vx0, Vy0, dt);

    // clean up
    project(Vx, Vy, Vx0, Vy0);

    // diffuse and advect density or dye
    diffuse(0, s, density, diff, dt);
    advect(0, density, s, Vx, Vy, dt);
  }

  void addDensity(int x, int y, float amount) {
    int index = getIndex(x, y);
    this.density[index] += amount;
  }

  void addVelocity(int x, int y, float amountX, float amountY) {
    int index = getIndex(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }

  void removeDensity(int x, int y, float amount) {
    int index = getIndex(x, y);
    if (this.density[index] > 0)
      this.density[index] -= amount;

    index = getIndex(x + 1, y);
    if (this.density[index] > 0)
      this.density[index] -= amount;
    index = getIndex(x - 1, y);
    if (this.density[index] > 0)
      this.density[index] -= amount;
    index = getIndex(x, y + 1);
    if (this.density[index] > 0)
      this.density[index] -= amount;
    index = getIndex(x, y - 1);
    if (this.density[index] > 0)
      this.density[index] -= amount;
  }

  void renderD() {
    if (colorToggle)
      colorMode(HSB, 255);

    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[getIndex(i, j)];
        //fill((d + 50) % 255,200,d);
        //fill( map(getIndex(i, j), 0, N*N, 0, 255), 69, d );

        if (colorToggle)
          fill( (d + 50) % 176, 88, d );
        else
          fill(d);

        noStroke();
        square(x, y, SCALE);
      }
    }
  }

  void fadeD() {
    for (int i = 0; i < this.density.length; i++) {
      float d = density[i];
      density[i] = constrain(d - 0.75, 0, 255);
    }
  }

  void diffuse (int b, float[] x, float[] x0, float diff, float dt) {
    float a = dt * diff * (N - 2) * (N - 2);
    lin_solve(b, x, x0, a, 1 + 6 * a);
  }

  // distribution to all surrounding cells
  void lin_solve(int b, float[] x, float[] x0, float a, float c) {
    float cRecip = 1.0 / c;
    for (int k = 0; k < iter; k++) {
      for (int j = 1; j < N - 1; j++) {
        for (int i = 1; i < N - 1; i++) {
          x[getIndex(i, j)] =
            (x0[getIndex(i, j)]
            + a*(    x[getIndex(i+1, j)]
            +x[getIndex(i-1, j)]
            +x[getIndex(i, j+1)]
            +x[getIndex(i, j-1)]
            )) * cRecip;
        }
      }

      set_bnd(b, x);
    }
  }

  // amount of stuff going in = amount of stuff going out of cell
  void project(float[] velocX, float[] velocY, float[] p, float[] div) {
    for (int j = 1; j < N - 1; j++) {
      for (int i = 1; i < N - 1; i++) {
        div[getIndex(i, j)] = -0.5f*(
          velocX[getIndex(i+1, j)]
          -velocX[getIndex(i-1, j)]
          +velocY[getIndex(i, j+1)]
          -velocY[getIndex(i, j-1)]
          )/N;
        p[getIndex(i, j)] = 0;
      }
    }

    set_bnd(0, div); 
    set_bnd(0, p);
    lin_solve(0, p, div, 1, 6);

    for (int j = 1; j < N - 1; j++) {
      for (int i = 1; i < N - 1; i++) {
        velocX[getIndex(i, j)] -= 0.5f * (  p[getIndex(i+1, j)]
          -p[getIndex(i-1, j)]) * N;
        velocY[getIndex(i, j)] -= 0.5f * (  p[getIndex(i, j+1)]
          -p[getIndex(i, j-1)]) * N;
      }
    }

    set_bnd(1, velocX);
    set_bnd(2, velocY);
  }

  // actually move stuff around
  void advect(int b, float[] d, float[] d0, float[] velocX, float[] velocY, float dt) {
    float i0, i1, j0, j1;

    float dtx = dt * (N - 2);
    float dty = dt * (N - 2);

    // s is density probably
    float s0, s1, t0, t1;
    float tmp1, tmp2, x, y;

    float Nfloat = N;
    float ifloat, jfloat;
    int i, j;

    for (j = 1, jfloat = 1; j < N - 1; j++, jfloat++) { 
      for (i = 1, ifloat = 1; i < N - 1; i++, ifloat++) {
        tmp1 = dtx * velocX[getIndex(i, j)];
        tmp2 = dty * velocY[getIndex(i, j)];
        x    = ifloat - tmp1; 
        y    = jfloat - tmp2;

        if (x < 0.5f) x = 0.5f; 
        if (x > Nfloat + 0.5f) x = Nfloat + 0.5f; 
        i0 = floor(x); // maybe unecessary 
        i1 = i0 + 1.0f; // append f to prevent autoboxing to double
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

        d[getIndex(i, j)] = 
          s0 * (t0 * d0[getIndex(i0i, j0i)] + t1 * d0[getIndex(i0i, j1i)]) +
          s1 * (t0 * d0[getIndex(i1i, j0i)] + t1 * d0[getIndex(i1i, j1i)]);
      }
    }

    set_bnd(b, d);
  }


  // velocities going towards walls get a counter velocity to push back in equal amount
  // keeps the system closed
  // just reverse velocity in edge rows/columns to keep shit contained
  void set_bnd(int b, float[] x) {
    for (int i = 1; i < N - 1; i++) {
      x[getIndex(i, 0  )] = b == 2 ? -x[getIndex(i, 1  )] : x[getIndex(i, 1 )];
      x[getIndex(i, N-1)] = b == 2 ? -x[getIndex(i, N-2)] : x[getIndex(i, N-2)];
    }
    for (int j = 1; j < N - 1; j++) {
      x[getIndex(0, j)] = b == 1 ? -x[getIndex(1, j)] : x[getIndex(1, j)];
      x[getIndex(N-1, j)] = b == 1 ? -x[getIndex(N-2, j)] : x[getIndex(N-2, j)];
    }

    x[getIndex(0, 0)] = 0.5f * (x[getIndex(1, 0)] + x[getIndex(0, 1)]);
    x[getIndex(0, N-1)] = 0.5f * (x[getIndex(1, N-1)] + x[getIndex(0, N-2)]);
    x[getIndex(N-1, 0)] = 0.5f * (x[getIndex(N-2, 0)] + x[getIndex(N-1, 1)]);
    x[getIndex(N-1, N-1)] = 0.5f * (x[getIndex(N-2, N-1)] + x[getIndex(N-1, N-2)]);
  }
}
