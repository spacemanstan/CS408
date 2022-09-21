# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment One - Projectile System 

###### Dynamic Shapes
To make the projectiles have changeable shapes I want to generate custom 3d objects with processing based on the criteria provided in the assignment.
Based on the description we essentially have 4 pyramids forming a cube where the point of the pyramid can be moved to change the overall shape, with the corners of the cube being static. To achieve this I am creating a custon processing PObject for the particle that can be chosen based on the shape perameters. Rather than wasting resources drawing the vertices each time I will create an array of all the available custom shapes that can be drawn ahead of time on program load which should increase performance. Then based on the amount the user increments (or decrements) the shape modifier, the program can just select the appropriate shape. 

###### Performance
Performance was tested by seeing how many particles it took to drop FPS by half (30 FPS)

Testing on my laptop showed that plugged in I can support 2100 - 2500 particles, where unplugged was 500 - 600 particles

My conclusion and assumption from this test is that older systems won't support many particles; however moderate to powerful systems should handle a extremely large amount of particles at a time. 

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
