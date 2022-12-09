# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Assignment 6 - Falling Sand Sim

###### Video Demonstration 
[Video example of a6](https://youtu.be/kLTPhqAAV5I)

###### Creative Features && Description 
  i have an exam tomorrow, this is the best I can do lol
 the particles are just for show and do not interact with the grid lol
 
 the distribute function is a shell of what I wanted
 
 basically if I didnt have an exam tomorrow I would make distribution be random to give more organic structure to the sand piles
 I also would have done a random emitter for particles that did check for grid interaction to add to the grid
 the grid has two functions, add sand, and distribute 
 distribution would be random 
 
 the particle class doesn't need much more, basically it should just map its value to an index with the getIndex function
 then it can use that result to check the sand in that cell, the amount of sand reflecting height
 that way it can see if it has touched the ground with a simple distance check
 it would simply just do what the mouse pressed function is doing
 
 particles always scatter from the center
 sand piles up in a cube radius from the center, pretty simple

###### User Instructions
Just click around and have fun!

**Mouse Controls**
- Click: 
     - Add 50 random bits of sand in a random radius in the center that distributes its way out from the center
- Move Mouse:
     - moving mouse left to right rotates simulaton left to right and vice versa 
