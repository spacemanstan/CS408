# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment Two - LIOM (Linear Interpolation and OBJ Models) Animation System

###### Video Demonstration 
[Short video walkthrough featuring two example animations](https://youtu.be/CdCNN5qxw3Y)

###### Program Overview
The program is a driver for the animation system class. One function in main is used to work around multithreading file selection from the class. Everything is controlled via the menu buttons and the bottom right corner features a help button that can bring up a help screen to give the user some information on how to work with the animation system. Before playing an animation the user must load in an animation xml file with proper syntax. If the syntax is incorrect or the xml does not read properly the animation will throw an error when the user presses play (see error codes below for more information). If the animation file is correct then the user will then see the animation played on screen after pressing play. If the user has selected an export path and enabled the export toggle checkbox the animation will play slower and save images. Animation files can contain more than just obj files. Texture cubes and spheres as well as image files can be loaded into the system with the same rotation, position, and scale keyframes. To start the program just click the play button in the processing environment
Once the program is running you can interact with the menu buttons to achieve desired output. The bottom right of the screen has a help button that is denoted by [?] which toggles a help screen giving a brief overview of program execution.
To play an animation first load an animation xml file (two are provided with the program). One the file is loaded the play button will become enabled, as it is disabled when there is nothing to play. When the user presses play the system will build the animation from the loaded file. If any errors are encountered during this process the program will not play the animation and pop up an error code and error description on the screen. If no errors are found in the animation file then the animation will play, if the user chose an export path and enabled exporting, the animation will play slower and extract every frame of the animation to the selected export folder with an appropriately numbered frame to display. The images can easily be moved into an animation software, which generally has a feature for an image sequence that can automatically create an animation from the images with little user input.


###### XML Syntax
Instead of txt files, my animation system makes use of xml which is a markup language that is both human and machine readable to make the processes of creating animation files significantly easier. Animation objects use the “object” tag to indicate they are an object and use content to provide a location for files or textures; attributes provide the object id, and type, as well as height and width dimensions if the type is “img”. The “keyframe” tag denotes a keyframe for an object and has position, rotatio, and scale self closing children that contain values in attributes. The tag for keyframe contains for which id and for what frame the keyframe occurs.

###### Error Codes
```
     -1 = no frame; 
     -2 = no pos; 
     -3 = no rot; 
     -4 = no scale; 
     -5 = missing width;
     -6 = missing height;
    -42 = type match error;
    -69 = keyframe timing error; 
   -420 = failed to load path for object or image / texture;
   -666 = objectless keyframe error;
   -690 = missing texture error;
```

###### Creative Features
 - XML animation files and syntax
 - XML error checking 
 - Menu system and mouse functionality
 - 3D lighting
 - End screen with replay option 
 - Replay feature
 - Additional object types
 - Image, textured sphere, textured cube
 - HSB / HSL color format support
 - Additional Error checking 


###### ToDo
- [x] Documentation
- [x] Create readme files
- [x] Start menu  // CREATIVE FEATURE
    - [x] Mouse Functionality 
    - [x] play + load button
    - [x] export button 
    - [x] help button
    - [x] display error messages
- [x] HSB color support // CREATIVE FEATURE
- [x] basic lighting // CREATIVE FEATURE
- [x] animation end screen // CREATIVE FEATURE 
- [x] Convert animation file syntaxt to XML syntax // CREATIVE FEATURE
- [x] Design XML reader that can parse and error check
    - [x] no frame error // CREATIVE FEATURE
    - [x] no pos error // CREATIVE FEATURE
    - [x] no rot error // CREATIVE FEATURE
    - [x] no scale error // CREATIVE FEATURE
    - [x] object load error // CREATIVE FEATURE
    - [x] key frame timing error
    - [x] objectless keyframe error
    - [x] object type check // CREATIVE FEATURE
    - [x] image object checks // CREATIVE FEATURE
    - [x] sphere object checks // CREATIVE FEATURE
    - [x] cube / box object checks // CREATIVE FEATURE
    - [x] texture check // CREATIVE FEATURE
    - [x] type match error // CREATIVE FEATURE
- [x] Create object class and keyframe class
- [x] Abstract object class and create sub classes for:
    - [x] 3d obj file support
    - [x] 2d image support // CREATIVE FEATURE
    - [x] generate sphere + texture // CREATIVE FEATURE
    - [x] generate cube / box + texture  // CREATIVE FEATURE
- [x] Create test animations
- [x] Replay Feature
- [x] Integrate animation and object system with menu system
- [x] multi threading? (only partially)
