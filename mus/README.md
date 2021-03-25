# Frantic Music (`.MUS` files)

To run the game, only these `.MUS` files are needed. These will be copied by the make script in this repository.

If you want to change the music, look inside the [`mus/_tracker_files`](./_tracker_files) subdirectory.  
To see the music in readable `.TXT` format, look inside the [`mus/_tracker_files_txt`](./_tracker_files_txt) subdirectory.  
To learn more about the music tracker RED, look inside the [`mus/_tracker_RED`](./_tracker_RED) subdirectory.

Each song in a `.MUS` file starts with an identifier `MUSC` (bytes in hex notation: `4d 55 53 43`) which indicates that the real song data starts straight after this. 

All `.MUS` files contain just a single song, except for `FRANTIC1.MUS` which contains 3 small songs. So, in `FRANTIC1.MUS` this identifier `MUSC` is there 3 times (at offsets `0`, `7A3H` and `E38H`). If you change these songs, the offsets `7A3H` and `E38H` may change. This means that the offsets should also be changed in `game.asm`.

