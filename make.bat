:: Frantic Makefile (Windows)

@echo off
:: Z80 Glass cross-assembler
set glass="glass-0.5.jar"

:: location of Java, if not in PATH
set java8="C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe"

:: if java in PATH
set java8="java"

@echo on

:: Create directory 'dsk' to store final MSX files
if not exist dsk mkdir dsk

:: Executables
%java8% -jar %glass% src\loader.asm dsk\FRANTIC.LOD
%java8% -jar %glass% src\intro.asm dsk\FRANTIC1.BIN
%java8% -jar %glass% src\game.asm dsk\FRANTIC2.BIN
%java8% -jar %glass% src\einde.asm dsk\FRANTIC3.BIN
%java8% -jar %glass% src\replayer.asm dsk\FRANTIC.REP

:: Jobs, texts and enemy data
%java8% -jar %glass% jobs\stage1.asm STAGE1.BIN
%java8% -jar %glass% jobs\stage2.asm STAGE2.BIN
%java8% -jar %glass% jobs\stage3.asm STAGE3.BIN
%java8% -jar %glass% jobs\stage4.asm STAGE4.BIN
%java8% -jar %glass% jobs\stage5.asm STAGE5.BIN
%java8% -jar %glass% jobs\stage6.asm STAGE6.BIN

:: Combine stage with map data to JOB file
copy jobs\MAP1.BIN/B + STAGE1.BIN/B dsk\FRANTIC1.JOB
copy jobs\MAP2.BIN/B + STAGE2.BIN/B dsk\FRANTIC2.JOB
copy jobs\MAP3.BIN/B + STAGE3.BIN/B dsk\FRANTIC3.JOB
copy jobs\MAP4.BIN/B + STAGE4.BIN/B dsk\FRANTIC4.JOB
copy jobs\MAP5.BIN/B + STAGE5.BIN/B dsk\FRANTIC5.JOB
copy jobs\MAP6.BIN/B + STAGE6.BIN/B dsk\FRANTIC6.JOB

:: copy musics and graphics
copy mus\*.MUS dsk
copy gfx\*.GRP dsk

:: Remove stage binaries (which are now part of FRANTIC?.JOB)
del STAGE*.BIN

