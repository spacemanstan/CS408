# CS408 - Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment One - Projectile System 

###### Dynamic Shapes
To make the projectiles have changeable shapes I want to generate custom 3d objects with processing based on the criteria provided in the assignment.
Based on the description we essentially have 4 pyramids forming a cube where the point of the pyramid can be moved to change the overall shape, with the corners of the cube being static. To achieve this I am creating a custon processing PObject for the particle that can be chosen based on the shape perameters. Rather than wasting resources drawing the vertices each time I will create an array of all the available custom shapes that can be drawn ahead of time on program load which should increase performance. Then based on the amount the user increments (or decrements) the shape modifier, the program can just select the appropriate shape. 

###### Checklist 
- [x] Dynamic 3D object creation of all possible shapes on program load
- [ ] Projectile class using dynamic object creation
- [ ] ProjectileSystem class that uses an array list to track and remove dead particles
- [ ] Tweak click and drag mouse rotation to feel more natural *(not so jumpy)*
