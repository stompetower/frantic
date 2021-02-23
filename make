#!/bin/bash

# ensure java runtime is installed
#  if not: sudo apt install openjdk-8-jre


mkdir dsk
java -jar glass-0.5.jar src/loader.asm dsk/FRANTIC.LOD
java -jar glass-0.5.jar src/intro.asm dsk/FRANTIC1.BIN

