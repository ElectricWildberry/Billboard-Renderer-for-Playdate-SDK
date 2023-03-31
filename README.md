# Billboard 3D Renderer Package for Playdate SDK

This package allows any playdate project to use billboard-3d to render sprites.

# How to install

1. Add all files into your source folder. (or any desired folder)

2. Just import to any file that needs to use it.

# How to use

All projects must have a global "Renderer". All objects using 3D need to access it, and not having a global variable will give an error code. However, you can modify the code so it uses a local object instead.

display scale must be set to (2). (display scale 1 is possible, however performance will dip to lower 20s and maybe lower depending on how many objects are being rendered at once)

To add a 3D object to your scene:
Create a sprite (or whatever you're using) and create a reference for the "3d model". This is where the actual 3d object will be stored, and becomes a future reference for your object when needed. Next, punch in the coordinates, and input an image, and the object is ready to go.

Changing 3d object attributes in run time:
You can access and change variables within the 3d object at anytime. This can be used, for example, enemies or npcs that move, bullets the player shoots, or anything animated within the game scene. Changing images is also possible, which allows for animation too. (Animation should be done on an object basis instead of a billboard basis, so not too many timers are present at once)
