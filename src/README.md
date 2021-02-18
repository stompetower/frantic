# Source code files (`.asm`)

The following table shows the relationship between the source code files and the resulting binary files:


Source code file | Resulting binary file | What's in it
-------- | ---- | ------
**loader.gen** | FRANTIC.LOD | Loading files, uncrunch graphics, copy protection [*]
 | | |
**replayer.gen** | FRANTIC.REP | replayer for music and sound effects
 | | |
**intro.gen** | FRANTIC1.BIN | Intro Main code
*amazing.gen* | FRANTIC1.BIN | Amazing ANMA (code + sound effects)
*bubble.gen* | FRANTIC1.BIN | Amazing ANMA (mainly data)
*titel.gen* | FRANTIC1.BIN | Title screen, story, credits
 | | |
**game.gen** | FRANTIC2.BIN | Game main code
*subs.gen* | FRANTIC2.BIN | Sub-routines, sound-effects, palette data, etc.
*praat.gen* | FRANTIC2.BIN | Cramp talking, talking when job done
*vrij.gen* | FRANTIC2.BIN | Enemy behaviour
 | | |
**einde.gen** | FRANTIC3.BIN | Game Ending Demo

Non-Italic and Bold file names are the main source code files (the others are includes).

[*] copy protection (floppy bad sector check) is removed.


# Some info about the source code

Below a little extra info about the source code.

## Some interesting/important pieces of code

- in `game.asm`, label `STANDINT`: this is the interrupt handler (called from `00038H`) during game play.
- in `game.asm`, label `HOOFDLUS1`/`HOOFDLUS2`: main loop during game play
- in `game.asm`, label `EINDGOED` (and beyond): some game variables
- in `subs.asm`, label `FRANFIADR` (and beyond): some game variables
- in `subs.asm`, label `SPRITEATR`: sprite attribute table that is copied to VRAM every interrupt
- in `subs.asm`, label `COPYFRANC`: Franc sprite pattern is copied to sprite pattern table (each animation step).
- in `vij.asm`, label `VIJTABEL`: table with active enemies during game play
- in `vij.asm`, label `PERVIJAND`: sprite-colors per enemy type
- in `loader.asm`, label `BEVEIL`: check copy protection (bad sector); hang system if no bad sector.
- in `loader.asm`, label `UNCRUN`: uncrunch graphics (fill VRAM with graphics from compressed RAM data)

## Color palette data


A label with `PAL` or `PALLET` often defines a color palette (32 bytes of data). There are
different color palettes used during the intro and game play. A color palette specific for a
Level/Job is defined in the Job-data (`stage?.asm` file in `jobs` directory).


## VDP-commands

A label with suffix `COMM` is often a VDP-command (mostly to copy a screen area), for example:
```
LETTERCOMM: DEFW 0            ;From (X)
            DEFB 191,2        ;From (Y)
            DEFW 0            ;To (X)
            DEFB 0,0          ;To (Y)
            DEFW 8            ;#pixels horizontal
            DEFW 8            ;#pixels vertical
            DEFB 000H         ;color
            DEFB 00000000B    ;mode of copy
            DEFB 11010000B    ;Command/Logop
            ;(these 15 bytes are sent to VDP registers 32 to 46)
```


## Naming of labels in source code

For naming of labels, Dutch and English words are mixed. Labels are generally quite short, due to restrictions of the originally used Z80-assembler. 
Just a few Dutch words/abbreviations that are used for naming (and what they mean in English):

Label / part of label (Dutch) | Meaning (English)
----------------- | -------------------
`FRANC`/`FR`/`F` | Franc, the player
`VIJ` | enemy
`SPUUG`/`SPUGEN` | spit
`SPIES`/`SPIEZEN` | skewers
`DRUPPEL` | water drop
`KANON` | canon
`KNAGER` | yellow digger
`SPIN` | spider
`VOGEL` | bird
`KANGA` | kangaroo
`RAT` | yellow animal with tail, rat-like
`ONTPLOF` | explosion
`LIFT` | hovering platform
`RAAK` | collision detection
`DIEN`/`DIENBL`/`DIENBLAD` | tray
`DEKS`/`DEKSEL` | tray cover
`ROTS` | red block/rock (that is able to move)
`BROS` | platform with crack
`KRACHT` | vitality
`DOOD` | dead
`VAL`/`VALLEN` | fall down
`KONT` | ass
`LOOP`/`LOPEN` | walk
`PRAAT` | talk/talking
`CRAMP` | Earl Cramp, the hostage taker





