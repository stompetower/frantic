## Frantic Map Maker - made with Microsoft Visual Studio 2017

This is a little 'Windows Forms' project to generate maps of Frantic
(big `.png` images) based on the original `.JOB` files of the game.

It was made with Visual Studio 2017, but it will probably compile perfectly
with newer versions of Visual Studio (or even older versions too).

The code is somewhat 'quick-and-dirty' due to the one-time purpose of just
generating the maps.

It can help however to analyse the structure of the `.JOB` files of Frantic.



## How to use

- Install Microsoft Visual Studio 2017 (or newer/compatible) (Community Edition is free).
- Open the project in Visual Studio (`FranticMapMaker.csproj`).
- Compile the project.
- Copy `frantic.png` to the folder where `FranticMapMaker.exe` resides (normally `bin\Debug` or `bin\Release`).
- Also copy `FRANTIC?.JOB` (where ? = `1`/`2`/`3`/`4`/`5`/`6`) to the same folder (this are the `.JOB` files of the original game).
- Now run `FranticMapMaker.exe` (or run it from within Visual Studio).
- Choose a Job number and click the 'Make Map' button.
- A file `Frantic_Job?.png` will be created.


