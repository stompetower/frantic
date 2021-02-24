## Loaded graphics in visible PNG format

The game graphics (`.GRP` files) are loaded by the code in `loader.asm`, where the graphics data is uncrunched and copied to the desired area in VRAM.

The files in this directory show exactly (in `.png` format) which graphics are loaded in which VRAM page in which phase of the game (intro, gameplay, ending).

Go to [`VIEW_IMAGES.md`](./VIEW_IMAGES.md) in this directory to view all graphics.

file in this directory | game phase | which VRAM page
-------- | ---- | -------
`intro_page1_palette_X.png` | intro + story | 1
`intro_page2_palette_X.png` | intro + story | 2
`intro_page3_palette_X.png` | intro + story | 3
`game_job?_page1.png` | game play | 1
`game_page2_palette_X.png` | game play | 2
`ending_page1.png` | ending | 1
`ending_page2_palette_X.png` | ending | 2

Note that:
- `_palette_X` in the above table means that the same graphics data is represented by multiple `.png` files (where `X` = `A`/`B`/`C`, etc.), each time with a different color palette.
- All graphics are made for SCREEN 5 mode (16 colors, from palette of 512 colors).
- In SCREEN 5 mode, there are 4 pages (0, 1, 2 and 3).
- The visible page in Frantic is always VRAM page 0.



## Area's with sprite data

Some parts of the `.PNG` files in this directory contain graphics data that is not directly viewable.
Most of these is 'sprite pattern data', which is stored as 1 bit per pixel (with color data in another data structure).

See the table below:

file in this directory | from line (Y) | #lines | description
-------- | ---- | ------- | -------
intro_page1_palette_X.png | 240 | 16 | sprite pattern data during intro (Amazing ANMA)
intro_page2_palette_X.png | 240 | 16 | sprite pattern data during intro (story part)
game_job?_page1.png | 112 | 32 | sprite pattern data of animating Franc (32 x 4 sprites)
game_job?_page1.png | 212 | 20 | sprite pattern data of animating enemies
game_job?_page1.png | 232 | 4 | sprite color table [*1]
game_job?_page1.png | 240 | 12 | sprite pattern data of 'static' game sprites (48 sprites)
game_job?_page1.png | 252 | 4 | sprite pattern data of 'dynamic' game sprites [*2]

- [*1] parts of the sprite color table are updated dynamically in code
- [*2] animating sprites (Franc + enemies) are copied to here in code (16 sprites)

See the `_sprites` directory in this repository for more information about sprites.



