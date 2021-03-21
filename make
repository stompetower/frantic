#!/bin/bash

# Frantic Makefile (Linux)
# ensure java runtime is installed. If not: sudo apt install openjdk-8-jre

# Z80 Glass cross-assembler
GLASS="glass-0.5.jar"

# Create directory 'dsk' to store final MSX files
mkdir -p dsk

# Build executables
java -jar $GLASS src/loader.asm dsk/FRANTIC.LOD
java -jar $GLASS src/intro.asm dsk/FRANTIC1.BIN
java -jar $GLASS src/game.asm dsk/FRANTIC2.BIN
java -jar $GLASS src/einde.asm dsk/FRANTIC3.BIN
java -jar $GLASS src/replayer.asm dsk/FRANTIC.REP

# Jobs, texts and enemy data
java -jar $GLASS jobs/stage1.asm STAGE1.BIN
java -jar $GLASS jobs/stage2.asm STAGE2.BIN
java -jar $GLASS jobs/stage3.asm STAGE3.BIN
java -jar $GLASS jobs/stage4.asm STAGE4.BIN
java -jar $GLASS jobs/stage5.asm STAGE5.BIN
java -jar $GLASS jobs/stage6.asm STAGE6.BIN

# Combine stage with map data to JOB file
cat jobs/MAP1.BIN STAGE1.BIN > dsk/FRANTIC1.JOB
cat jobs/MAP2.BIN STAGE2.BIN > dsk/FRANTIC2.JOB
cat jobs/MAP3.BIN STAGE3.BIN > dsk/FRANTIC3.JOB
cat jobs/MAP4.BIN STAGE4.BIN > dsk/FRANTIC4.JOB
cat jobs/MAP5.BIN STAGE5.BIN > dsk/FRANTIC5.JOB
cat jobs/MAP6.BIN STAGE6.BIN > dsk/FRANTIC6.JOB

# copy musics and graphics
cp mus/*.MUS dsk
cp gfx/*.GRP dsk

# Remove stage binaries (which are now part of FRANTIC?.JOB)
rm STAGE*.BIN

