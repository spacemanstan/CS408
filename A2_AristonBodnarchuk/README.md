# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment Two - LIOM (Linear Interpolation and OBJ Models) Animation System

###### Video Demonstration 
to do...

###### Program Overview
Just getting my readme setup, I have spent too much trying to get obj and mtl files to export and texture properly. 

Very loose rough idea going into this is:
XML handler -> object handler -> animation 

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
 - Custom object based XML animation file syntax that promotes readability
 - Animation compile checking to prevent errors and notify user of missing files
 - Basic lighting!
 - Frame export setting to export animations frame by frame
 - Sound?
 - More, gotta read what the requirements even are lol
 - HSB colors
 - Color interpolation

###### ToDo 
- [ ] Documentation
- [x] Create readme files
- [x] Start menu  // CREATIVE FEATURE
    - [x] Mouse Functionality 
    - [ ] play + load button
    - [ ] export button 
    - [ ] help button
    - [ ] display error messages
- [x] HSB color support // CREATIVE FEATURE
- [x] basic lighting // CREATIVE FEATURE
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
- [ ] Abstract object class and create sub classes for:
    - [x] 3d obj file support
    - [x] 2d image support // CREATIVE FEATURE
    - [x] generate sphere + texture // CREATIVE FEATURE
    - [x] generate cube / box + texture  // CREATIVE FEATURE
- [ ] Create test animations
- [x] Replay Feature
- [ ] Integrate animation and object system with menu system
- [ ] multi threading?
