# FREditor - manual

With FReditor, you can edit the `MAP?.BIN` part of each Frantic `.JOB` file. See the parent directory for more information about the workflow and the structure of a `.JOB` file.


The tool is provided in this directory (`freditor.dsk`) or part of [this download](https://www.msx.org/downloads/anmas-frantic-sources). It is to be used on a real MSX-2 (or emulator).

## FReditor keyboard shortcuts


#### Items and food can be placed by using number keys

- `1` = bottle anti-poison
- `2` = water supply - for spitting
- `3` = bomb to blast away walls
- `4` = hamburger
- `5` = candy
- `6` = tray cocver to protect the tray
- `7` = spring shoes for higher jumps

#### Backgrounds can be placed by using the top-row of letters of keyboard

- `[TAB]` = place 1 block of standard background
- `Q` = place first background decoration, 2*2 blocks (not in Job 2)
- `W` = place second background decoration, 2*2 blocks (not in Job 2)
- `E` = place big background decoration, 4*4 blocks

#### the following backgrounds only apply to the very bottom: end of the job where the guest is

- `R` = place 1 block of standard background
- `T` = place window, 2*2 blocks
- `Y` = place painting, 2*2 blocks
- `U` = place dresser, 2*2 blocks
- `I` = place plant, 2*2 blocks
- `O` = place closet, 2*4 blocks
- `P` = place table / chair / person, 4*3 blocks

#### Platforms can be placed by using the middle-row of letters of keyboard

- `A` =  place normal platform
- `S` =  place fall-through platform (with crack)
- `D` =  place platform that leaks water drips
- `F` =  place platform skewers sticking out
- `G` =  place canon (put above platform) that shoots right
- `H` =  place canon (put above platform) that shoots left
- `J` =  place solid platform block (cannot be removed/blasted)
- `K` =  place red block (rock) that can be moved by pushing
- `L` =  place special platform that is used at the very bottom of a job

#### Side-elevators can be placed by using bottom-row of letters of keyboard


- `Z` =  place left elevator tube
- `X` =  place right elevator tube
- `C` =  place door left  (first type `C`, then `0`,`1`,`2`,`3`,`4`,`5`,`6`,`7`,`8`,`9`,`A`,`B`,`C`,`D`,`E` or `F`)
- `V` =  place door right (first type `V`, then `0`,`1`,`2`,`3`,`4`,`5`,`6`,`7`,`8`,`9`,`A`,`B`,`C`,`D`,`E` or `F`)
- (door `0` connects to door `1`,  `2` to `3`,  `4` to `5`, ..etc...,  `E` to `F`)
- (a left door never connects to a right door)

#### Place special backgrounds of Job 2 

- `B` =  place start of green vertical strand, 2*2 blocks
- `N` =  place middle of green vertical strand (connect more if desired), 2*2 blocks
- `M` =  place bottom of green vertical strand, 2*2 blocks

#### To clear / delete / insert rows or screens

- `[HOME]` =  clear horizontal row of blocks. Use `[SHIFT]+[HOME]` to clear visible screen
- `[DEL]` =  remove horizontal row of blocks. Always apply 2x due to background pattern
- `[INS]` =  insert horizontal row. Always apply 2x due to background pattern

#### To move around

- `[SHIFT]+cursors` =  move 1 screen up/down
- `[CTRL]+cursors`  =  move 10 screens up/down
- `[CAPS]+cursors`  =  move up/down without moving the cursor

#### Other (load, save, .. )

- `[SELECT]` =  Show HEX address of each location (use for enemy coding, like spiders,etc.)
- `[ESC]`    =  After `[ESC]`, type `L` for Load, `S` for Save, `P` for PICTURE-save.



