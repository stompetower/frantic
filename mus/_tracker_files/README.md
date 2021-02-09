# Game music in .AMU format

The `.MUS` files used by the game are in fact converted/compressed `.AMU` files. This directory contains the original `.AMU` files and can thus be edited with the music tracker used.

The music tracker used was [ANMA's RED](https://www.msx.org/news/software/en/anmas-red-music-recordereditor-available-for-download), which can be [downloaded here](https://www.msx.org/downloads/anmas-red-music-recordereditor-incuding-music-etc).

The `.AMU` files here are exactly the same as the `.AMU` files mentioned in the download above. The table below shows which `.AMU` files result in which `.MUS` files after conversion/compression.

`.AMU` file name | `.MUS` file in game
---------------- | -------------------
FRANTIC1.AMU | FRANTIC5.MUS
FRANTIC2.AMU | FRANTIC4.MUS
FRANTIC3.AMU | FRANTIC6.MUS
FRANTIC4.AMU | FRANTIC7.MUS
FRANTIC5.AMU | FRANTIC8.MUS
FRANTIC6.AMU | FRANTIC9.MUS
FRANTIC7.AMU | FRANTICA.MUS
FRANTIC8.AMU | FRANTICB.MUS
FRANTIC9.AMU | FRANTICE.MUS
FRANTICB.AMU | FRANTICC.MUS
FRANTICC.AMU | FRANTICD.MUS
FRINTRO.AMU | FRANTIC2.MUS
FREINDE.AMU | FRANTIC3.MUS
FRCONT.AMU | FRANTIC1.MUS (*)
FRGERED.AMU | FRANTIC1.MUS (*)
FRTALK.AMU | FRANTIC1.MUS (*)

The last 3 songs are small music files that are binary concatenated. For example, this can be done in
MSX DOS (or in Windows Command Prompt) in the following way:

```
COPY FRTALK.CON/B + FRCONT.CON/B + FRGERED.CON/B FRANTIC1.MUS
```

## How to make `.MUS` files from `.AMU`


To do
