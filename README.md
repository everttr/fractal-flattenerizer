# Fractal Flattenerizer

A tool which visualizes the 3D projections of 4D fractals in a series of 2D cross sections. Supports the Mandelbrot set, Julia set, and Mandelbulb fractals. Highly configurable.

Made as my final project in Mike Bailey's Winter 2025 CS 457 at OSU. This project is really just pure GLSL shader code which is meant to run in Mike Bailey's lightweight OpenGL visualizer program [glman](https://web.engr.oregonstate.edu/~mjb/glman/). A portable .zip package that includes all dependencies is available on the GitHub repo's release.

All code in this repository by Reed Evertt. No rights reserved. Have fun with this one, you can get some really cool results!

## Features/Functionality
- Logic encapsulated within efficient geometry and fragment OpenGL shaders
- Implemented Fractals:
	- [**4D Julia Set**](https://en.wikipedia.org/wiki/Julia_set#Quadratic_polynomials): specifically the famous case where `f_c(x) = x^2 + c`. Tends to swirl and contains a lot of rings.
	- [**4D Mandelbrot Set**](https://en.wikipedia.org/wiki/Mandelbrot_set): the 2D shape you're familiar with extended into four dimensions. Really just a version of the Julia set with the inputs swapped.
	- [**3D Mandelbulb**](https://en.wikipedia.org/wiki/Mandelbulb): a 'Mandelbrot-like' fractal which uses spherical coordinates. Looks like a very bumpy sphere stretched bulbs along its surface.

## Video Demo + Screenshots
Below is my original video demo from CS 457 (with narration!):

https://github.com/user-attachments/assets/93c98181-37a8-4965-ac03-2550b1ded8f5

Below are some more screenshots of the myriad variegated fractals that can be generated:

<img src="https://raw.githubusercontent.com/everttr/fractal-flattenerizer/main/images/mandelbrot _horiz.png" alt="4D Offset Mandelbrot Set" width="450"/>

<img src="https://raw.githubusercontent.com/everttr/fractal-flattenerizer/main/images/julia_vertical.png" alt="4D Offset Julia Set" height="450"/>

<img src="https://raw.githubusercontent.com/everttr/fractal-flattenerizer/main/images/mandelbulb_order3.png" alt="Mandelbulb of Order 3" width="450"/>


## Installation/Operation
- Download and run glman.exe with required .dll's
	- Alternatively, download the ZIP release on the repo with everything included!
- Click "load a GLIB file" and select "finalProject.glib"
- Navigate to the "Main User Interface Window" to edit axis rendering, background color, and view transform *(warning: orthographic projection may break depth values)*
- Navigate to the "GLman Shader Parameter User Interface" to edit the following options and alter the rendered frame:
	- `uDepthRes`: the number of cross sections to create
	- `uDepth`, `uWidth`: the distance between and size of individual cross sections respectively
	- `uRotWithCam`: whether cross sections are rotated towards the camera, or always parallel to the XY-plane
	- `uType`: the type of fractal
		- `0`: a sphere with radius `uScale`, for testing purposes
		- `1`: 4D Julia set
		- `2`: 4D Mandelbrot set
		- `3`: 3D Mandelbulb set
	- `uScale`: size the fractal is rendered at/zoom level
	- `uIterCount`: maximum number of fractal iterations per pixel, determines detail & noisiness
	- `uW`: fourth dimensional starting coordinate *(only for Julia & Mandelbrot sets)*
	- `uOrder`: loosely, the density of surface bulbs *(only for Mandelbulb)*
	- `uZx`, `uZy`, `uZz`, `uZw`: fractal's offset or added constant *(`uZw` only for 4D Julia & Mandelbrot sets)*
	- `uFogStart`, `uFogEnd`: the start and end depth values to interpolate color values with
	- `uColor1`, `uColor2`: the far and near colors respectively
