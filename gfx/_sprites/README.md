# Sprites

The original sprite designs are in the `_designs` subdirectory.
To see the final sprite patterns, see the `_final_patterns` subdirectory.
To see where the sprites are stored within the graphics, see the `_gfx/_vram_pages_in_png` directory.

The tools to convert the sprite designs to the right format for MSX (sprite pattern table, sprite color table), may be lost.



## Sprite colors

Most sprites in Frantic make use of a VDP feature to get 3 colors 
(possible on each horizontal line) when using 2 sprites. The third (bonus) color appears where the 2 sprites have overlapping pixels. That color number is the logical 'OR' of the other 2 colors.

To get this feature, bit 6 in the sprite color table has to be set true
for one of the two sprites that represents the character or enemy.

In Frantic, these sprites (during game play) use this 3-color feature:
- Franc and his tray
- all enemies
- hovering platforms
- explosion

Some examples of 3-color combinations used in the game:

color1 | color2 | color1 OR color2 | comment
-------- | ---- | ------- | -------
1 | 14 | 15 | light blue, blue, black
3 | 13 | 15 | brown, pink, black
5 | 10 | 15 | light green, green, black
7 | 11 | 15 | grey, white, black
6 | 9 | 15 | dark yellow, yellow, black
3 | 9 | 11 | brown, yellow, white
6 | 11 | 15 | dark yellow, white, black
3 | 14 | 15 | brown, dark blue, black

See `palettes.png` where the color palette for each stage/job is shown. There you can see that only the colors 2, 4, 8 and 12 vary per job/stage of the game.
None of these colors (that will change with each job) are used in sprite graphics.

These (more simple) sprites do not use the 3-color feature:
- skewers
- bullets
- spit
- water drop

## Sprite Attribute Table during game play

Sprite attributes (Y, X, pattern, color) are kept in RAM and copied to VRAM every interrupt.
See code-file `subs.asm`, label `SPRITEATR` (32 x 4 bytes of data are defined here). 

The maximum of 32 sprites are used as follows:

Sprite index: | Usage:
-------- | ----
0 | spit
1,2 | the tray
3,4,5,6 | Franc himself 
7,8,9 | water drops (3x), max 3 drops on the screen
10,11 | bullets (2x), max 2 bullets on the screen
12,13 | skewer (1)
14,15 | skewer (2)
16,17 | enemy (1)
18,19 | enemy (2)
20,21 | enemy (3)
22,23 | enemy (4)
24,25 | enemy (5)
26,27 | red block/rock during movement
28,29 | moving/hovering platform (1)
30,31 | moving/hovering platform (2)

Note that there are max 2 skewers, 5 enemies and 2 moving/hovering platforms on the screen simultaneously.

