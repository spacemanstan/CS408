# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment Four - Hierarchical Kinematic Models & Animation System

###### Video Demonstration 
[Video example of all a4 functional requirements]([https://youtu.be/CdCNN5qxw3Y](https://youtu.be/dbLGH2d-nWs))

###### Program Overview
My model is built out of composite objects used to form a tree structure that holds a model, and all relevant positioning information as well as an array of children consisting of further composite objects. The model is displayed using the tree structure. By performing a depth first search I am able to stack transformations to play objects relevant to one another rather than relevant to the world. This model is then stored in a class called Boi as root, and global position on the screen as well as rotation are stored. This Boi class also handles setting positions, interpolating, or calculating dynamic dance animations as well as handling different global rotation modes. The main draw function acts as a driver for the boi class, which handles everything for the model. The mouse is used to interact with the instance of the boi class named Doug. 

An array of pose vector data types holds the data for the different poses used by the Boi class.

Rather than use keybindings I used mouse input instead as there are few controls needed and keyboard controls are annoying in my opinion. The mouse controls allow a quicker and easier way of checking all functionality works. 


###### User Instructions
Left Mouse Click	= 	Change Pose
Right Mouse Click	= 	Change Pose Mode (interpolate, set, vibe)
Interpolate ⇒ linearly interpolate to next pose on mouse click 
Set ⇒ assign to next pose on mouse click
Vibe ⇒ do a walk arm wave dance thing with dynamic animation
Middle Mouse Click	= 	Change Rotation Mode (face forward, circle spin, crazy spin)
Face Forward ⇒ No rotation, look straight / forward
Circle Spin ⇒ Spin in a circle slowly 
Crazy Spin ⇒ Spin in all directions simultaneously
Creative Features

Replaced crappy keybind with simple mouse button system
Rotation Modes
Pose modes
See User Instructions for more info 
Sweet color shifting background 
Is is very cool 
Individual random part texturing
Texture generation (for eyes)
Dance walk dynamic animation mode
Functionality to change root
Cone shapes
Additional limbs
Hands
Eyes
Feet
Pupils
Segmented torso
Sweet custom pshape cylinder generation function
Generates uv map at same time as cylinder
Main figure is named Doug
Extra lil wood buddy guy beside main figure (Doug)
He is also very cool 
