# CS408 - Prof. Alain Maubert Crotte #

### Video Demo ###
[Video Showcase of Animation]()

## Description ##
My function for calculating a point on a B-Spline is adopted from a javascript library that handles B-Spline calculations given a vector of control points, knots, and weights. I completed this before the assignment due date was extended and before we were given the B-Spline function lecture notes. I have included the citations down below. I modified and refactored the library's function heavily, reducing its size and increasing the efficiency slightly. The new algorithm  is specifically tailored to cubic B-Splines as it is intended just for this assignment. My work for sinusoidal easing and parabolic easing was based on the class's textbook which covers how to implement such easing. My answer to question 1, the animation algorithm, can be found in the same zip folder this source code is in, named "a3_q1.pdf". The curve is displayed 3 times at an offset and each of the different easing methods are shown at once, one a loop is completed the aniations reset and the camera angle changes by 45 degrees showcasing the 3d effect. Since we were forced to do this in 3d I found it a shame not to use it in any way, even if a creative feature is not a requirement. This assignment was probably the hardest so far because of the math. My  new B-Spline function also drastically improves the readability of the source code it was based upon when looking into De Boor's algorithm.
User Guide

There is no user interaction with the program, it just loops the 3 types of easing infinitely while, Each reset goes between a straight on camera angle, or an angle of 45 degrees, then bounces back.

## Creative Feature ##
On each loop of the animation the camera rotates slightly to show off the 3d environment.

###### ToDo
- [x] Quesion 1
- [x] Uniform Cubic B-Spline
     - [x] draw control points in black
     - [x] draw curve
     - [x] repeat 3 times and show all easing at once // CREATIVE FEATURE
- [x] Sinusoidal Ease-in / Ease-out
- [x] Parabolic Ease-in / Ease-out
- [x] Documentation
- [x] Demo Video
- [x] Camera Rotation // CREATIVE FEATURE

## Citations ##
###### (using APA - 7th edition)

BSpline library referenced:
https://github.com/thibauts/b-spline 
 
Textbook used for Sinusoidal Ease-in / Ease-out & Parabolic Ease-in / Ease-out:
Parent, R. (2012). Computer Animation: Algorithms and Techniques (3rd ed.). Morgan Kaufmann.
 
De Boor's Algorithm:
Wikimedia Foundation. (2022, February 22). De Boor's algorithm. Wikipedia. https://en.wikipedia.org/wiki/De_Boor%27s_algorithm 
