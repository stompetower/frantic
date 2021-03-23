# Sprite patterns

In this directory you can see how the sprite patterns look without color information.

For example, there are 128 sprites of the player Franc (32 positions of 4 sprites each) as you can see in the image below. 

![Franc sprites](game_franc.png)

Go to [`VIEW_IMAGES.md`](./VIEW_IMAGES.md) in this directory to view all sprite patterns.

All sprites are included in the game files `FRANTIC1.GRP` (intro sprites) and `FRANTIC3.GRP` (game sprites). The information in the `gfx/_vram_pages_in_png` directory explains exactly where the 'sprite pattern data' and 'sprite color data' is in VRAM. For example, the Franc sprites are in VRAM on page 1 from line 112 to line 143.


## Sprite pattern data in VRAM

In VRAM the sprite pattern data is typically stored in a bit-per-pixel manner. 
The table below shows where in VRAM the sprite patterns are stored when the game is running.

sprite patterns (see file in this directory) | game phase | Number of sprites | VRAM page | lines (Y)
-------- | ---- | ------- | ------- | -------
intro_amazing_anma.png | intro + story | 60 | 1 | 240-255
intro_title_story.png | intro + story | 24 | 2 | 240-255
game.png | game play | 48 | 1 | 240-251
game_franc.png | game play | 128 | 1 | 112-143 [*]
game_enemies.png | game play | 80 | 1 | 212-231 [*]

[*] pattern data of Franc and enemies are dynamically copied to the sprite pattern table.

See the directory [`gfx/_vram_pages_in_png`](../../../../../tree/main/gfx/_vram_pages_in_png) for more information.
