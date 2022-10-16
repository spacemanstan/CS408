/*
  CS408 - Alain Maubert Crotte
   Assignment 2: Linear interpolation 3d animation system
   
   Name: Ariston Bodnarchuk
   Id:   200285478
   
   Description
   ==================================
   The animation system is able to read in an xml file and parse the file into two types of object
   the first is an animation object of type: obj, img, cube, and sphere
   obj loads a .obj file for the model to display
   img loads a picture for the image to display
   cube and sphere load a texture file and apply it to a generated 3d primative shape
   The system converts the xml parse into objects, and then stores all asociated key frames into an 
   array list for each object. During animation it is checked if the current frame is a keyframe, if 
   it is a keyframe then assign the keyframe values, if not interpolate towards the next key frame.
   
   Animations are loaded via the load button that opens a multithreaded system window for file selection
   Export folder is chosen in an identical processes
   Export has a companion check box to quickly enable and disable after a folder is selected
   
   there is no way to stop an animation that is playing
   
   Creative Features
   ==================================
     Mouse functions
     - click buttons
     - right click to clear loaded info
     Help Screen
     Fully functioning menu with background graphics
     XML animation file and syntax with error checking
     basic lighting 
     hsb color support 
     support for images and primative 3d types with texturing
     abstract object class to allow subclassing 
     replay animation feature
     export option with export folder selection
     multi threaded file selection
     error code system with error code display on menu
     blender created 3d models
     custom made photoshop textures and images (helpscreen)
     
     Citations
     ==================================
     Everything featured is created completely by me with the exception of some texture,
     some textures for 3d models were sourced from 
     http://paulbourke.net/texturelibrary/
 */

final int FPS = 60;

// liom = linear interpolation & object models
AnimationSystem liom;

public void setup() {
  size(1280, 720, P3D); // "720p HD" window resolution 
  colorMode(HSB, 360, 100, 100);
  
  surface.setTitle("LIOM Animation System"); // name the window better

  // set framerate
  frameRate(FPS);

  // setup animation system
  liom = new AnimationSystem();
}

public void draw() {
  liom.run();
}

void mouseReleased() { 
  liom.mouseEvent();
}

void selectionHandler(File select) {
  liom.btnSelectionHandler(select);
}
