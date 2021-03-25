# Sprite patterns

In this directory you can see how the sprite patterns look without color information.

For example, there are 128 sprites of the player Franc (32 positions of 4 sprites each) as you can see in the image below. 

![Franc sprites](game_franc.png)

Go to [`VIEW_IMAGES.md`](./VIEW_IMAGES.md) in this directory to view all sprite patterns.

All sprites are included in the game files `FRANTIC1.GRP` (intro & story sprites) and `FRANTIC3.GRP` (game sprites). 


## Sprite pattern data in VRAM

In VRAM the sprite pattern data is typically stored in a bit-per-pixel manner. 
The table below shows where in VRAM the sprite patterns are stored when the intro graphics or game graphics are loaded.

sprite patterns (see file in this directory) | game phase | Number of sprites | VRAM page
-------- | ---- | ------- | -------
intro_amazing_anma.png | intro + story | 60 | 1 (lines 240-254)
intro_title_story.png | intro + story | 24 | 2 (lines 240-245)
game.png | game play | 48 | 1 (lines 240-251)
game_franc.png | game play | 128 | 1 (lines 112-143) [*]
game_enemies.png | game play | 80 | 1 (lines 212-231) [*]

[*] pattern data of Franc and enemies are dynamically copied to the sprite pattern table.

See the directory [`gfx/_vram_pages_in_png`](../../../../../tree/main/gfx/_vram_pages_in_png) for more information.
