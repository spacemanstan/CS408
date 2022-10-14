# CS408 - Prof. Alain Maubert Crotte

###### **Ariston Bodnarchuk**

## Asignment Two - LIOM (Linear Interpolation and OBJ Models) Animation System

###### Video Demonstration 
to do...

###### Program Overview
Just getting my readme setup, I have spent too much trying to get obj and mtl files to export and texture properly. 

Very loose rough idea going into this is:
XML handler -> object handler -> animation 


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
- [x] Create readme files
- [x] Start menu  // CREATIVE FEATURE
    - [ ] Mouse Functionality 
    - [ ] Keyboard controls (maybe)
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
    - [ ] object type check // CREATIVE FEATURE
    - [ ] image object checks // CREATIVE FEATURE
    - [ ] sphere object checks // CREATIVE FEATURE
    - [ ] cube / box object checks // CREATIVE FEATURE
- [x] Create object class and keyframe class
    - [x] 3d obj file support
    - [ ] 2d image support 
    - [ ] generate sphere 
    - [ ] generate cube / box
- [ ] Create test animations
- [ ] Integrate animation and object system with menu system
- [ ] multi threading?
