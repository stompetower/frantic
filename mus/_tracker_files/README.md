# Game music in .AMU format

The `.MUS` files used by the game are in fact converted/compressed `.AMU` files. This directory contains the original `.AMU` files and can thus be edited with the music tracker used.

The music tracker used was [ANMA's RED](https://www.msx.org/news/software/en/anmas-red-music-recordereditor-available-for-download), which can be [downloaded here](https://www.msx.org/downloads/anmas-red-music-recordereditor-incuding-music-etc).

The `.AMU` files in this directory are exactly the same as the `.AMU` files mentioned in the download above.
The table below shows which `.AMU` files result in which `.MUS` files. Note that a `.AMU` file is first compressed into a `.CON` file, and finally renamed into a `.MUS` file.

Original `.AMU` file | After conversion/compression | Renamed to `.MUS` game file | Where used
---------------- | ------------------- | -------------------------- | ------------
FRANTIC1.AMU | FRANTIC1.CON | FRANTIC5.MUS | Job 1
FRANTIC2.AMU | FRANTIC2.CON | FRANTIC4.MUS | Job 1
FRANTIC3.AMU | FRANTIC3.CON | FRANTIC6.MUS | Job 2
FRANTIC4.AMU | FRANTIC4.CON | FRANTIC7.MUS | Job 2
FRANTIC5.AMU | FRANTIC5.CON | FRANTIC8.MUS | Job 3
FRANTIC6.AMU | FRANTIC6.CON | FRANTIC9.MUS | Job 3
FRANTIC7.AMU | FRANTIC7.CON | FRANTICA.MUS | Job 4
FRANTIC8.AMU | FRANTIC8.CON | FRANTICB.MUS | Job 4
FRANTIC9.AMU | FRANTIC9.CON | FRANTICE.MUS | Job 6
FRANTICB.AMU | FRANTICB.CON | FRANTICC.MUS | Job 5
FRANTICC.AMU | FRANTICC.CON | FRANTICD.MUS | Job 5
FRINTRO.AMU | FRINTRO.CON | FRANTIC2.MUS | Intro / story
FREINDE.AMU | FREINDE.CON | FRANTIC3.MUS | Ending
FRCONT.AMU | FRCONT.CON | FRANTIC1.MUS [*] | Continue
FRGERED.AMU | FRGERED.CON | FRANTIC1.MUS [*] | Job finished
FRTALK.AMU | FRTALK.CON | FRANTIC1.MUS [*] | Talking Cramp

[*] The last 3 songs are small music files that are binary concatenated. For example, this can be done in
MSX DOS (or in Windows Command Prompt) in the following way:

```
COPY FRTALK.CON/B + FRCONT.CON/B + FRGERED.CON/B FRANTIC1.MUS
```

## How to modify / build `.MUS` files

You need [this download](https://www.msx.org/downloads/anmas-red-music-recordereditor-incuding-music-etc) (same as mentioned above) which contains:
- the music tracker ANMA's RED.
- the Converter-tool (to convert/compress `.AMU` to `.CON`).
- all original music (`.AMU` files)

You also need a MSX-2 (or higher) with at least 256kB of RAM. This can also be an emulated MSX-2, of course. During development in 1992, the [Sony HB-F700P](https://www.msx.org/wiki/Sony_HB-F700P) was used.

Finally, the workflow is as follows:
- Modify / create / edit music using the tracker RED.
- Convert `.AMU` file to `.CON` file using the converter-tool.
- Rename `.CON` (=CONverted) to `.MUS` (used in game products).
- This `.MUS` music binaries are loaded by the loader (`loader.asm`) and played by the replayer (`replayer.asm`).

## More info

See the sub-directory `_tracker_RED` for more info about the tracker RED like:
- a short manual.
- a complete list of all effects.
- all custom instruments.

