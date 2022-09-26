# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment One - Projectile System 

###### Program Overview
My main function (Draw) acts as a driver for the particle system calling the display function for it, which nested inside is the particle sytem update function. Particles are immutable and are tracked by an array list, the list is itterated through in reverse to prevent logical errors and simplify programming. Particles track all relevant information to their specific instance of a particle where the particle system tracks the information for what the next added particle should have for intial parameters. 

###### Dynamic Shapes
To save rendering efforts instead of drawing custom shapes each time I draw to screen my particle system class renders every possible shape ahead of time by creating 6 pyramid faces from 4 polygons that vary based on the shape modifier to push the pyramid point in or out of the cube. When particles are created they are passed one of the pre generated shapes instead of having to handle drawing the custom shapes themselves. This is a pretty common optimizating in processing as processing has a PShape class designed around this.

###### Performance
Performance was tested by seeing how many particles it took to drop FPS by half (30 FPS)

Testing on my laptop showed that plugged in I can support 2100 - 2500 particles, where unplugged was 500 - 600 particles

My conclusion and assumption from this test is that older systems won't support many particles; however moderate to powerful systems should handle a extremely large amount of particles at a time. 

The program itself (through the particle system) first checks that the framerate (FPS) is high enough (>=30) to add more particles, which is then determined by the spawnrate variable the user can control via the '<' and '>' keys. 

###### Creative Features
 - Help menu screen on launch that doubles as a pause feature 
 - Performance based particle spawning
 - Control particle spawn rate
 - 3D particle system over 2D
 - On-screen buttons displaying values
    - buttons for RGB match RGB values unless set to random (prevent epilepsy) 
 - Mouse Functionality
    - Left click buttons to increment / decrement
    - Right click buttons to toggle random mode 
    - Right click and drag screen to rotate camera
    - Scroll wheel to zoom in / zoom out camera
 - Different particle constructors
    - Random angle + speed gives random depth
    - all random uses a specialized random constructor (that feels better)
 - Particle count + performance tracker outputed in program console
 - Particles have randomized spin in a direction
 - Particles have air friction
 - Particles have gravity based on size

###### Checklist 
- [x] ~~Dynamic 3D object creation of all possible shapes on program load~~
- [x] ~~Mouse Functions~~
* ~~Left click - Interact with menu items~~
* ~~Right click - rotate perspective~~
* ~~Scroll - zoom in / zoom out~~
- [x] ~~Keyboards Functions~~
* ~~emit speed +/- | +< ->~~
* ~~Red amount +/- | +R -R~~
* ~~Green Colour +/- | +g -g~~
* ~~Blu colour +/- | +B -b~~
* ~~Opacity +/- | +T -t or +O -o~~
* ~~Size +/- | ++ --~~
* ~~Emiter Pos (origin) +/- x/y/z | x/y axis wasd; z axis q/e; screen edges~~
* ~~Particle Speed +/- | +up (arrow) -down (arrow); 0px/frame - 10px/frame~~
* ~~Particle Emit Angle +/- y rotation | +left (arrow) -right (arrow)~~
* ~~Shape (array choice) +/- | +H -h; 0.5 - 3.0~~
* Toggle Help | ? or / key
- [x] ~~Projectile class using dynamic object creation~~
- [x] ~~ProjectileSystem class that uses an array list to track and remove dead particles~~
- [x] ~~Tweak click and drag mouse rotation to feel more natural *(not so jumpy)*~~
- [x] ~~Button class for on screen clickable companions to mouse features~~
