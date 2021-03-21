# Modifications (to the original code)

## Modifications that changed the binary

#### Solved unsafe PSG port directions

The openMSX emulator complained about *'unsafe PSG port directions'* and that *'real (older) MSX machines can get damaged by this'*.
In one location in `replayer.asm`, bit 6 of PSG register 7 was accidentally set to `1`. This is corrected as follows:

```
PSGRUISOFF:
	...
	...
    LD      BC,0B807H       ; original: LD BC,0F807H
    JP      WRTPSG          ; reg7=0B8 = 10111000 -> noise off, tone on
```
The data byte (Z80 register B) is now `B8` (hex) instead of `F8` (hex).

#### Removed copy protected (bad sector check)

The original game had a deliberate bad sector on the floppy disk which was checked by `loader.asm`. This made it more difficult to copy the game.
This copy protection is now removed as follows:
```
BEVEIL2:
    ...
    XOR     A
    CALL    BEVEIL4
    POP     BC
    POP     DE
    POP     HL
    POP     IX
    NOP             ; original:  JP C,HANG instead of 3x NOP
    NOP
    NOP
    INC     E
    XOR     A
    CALL    BEVEIL4
    NOP             ; original:  JP NC,HANG instead of 3x NOP
    NOP
    NOP
    RET
```

#### Padding at the end of some binaries

The original binaries have some unused random bytes at the end of the file. 
In this repository these random unused bytes have been replaced by `00` bytes.


## Modifications that did NOT change the binary

- Made code suitable for [Z80 Glass assembler](http://www.grauw.nl/projects/glass/).
- [`replayer.asm`](replayer.asm) has been commented extensively.
- Added some `EQU` pragma's for entries to music/sound effect routines (example: `REPLAYROUT: EQU 0003H`) for more readable code.


